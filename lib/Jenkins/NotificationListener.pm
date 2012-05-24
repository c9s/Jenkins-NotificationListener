package Jenkins::NotificationListener;
use strict;
use warnings;
our $VERSION = '0.01';

use Net::Jenkins;
use Net::Jenkins::Job;
use Net::Jenkins::Job::Build;
use AnyEvent::Socket;
use Moose;
use methods;
use JSON::XS;
use Try::Tiny;

has host => (is => 'rw');

has port => (is => 'rw', isa => 'Int');

has on_notify => (is => 'rw');

has on_error => (is => 'rw', default => sub { 
    return sub { warn @_; };
});

method start {
    tcp_server $self->host, $self->port , sub {
        my ($fh, $host, $port) = @_;
        my $content = '';
        my $buf = '';
        while( my $bytes = sysread $fh, $buf, 1024 ) {
            $content .= $buf;
        }

        eval {
            if( $content ) {
                my $json = decode_json $content;
                $self->on_notify->( $json );
            } else {
                die 'Empty content';
            }
        };
        if ( $@ ) {
            $self->on_error->( $@ );
        }
    };
}

1;
__END__

=head1 NAME

Jenkins::NotificationListener -

=head1 SYNOPSIS

  use Jenkins::NotificationListener;

=head1 DESCRIPTION

Jenkins::NotificationListener is

=head1 AUTHOR

Yo-An Lin E<lt>cornelius.howl {at} gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
