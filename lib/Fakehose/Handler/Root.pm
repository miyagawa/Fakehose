package Fakehose::Handler::Root;
use strict;
use parent qw(Tatsumaki::Handler);

sub get {
    my $self = shift;
    my $env  = $self->request->env;
    my $base = "http://$env->{SERVER_NAME}:$env->{SERVER_PORT}";
    $self->write(<<HTML);
<html>
<head><title>Fakehose</title></head>
<body>
<h1>Congrats! Your Fakehose is running!</h1>
<p>Your twitter streaming client can connect to $base/1/statuses/filter.json etc. for testing.</p>
<p>Also you can POST arbitrary JSON to $base/_fakehose/inject to generate new events.</p>
</body>
HTML
}

1;
