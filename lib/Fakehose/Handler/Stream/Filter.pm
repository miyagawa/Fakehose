package Fakehose::Handler::Stream::Filter;
use strict;
use parent qw(Fakehose::Handler::Stream);
__PACKAGE__->asynchronous(1);

sub post {
    my $self = shift;

    my $listener = Fakehose::Listener->new_from_hanlder($self);

    my $p = $self->request->parameters;
    if ($p->{follow}) {
        $listener->follow([ split /,\s*/, $p->{follow} ]);
    }

    if ($p->{track}) {
        $listener->track([ split /,\s*/, $p->{track} ]);
    }

    if ($p->{locations}) {
        $listener->locations([ split /,\s*/, $p->{locations} ]);
    }

    $self->start_streaming($listener);
}

1;
