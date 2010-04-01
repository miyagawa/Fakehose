package Fakehose::Handler::Root;
use strict;
use parent qw(Tatsumaki::Handler);

sub get {
    my $self = shift;
    $self->write("Welcome to fakehose!");
}

1;
