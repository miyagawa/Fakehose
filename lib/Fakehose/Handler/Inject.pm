package Fakehose::Handler::Inject;
use strict;
use parent qw(Tatsumaki::Handler);
__PACKAGE__->asynchronous(1);

use JSON;
use Tatsumaki::MessageQueue;

my $mq = Tatsumaki::MessageQueue->instance('tweets');

sub post {
    my $self = shift;

    my $json = $self->request->content;
    if ($json) {
        warn "Got $json";
        $mq->publish( JSON::decode_json($json) );
        $self->write({ status => 'ok' });
        $self->finish;
    } else {
        Tatsumaki::HTTPException->throw(400);
    }
}

1;
