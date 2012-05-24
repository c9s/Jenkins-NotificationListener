#!/usr/bin/env perl
use Test::More;
use Jenkins::NotificationListener;
use AnyEvent::Socket;
use Time::HiRes qw(usleep);

my $cv = AnyEvent->condvar;

Jenkins::NotificationListener->new( host => undef , port => 8888 , on_notify => sub {
    my $payload = shift;   # Jenkins::Notification;
    $cv->send;

    ok $payload;

})->start;

usleep 1000;

tcp_connect "localhost", 8888, sub {
    my ($fh) = @_
        or die "localhost failed: $!";

    ok $fh;

    print $fh <<'JSON';
{
    "name":"JobName",
    "url":"JobUrl",
    "build":{
        "number": 1,
        "phase": "STARTED",
        "status": "FAILED",
        "url":"job/project/5",
        "fullUrl":"http://ci.jenkins.org/job/project/5",
        "parameters":{
            "branch":"master"
        }
    }
}
JSON

    # enjoy your filehandle
};

$cv->recv;


done_testing;
