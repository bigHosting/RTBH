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


1;
