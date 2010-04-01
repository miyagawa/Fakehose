#!perl
use strict;
use AnyEvent::Twitter::Stream;
use AnyEvent::HTTP;
use Getopt::Long;

my $fakehose = "127.0.0.1:5000";
my($username, $password);
GetOptions(
    "s|server=s"   => \$fakehose,
    "u|username=s" => \$username,
    "p|passwor=s"  => \$password,
    "h|help"       => sub { require Pod::Usage; Pod::Usage::pod2usage(0) },
);

my $inject_uri = "http://$fakehose/_fakehose/inject";

my $done = AE::cv;
my($method, %args) = @ARGV;

binmode STDOUT, ":utf8";

my $streamer = AnyEvent::Twitter::Stream->new(
    username => $username,
    password => $password,
    method   => $method || "sample",
    %args,
    on_tweet => sub {
        my $json = shift;
        http_post $inject_uri, $json,
            headers => { 'Content-Type' => 'application/json' },
            sub {
                my($body, $headers) = @_;
                if ($headers->{Status} == 200) {
                    warn "OK: Injected ", length($json), " bytes of JSON\n";
                } else {
                    warn "ERR: POSTing to $inject_uri failed: $headers->{Status}\n";
                }
            };
    },
    on_error => sub {
        my $error = shift;
        warn "ERROR: $error";
        $done->send;
    },
    on_eof   => sub {
        $done->send;
    },
    no_decode_json => 1,
);

$done->recv;

__END__

=head1 NAME

twitter-reproxy.pl - Proxy Twitter's streaming API response and inject them into fakehose

=head1 SYNOPSIS

  twitter-reproxy.pl username password
  twitter-reproxy.pl username password filter track keyword1,keyword2...

=cut
