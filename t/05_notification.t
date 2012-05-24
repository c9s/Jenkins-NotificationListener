#!/usr/bin/env perl
use Test::More;
use Jenkins::Notification;
use LWP::Simple qw(get);
use JSON::XS;

my $json = decode_json get 'http://ci.jruby.org/job/jruby-git/api/json';
my $build_id = $json->{lastBuild}->{number};
my $build_url = $json->{lastBuild}->{url};
ok $json;
ok $build_id;
ok $build_url;

my $payload = Jenkins::Notification->new( 
    name => 'jruby-git' , 
    url => 'http://ci.jruby.org/job/jruby-git',
    build => {
        number => $build_id,
        phase => "STARTED",
        status => "FAILED",
        url => "job/jruby-git/" . $build_id,
        fullUrl => $build_url,
        parameters => {
            branch => 'master'
        }
    }
);

ok $payload;

done_testing;
