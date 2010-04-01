package Fakehose::Handler::Stream;
use strict;
use parent qw(Tatsumaki::Handler);
__PACKAGE__->asynchronous(1);

use JSON;
use Fakehose::Listener;
use Tatsumaki::MessageQueue;

my $mq = Tatsumaki::MessageQueue->instance('tweets');

# "every object is returned on its own line, and ends with a carriage
# return. Newline characters (\n) may occur in object elements (the
# text element of a status object, for example), but carriage returns
# (\r) should not."

# TODO: support delimited response?
# TODO: support XML response?

sub get_chunk {
    my $self = shift;

    if (ref $_[0]) {
        my $json = JSON::encode_json($_[0]);
        $json =~ tr/\r//d;
        return $json . "\r\n";
    } else {
        return $_[0] . "\r\n";
    }
}

sub prepare {
    # TODO authenticate here and throws 401
}

sub start_streaming {
    my($self, $listener) = @_;

    # TODO: periodic empty status return
    # TODO: support deletion notices
    # TODO: support limitaiton notices

    $self->response->content_type('application/json');

    # TODO call poll_once for backlogging

    $mq->poll($listener->id, sub {
        my @events = @_;
        for my $event (grep $listener->filter($_), @events) {
            $listener->push($event);
        }
    });

    my $t; $t = AE::timer 60, 60, sub {
        scalar $t;
        $listener->push("\n");
    };
}

1;
