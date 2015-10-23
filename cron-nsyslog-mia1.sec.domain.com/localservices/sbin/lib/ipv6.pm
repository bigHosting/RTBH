# ipv6.pm version 1.0.1

# Changelog:
#         * 2015.10.08:  adding ( ip_compress_address, ip_expand_address, ip_bintoip, ip_iptobin ) functions from Net::IP

# IPv6: https://code.google.com/p/ipv6gen/ convert one char in hex to binary
sub hex2bin_c {
        my ($digit) = shift;
        return unpack("B4", pack("H", $digit));
}

# IPv6: https://code.google.com/p/ipv6gen/ convert string with hex representation to binary
sub hex2bin {
        my $in = shift;
        my $out;

        my @digits = split //, $in;
        for (@digits) {
                $out = $out . hex2bin_c($_);
        }
        return $out;
}

# IPv6: https://code.google.com/p/ipv6gen/
sub addr2bin {
        my $prefix = shift;
        my @sects = split(/:/, $prefix);
        my $s;
        my $tmp;
        my $addr_bin = "";

        for $s (@sects) {
                $tmp = &hex2bin($s);
                $addr_bin = $addr_bin . $tmp;
        }
        return $addr_bin;
}

# IPv6: https://code.google.com/p/ipv6gen/ check if smaller prefix fits into bigger prefix
# arg1: bigger IPv6 prefix, arg2: smaller IPv6 prefix
sub in_subnet_ipv6 {
        my $prefix1 = shift;
        my $prefix2 = shift;

        my $big_pfx_part;
        my $big_pfx_len;
        my $small_pfx_part;
        my $small_pfx_len;

        ($big_pfx_part, $big_pfx_len) = split(/\//, $prefix1);
        ($small_pfx_part, $small_pfx_len) = split(/\//, $prefix2);

        my $big_bits = &addr2bin($big_pfx_part);
        my $small_bits = &addr2bin($small_pfx_part);

        # smaller prefixlen makes bigger prefix
        if ($big_pfx_len > $small_pfx_len) {
                #print "bigger prefix should be specified first\n";
                return(0);
        }

        my $f = substr($big_bits, 0, $big_pfx_len);
        my $s = substr($small_bits, 0, $big_pfx_len);
        if ($f cmp $s) {
                return(0); # does not overlap
        }
        return (1); # overlapping
}

# validate ipv6
sub valid_ipv6_host {
        my $ipv6 = shift;

        # return (1) if ($ipv6 =~ /([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){5}::[0-9A-Fa-f]{1,4}/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){4}::[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,1}/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){3}::[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,2}/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){2}::[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,3}/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}::[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,4})/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}::[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,5}/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,6}::/);
        # return (1) if ($ipv6 =~ /::[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,6}/);
        # return (1) if ($ipv6 =~ /::/);

        my $match_ipv6 = qr/^(((?=(?>.*?::)(?!.*::)))(::)?([0-9A-F]{1,4}::?){0,5}|([0-9A-F]{1,4}:){6})(\2([0-9A-F]{1,4}(::?|$)){0,2}|((25[0-5]|(2[0-4]|1[0-9]|[1-9])?[0-9])(\.|$)){4}|[0-9A-F]{1,4}:[0-9A-F]{1,4})(?<![^:]:)(?<!\.)\z/i;

        if ($ipv6 =~ $match_ipv6)
        {
                return (1);
        }
        return (0);
}

sub valid_ipv6_subnet {
        my $ip = shift;
        my @temp = split ('/',$ip);
        my $ipv6 = @temp[0];
        # return (1) if ($ipv6 =~ /([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){5}::[0-9A-Fa-f]{1,4}/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){4}::[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,1}/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){3}::[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,2}/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){2}::[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,3}/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}::[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,4})/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}::[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,5}/);
        # return (1) if ($ipv6 =~ /[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,6}::/);
        # return (1) if ($ipv6 =~ /::[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4}){0,6}/);
        # return (1) if ($ipv6 =~ /::/);

        my $match_ipv6 = qr/^(((?=(?>.*?::)(?!.*::)))(::)?([0-9A-F]{1,4}::?){0,5}|([0-9A-F]{1,4}:){6})(\2([0-9A-F]{1,4}(::?|$)){0,2}|((25[0-5]|(2[0-4]|1[0-9]|[1-9])?[0-9])(\.|$)){4}|[0-9A-F]{1,4}:[0-9A-F]{1,4})(?<![^:]:)(?<!\.)\z/i;

        if ($ipv6 =~ $match_ipv6)
        {
                return (1);
        }
        return (0);
}

# return IP type
sub type {
        my $ip = shift;

        if ( &valid_ipv4_host ($ip) )
        {
                return ('ipv4');
        }

        if ( &valid_ipv6_host ($ip) )
        {
                return ('ipv6');
        }

        return ("unknown");

}

# sample code from Net::IP IP.pm, https://searchcode.com/codesearch/view/18362974/
#------------------------------------------------------------------------------
# Subroutine ip_compress_address
# Purpose           : Compress an IPv6 address
# Params            : IP, IP version
# Returns           : Compressed IP or undef (problem)
sub ip_compress_address {
        my ($ip, $ip_version) = @_;

        unless ($ip_version) {
            #$ERROR = "Cannot determine IP version for $ip";
            #$ERRNO = 101;
            return;
        }

        # Just return if IP is IPv4
        return ($ip) if ($ip_version == 4);

        # Remove leading 0s: 0034 -> 34; 0000 -> 0
        $ip =~ s/
    	(^|:)        # Find beginning or ':' -> $1
    	0+           # 1 or several 0s
    	(?=          # Look-ahead
    	[a-fA-F\d]+  # One or several Hexs
    	(?::|$))     # ':' or end
    	/$1/gx;

        my $reg = '';

        # Find the longuest :0:0: sequence
        while (
            $ip =~ m/
    	((?:^|:)     # Find beginning or ':' -> $1
    	0(?::0)+     # 0 followed by 1 or several ':0'
    	(?::|$))     # ':' or end
    	/gx
          )
        {
            $reg = $1 if (length($reg) < length($1));
        }

        # Replace sequence by '::'
        $ip =~ s/$reg/::/ if ($reg ne '');

        return lc ($ip); # modified to return lowercase
}

# sample code from Net::IP IP.pm, https://searchcode.com/codesearch/view/18362974/
#------------------------------------------------------------------------------
# Subroutine ip_iplengths
# Purpose           : Get the length in bits of an IP from its version
# Params            : IP version
# Returns           : Number of bits

sub ip_iplengths {
        my ($version) = @_;

        if ($version == 4) {
                return (32);
        }
        elsif ($version == 6) {
                return (128);
        }
        else {
                return;
        }
}

# sample code from Net::IP IP.pm, https://searchcode.com/codesearch/view/18362974/
#------------------------------------------------------------------------------
# Subroutine ip_bintoip
# Purpose           : Transform a bit string into an IP address
# Params            : bit string, IP version
# Returns           : IP address on success, undef otherwise
sub ip_bintoip {
        my ($binip, $ip_version) = @_;

        # Define normal size for address
        my $len = ip_iplengths($ip_version);

        if ($len < length($binip)) {
                #$ERROR = "Invalid IP length for binary IP $binip\n";
                #$ERRNO = 189;
                return;
        }

        # Prepend 0s if address is less than normal size
        $binip = '0' x ($len - length($binip)) . $binip;

        # IPv4
        if ($ip_version == 4) {
                return join '.', unpack('C4C4C4C4', pack('B32', $binip));
        }

        # IPv6
        return join(':', unpack('H4H4H4H4H4H4H4H4', pack('B128', $binip)));
}

# sample code from Net::IP IP.pm, https://searchcode.com/codesearch/view/18362974/
#------------------------------------------------------------------------------
# Subroutine ip_iptobin
# Purpose           : Transform an IP address into a bit string
# Params            : IP address, IP version
# Returns           : bit string on success, undef otherwise
sub ip_iptobin {
        my ($ip, $ipversion) = @_;

        # v4 -> return 32-bit array
        if ($ipversion == 4) {
                return unpack('B32', pack('C4C4C4C4', split(/\./, $ip)));
        }

        # Strip ':'
        $ip =~ s/://g;

        # Check size
        unless (length($ip) == 32) {
                #$ERROR = "Bad IP address $ip";
                #$ERRNO = 102;
                return;
        }

        # v6 -> return 128-bit array
        return unpack('B128', pack('H32', $ip));
}

# sample code from Net::IP IP.pm, https://searchcode.com/codesearch/view/18362974/
#------------------------------------------------------------------------------
# Subroutine ip_expand_address
# Purpose           : Expand an address from compact notation
# Params            : IP address, IP version
# Returns           : expanded IP address or undef on failure
sub ip_expand_address {
        my ($ip, $ip_version) = @_;

        unless ($ip_version) {
                #$ERROR = "Cannot determine IP version for $ip";
                #$ERRNO = 101;
                return;
        }

        # v4 : add .0 for missing quads
        if ($ip_version == 4) {
                my @quads = split /\./, $ip;

                my @clean_quads = (0, 0, 0, 0);

                foreach my $q (reverse @quads) {
                        unshift(@clean_quads, $q + 1 - 1);
                }

                return (join '.', @clean_quads[ 0 .. 3 ]);
        }

        # Keep track of ::
        $ip =~ s/::/:!:/;

        # IP as an array
        my @ip = split /:/, $ip;

        # Number of octets
        my $num = scalar(@ip);

        foreach (0 .. (scalar(@ip) - 1)) {

            # Embedded IPv4
            if ($ip[$_] =~ /\./) {

                # Expand Ipv4 address
                # Convert into binary
                # Convert into hex
                # Keep the last two octets

                $ip[$_] =
                  substr(
                    ip_bintoip(ip_iptobin(ip_expand_address($ip[$_], 4), 4), 6),
                    -9);

                # Has an error occured here ?
                return unless (defined($ip[$_]));

                # $num++ because we now have one more octet:
                # IPv4 address becomes two octets
                $num++;
                next;
            }

            # Add missing trailing 0s
            $ip[$_] = ('0' x (4 - length($ip[$_]))) . $ip[$_];
        }

        # Now deal with '::' ('000!')
        foreach (0 .. (scalar(@ip) - 1)) {

            # Find the pattern
            next unless ($ip[$_] eq '000!');

            # @empty is the IP address 0
            my @empty = map { $_ = '0' x 4 } (0 .. 7);

            # Replace :: with $num '0000' octets
            $ip[$_] = join ':', @empty[ 0 .. 8 - $num ];
            last;
        }

        return (lc(join ':', @ip));
}


1;
