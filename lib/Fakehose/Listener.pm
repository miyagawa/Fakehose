package Fakehose::Listener;
use strict;
use Any::Moose;

has id        => (is => 'rw', isa => 'Str', default => sub { rand(1) });
has follow    => (is => 'rw', isa => 'ArrayRef[Int]');
has count     => (is => 'rw', isa => 'Int');
has track     => (is => 'rw', isa => 'ArrayRef[Int]');
has locations => (is => 'rw', isa => 'ArrayRef[Num]');
has retweet   => (is => 'rw', isa => 'Bool');
has links     => (is => 'rw', isa => 'Bool');
has handler   => (is => 'rw', isa => 'Tatsumaki::Handler');

sub new_from_hanlder {
    my($class, $handler) = @_;

    my $p = $handler->request->parameters;

    my $self = $class->new(handler => $handler);

    if ($p->{count}) {
        $self->count($p->{count});
    }

    $self;
}

sub push {
    my $self = shift;
    $self->handler->stream_write(@_);
}

sub filter {
    my($self, $tweet) = @_;
    # TODO
    return 1;
}

1;
