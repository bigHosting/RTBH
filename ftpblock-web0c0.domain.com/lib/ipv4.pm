use Socket qw( inet_aton );  # ip methods

# http://www.mikealeonetti.com/wiki/index.php?title=Check_if_an_IP_is_in_a_subnet_in_Perl
sub ip2long_ipv4($)
{
        return( unpack( 'N', inet_aton(shift) ) );
}

sub in_subnet_ipv4($$)
{
        my $ip = shift;
        my $subnet = shift;

        my $ip_long = ip2long_ipv4( $ip );

        if( $subnet=~m|(^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$| )
        {
                my $subnet = ip2long_ipv4( $1 );
                my $mask = ip2long_ipv4( $2 );

                if( ($ip_long & $mask)==$subnet )
                {
                        return( 1 );
                }
        }
        elsif( $subnet=~m|(^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/(\d{1,2})$| )
        {
                my $subnet = ip2long_ipv4( $1 );
                my $bits = $2;
                my $mask = -1<<(32-$bits);

                $subnet&= $mask;

                if( ($ip_long & $mask)==$subnet )
                {
                        return( 1 );
                }
        }
        elsif( $subnet=~m|(^\d{1,3}\.\d{1,3}\.\d{1,3}\.)(\d{1,3})-(\d{1,3})$| )
        {
                my $start_ip = ip2long_ipv4( $1.$2 );
                my $end_ip = ip2long_ipv4( $1.$3 );

                if( $start_ip<=$ip_long and $end_ip>=$ip_long )
                {
                        return( 1 );
                }
        }
        elsif( $subnet=~m|^[\d\*]{1,3}\.[\d\*]{1,3}\.[\d\*]{1,3}\.[\d\*]{1,3}$| )
        {
                my $search_string = $subnet;

                $search_string=~s/\./\\\./g;
                $search_string=~s/\*/\.\*/g;

                if( $ip=~/^$search_string$/ )
                {
                        return( 1 );
                }
        }

        return( 0 );
}

# IPv4 sort hash by IP http://www.perlmonks.org/?node_id=129566
sub ipsort_ipv4 {
        my @a = split /\./, $a;
        my @b = split /\./, $b;

        return $a[0] <=> $b[0]
            || $a[1] <=> $b[1]
            || $a[2] <=> $b[2]
            || $a[3] <=> $b[3];
}

# validate ipv4  ==>  modified from https://github.com/tonyskapunk/Networking/blob/master/ipinsub.pl
sub valid_ipv4_host {
        my $ipv4 = shift;

        # IPv4 /32 addresses should never start with 0
        return 0 if ( $ipv4 =~ /^0/ ) ;

        #if ($ipv4 =~ /^(1?\d\d?|2[0-4]\d|25[0-5])(\.(1?\d\d?|2[0-4]\d|25[0-5])){3}$/ ) {
        if ($ipv4 =~ /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/ && (( $1<=255  && $2<=255 && $3<=255  && $4<=255 )) )
        {
                return (1);
        }
        return (0);
}


#############################
#####  more iPv4 stuff  #####
#############################
# copied from https://github.com/tonyskapunk/Networking/blob/master/ipinsub.pl
# binbit2dec (8bits)
sub binbit2dec {
        my $bin = shift;
        return unpack("C", pack("B8", $bin));
}
# bin(32bit) to ipv4
sub bin2ipv4 {
        my $bin = shift;
        my @ip = ();
        $bin =~ s/([01]{8})([01]{8})([01]{8})([01]{8})/$1.$2.$3.$4/;
        my @octets = split(/\./, $bin);
        foreach my $octet (@octets) {
                push(@ip, binbit2dec($octet));
        }
        return join(".", @ip);
}
# Receives a valid cidr. Returns a network mask in ipv4.
sub cidr2Ipv4Mask {
        my $cidr = shift;
        my $bitmask = cidr2BitMask($cidr);
        my $netmask = bin2ipv4($bitmask);
        return $netmask;
}
# Receives a valid CIDR. # Returns a binary Network Mask(32bits) divided in 4 octets.
sub cidr2BitMask {
        my $cidr = shift;
        my $zero = substr("0"x(32 - $cidr), 0);
        my $one = substr("1"x$cidr, 0);
        my $netmask = "$one$zero";
        return $netmask;
}
# validate ipv4 (no trailing 0s)
sub validIPv4 {
        my $ipv4 = shift;
        if ($ipv4 =~ /^(1?\d\d?|2[0-4]\d|25[0-5])(\.(1?\d\d?|2[0-4]\d|25[0-5])){3}$/ ) {
                return 1;
        }
        return 0;
}
# validate a ipv4 subnet/cidr
sub validSubnet {
        my $subnet = shift;
        unless ( $subnet =~ /^\d{1,3}(\.\d{1,3}){3}\/\d{1,2}/) {
                printf "%s -> wrong IP/CIDR format\n", $subnet;
                return 0;
        }
        my ($ip, $cidr) = split (/\//, $subnet);
        unless ( validIPv4($ip) ) {
                printf "%s -> wrong IP\n", $ip;
                return 0;
        }
        unless ( ($cidr >= 11) and ($cidr <= 32) ) {
                printf "%s -> wrong CIDR\n", $cidr;
                return 0;
        }
        return 1;
}





1;
