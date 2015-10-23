#!/usr/bin/perl

use IO::Socket;
use Sys::Hostname;         # hostname function

my $h = hostname;

        my $client = new IO::Socket::INET(
                         PeerAddr => 'X.Y.90.71',
                         PeerPort => 12206,
                         Timeout => 5,
                         Proto => 'udp',
        );


        my $log = sprintf ("{ \"version\": \"1.1\", \"host\": \"$h\", \"short_message\": \"Blocked IP Log \", \"hService\": \"FTP\" }",$h);
        $client->send ($log) or die "failed";

        # terminate the connection when we're done
        close($client);


