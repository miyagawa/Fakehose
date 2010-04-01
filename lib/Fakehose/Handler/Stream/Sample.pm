package Fakehose::Handler::Stream::Sample;
use strict;
use parent qw(Fakehose::Handler::Stream);
__PACKAGE__->asynchronous(1);

sub get {
    my $self = shift;

    my $listener = Fakehose::Listener->new_from_hanlder($self);
    $self->start_streaming($listener);
}

1;
