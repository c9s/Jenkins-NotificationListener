package Jenkins::Notification;
use warnings;
use strict;
use Moose;
use Net::Jenkins::Utils qw(build_job_object build_build_object);
use Net::Jenkins::Job;
use Net::Jenkins::Job::Build;

# job name
has name => ( is => 'rw' , isa => 'Str' );

# job url
has url => ( is => 'rw', isa => 'Str' );

has build => ( is => 'rw' , isa => 'Net::Jenkins::Job::Build' );

has job => ( is => 'rw', isa => 'Net::Jenkins::Job' );

has parameters => ( is => 'rw' );

sub BUILDARGS {
    my ($self,%args) = @_;

    $args{job} = build_job_object $args{url};

    my $build_args = delete $args{build};
    my $build_url = $build_args->{fullUrl};

    $args{build} = build_build_object $build_url;

    # use Data::Dumper; warn Dumper( \%args );
    # build JOB, BUILD objects
    return \%args;
}

1;
