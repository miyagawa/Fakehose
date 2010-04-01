package Fakehose;

use strict;
use 5.008_001;
our $VERSION = '0.01';

use Tatsumaki::Application;
use Tatsumaki::Handler;

sub h($) {
    my $class = shift;
    eval "require $class" or die $@;
    $class;
}

sub webapp {
    my $class = shift;

    my $app = Tatsumaki::Application->new([
        '/1/statuses/filter.json'   => h 'Fakehose::Handler::Stream::Filter',
#        '/1/statuses/firehose.json' => h 'Fakehose::Handler::Stream::Firehose',
#        '/1/statuses/links.json'    => h 'Fakehose::Handler::Stream::Links',
#        '/1/statuses/retweet.json'  => h 'Fakehose::Handler::Stream::Retweet',
        '/1/statuses/sample.json'   => h 'Fakehose::Handler::Stream::Sample',
        '/_fakehose/inject' => h 'Fakehose::Handler::Inject',
        qr'^/$' => h 'Fakehose::Handler::Root',
    ]);

    $app->psgi_app;
}


1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

Fakehose - Fake Twitter firehose simulator

=head1 SYNOPSIS

  fakehose

=head1 DESCRIPTION

Fakehose is a fake Twitter streaming API server that allows you to
inject events using HTTP POST (with tools such as LWP or curl) to
generate fake events.

=head1 INSTALLATION

  git clone git://github.com/miyagawa/Fakehose.git
  cd Fakehose
  cpanm .

You might need to sudo when running cpanm. If you don't have cpanm
installed, you can also do:

  curl -L http://cpanmin.us | perl - .

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<AnyEvent::Twitter::Stream> L<http://apiwiki.twitter.com/Streaming-API-Documentation>

=cut
