package Jenkins::NotificationListener;
use strict;
use warnings;
our $VERSION = '0.01';

use Net::Jenkins;
use Net::Jenkins::Job;
use Net::Jenkins::Job::Build;
use Jenkins::Notification;
use AnyEvent::Socket;
use Moose;
use methods;
use JSON::XS;

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
                my $args = decode_json $content;
                my $payload = Jenkins::Notification->new( %$args , raw_json => $content );
                $self->on_notify->( $payload );
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

Jenkins::NotificationListener - is a TCP server that listens to messages from Jenkins Notification plugin.

=head1 SYNOPSIS

    use Jenkins::NotificationListener;
    Jenkins::NotificationListener->new( host => $host , port => $port , on_notify => sub {
        my $payload = shift;   # Jenkins::Notification;
        print $payload->name , " #" , $payload->build->number, " : " , $payload->status 
                    , " : " , $payload->phase
                    , " : " , $payload->url
                    , "\n";

    })->start;

=head1 DESCRIPTION

Jenkins::NotificationListener is a simple TCP server listens to messages from Jenkins' Notification plugin,

L<Jenkins::NotificationListener> uses L<AnyEvent::Socket> to create tcp server object, so it's a non-blocking implementation.

This tcp server reads JSON format notification from Jenkins Notification plugin, and creates payload object L<Jenkins::Notification>.
the payload object is built with L<Net::Jenkins::Job>,
L<Net::Jenkins::Job::Build> objects from the information that is provided from
notification json.

By using L<Jenkins::NotificationListener>, you can simple use the payload object to interact with Jenkins server.

To test your Jenkins notification plugin, you can also use L<jenkins-notification-listener.pl> script.

    $ jenkins-notification-listener.pl

=head1 INSTALLATION

    $ cpan Jenkins::Notification

    $ cpanm Jenkins::Notification

=head1 AUTHOR

Yo-An Lin E<lt>cornelius.howl {at} gmail.comE<gt>

=head1 SEE ALSO

L<Net::Jenkins>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
