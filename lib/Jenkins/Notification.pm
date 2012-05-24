package Jenkins::Notification;
use warnings;
use strict;
use Moose;
use Net::Jenkins::Job;
use Net::Jenkins::Job::Build;

# job name
has name => ( is => 'rw' , isa => 'Str' );

# job url
has url => ( is => 'rw', isa => 'Str' );

has build => ( is => 'rw' );

has job => ( is => 'rw' );

sub BUILDARGS {
    my ($self,%args) = @_;

    use Data::Dumper; warn Dumper( \%args );

    # build JOB, BUILD objects

    return \%args;
}

1;
