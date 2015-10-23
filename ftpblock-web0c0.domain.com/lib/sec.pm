# http://stackoverflow.com/questions/2014862/how-can-i-access-ini-files-from-perl
# my $inifile    = iniRead($configfile);
# die "[$0]: ERROR: Unknown [ tree || base ] in $configfile" if ( (!defined($inifile->{$tree})) || (!defined($inifile->{$tree}->{'base'}))  );
# $group{'basedn'} = "o=" . $inifile->{$tree}->{'base'};
sub iniRead
{
        my $ini = $_[0];
        my $conf;
        my $section;
        open (INI, "$ini") || die "[*] $0: ERR: Can't open $ini: $!\n";
        while (<INI>) {
                chomp;
                if (/^\s*\[\s*(.+?)\s*\]\s*$/) {
                        $section = $1;
                }

                if ( /^\s*([^=]+?)\s*=\s*(.*?)\s*$/ ) {
                        $conf->{$section}->{$1} = $2;

                        if (not defined $section) {
                                warn "Line outside of section '$_'\n";
                                next;
                        }

                }
        }
        close (INI);
        return $conf;
}

# http://stackoverflow.com/questions/2014862/how-can-i-access-ini-files-from-perl
# $conf = iniRead("/etc/samba/smb.conf");
# $conf->{"global"}->{"workgroup"} = "WORKGROUP";
# $conf->{"www"}->{"path"}="/var/www/html";
# iniWrite("/etc/samba/smb.conf",$conf);
sub iniWrite
{
        my $ini = $_[0];
        my $conf = $_[1];
        my $contents = '';
        foreach my $section ( sort { (($b eq '_') <=> ($a eq '_')) || ($a cmp $b) } keys %$conf ) {
                my $block = $conf->{$section};
                $contents .= "\n" if length $contents;
                $contents .= "[$section]\n" unless $section eq '_';
                foreach my $property ( sort keys %$block ) {
                        $contents .= "$property=$block->{$property}\n";
                }
        }
        open( CONF,"> $ini" ) or print("not open the file");
        print CONF $contents;
        close CONF;
}


sub log_bad_ip ()
{
        use IO::Socket;
        use Sys::Hostname;         # hostname function

        my %graylog = (
                server_ip         => '206.225.90.71',
                server_port       => '12206',
                hservice          => 'FTP',
                block_with        => 'RTBH'
        );
        $loghost = hostname;

        # $string_for_logging is for hService logging
        my ($sourceip,$string_for_logging,$myhits,$secexpire,$repeated_offender,$country,$type) = @_;

        my $etime = strftime "%F %T", (localtime(time() + $secexpire));
        my $now   = strftime "%F %T", (localtime(time()) );

        my ($cidrdb) = 32;

        return (0) if ( $type eq "unknown" );
        # if $type does not match ipv then do not send anything to graylog
        return (0) if ( $type !~ /ipv/ );

        if ( $type eq "ipv4" )
        {
                $cidrdb  = 32;
        }

        if ( $type eq "ipv6" )
        {
                $cidrdb = 128;
        }

        my $client = new IO::Socket::INET(
                         PeerAddr => $graylog{"server_ip"},
                         PeerPort => $graylog{"server_port"},
                         Timeout => 5,
                         Proto => 'udp',
        );

        #$client->send ("{ \"version\": \"1.1\", \"host\": \"$graylog{'loghost'}\", \"short_message\": \"Blocked IP Log \", \"hservice\": \"$graylog{'hservice'}\", \"URI\": \"$string_for_logging\", \"Severity\": \"Error\", \"AttackType\": \"Abuse of Functionality\", \"Violations\": \"Brute Force\", \"SourceIP\": \"$sourceip\", \"Cidr\": \"$cidrdb\", \"InsertTime\": \"$now\", \"ExpireTime\": \"$etime\", \"Blocked_With\": \"$graylog{'block_with'}\", \"Hits\": \"$myhits\", \"RepeatedOffender\": \"$repeated_offender\", \"Country\": \"$country\" }"); # or die "Send: $!\n";
        $client->send ("{ \"version\": \"1.1\", \"host\": \"$loghost\", \"short_message\": \"Blocked IP Log \", \"hService\": \"$string_for_logging\", \"URI\": \"NA\", \"Severity\": \"Error\", \"AttackType\": \"Abuse of Functionality\", \"Violations\": \"Brute Force\", \"SourceIP\": \"$sourceip\", \"Cidr\": \"$cidrdb\", \"InsertTime\": \"$now\", \"ExpireTime\": \"$etime\", \"Blocked_With\": \"$graylog{'block_with'}\", \"Hits\": \"$myhits\", \"RepeatedOffender\": \"$repeated_offender\", \"Country\": \"$country\" }"); # or die "Send: $!\n";


        # terminate the connection when we're done
        close($client);
        return (0);
}

# calculate closest number # http://www.perlmonks.org/?node_id=884064
sub nearest{
        my ( $dist, $href ) = @_;
        my ( $answer ) = ( sort { abs( $a - $dist ) <=> abs( $b - $dist ) } keys %$href );
        return $href -> { $answer };
}

# sleep a bit so multiple servers don't run same cronjob all at once hammering DB server
sub delayme {
        my $minimum = 5;
        my $range = 20;
        my $sleeptime = int(rand($range)) + $minimum;
        print color("yellow"), "[*] $0: delayme => sleeping rand time: $sleeptime seconds\n", color("reset");
        sleep($sleeptime);
        return(0);
}

sub return_country {
        #use Geo::IP;                 # GeoIP
        my ($myip) = shift;

        # not all servers have Geo::IP module loaded, return unknown for now
        #my $gi = Geo::IP->open('/usr/share/GeoIP/GeoLiteCity.dat', GEOIP_STANDARD);
        #my $gi = Geo::IP->open('/usr/share/GeoIP/GeoLiteCity.dat', GEOIP_MEMORY_CACHE);

        #my $r = $gi->record_by_name($myip);
        my $country = '';

        #if ($r) {
        #    $country = $r->country_code;
        #} else {
            $country = "UNK";
        #}

        return ($country);

}

# delete files matching pattern non-recursively
sub find_recent_log_files() {
        my ($maxdays,$folder,$match) = @_;

        # temp array to hold file names
        my (@temp) = ();

        if (! -d $folder) {
                die ("[$0]: folder $folder does not exist: $!");
        }

        opendir (DIR, $folder);
        my @dir = grep { /^$match/ } readdir(DIR);
        closedir(DIR);

        # sort by modification time
        @dir = sort { -M "$folder/$a" <=> -M "$folder/$b" } (@dir);

        # do we have at least one item in array ?
        if (scalar(@dir) >0 ) {
                foreach my $file (@dir) {
                        my $full_path = "$folder/$file";
                        # we only care about regular files ignoring folders
                        next if (!(-f "$full_path"));

                        # ignore files ending in tmp
                        next if ($file =~ /tmp$/ );

                        # return time diff
                        my $age = int(-M "$full_path");

                        #my $age = int( -M "$full_path" ) < int( -C "$full_path") ? int( -M "$full_path") : int( -C "$full_path");
                        if ( $age <= $maxdays ) {
                                # add to temp array
                                push (@temp,$full_path);
                        }
                }
        }
        return (@temp);
}

# delete files matching pattern non-recursively
sub delete_files_older_than() {
        my ($maxdays,$folder,$match) = @_;

        if (! -d $folder) {
                #die ("[$0]: folder $folder does not exist: $!");
                print color("yellow"),"[*] $0: ERROR: folder $folder does not exist: $! \n", color("reset");
                exit(1);
        }

        opendir (DIR, $folder);
        my @dir = grep { /$match/ } readdir(DIR);
        closedir(DIR);

        # sort by modification time not really needed
        #@dir = sort { -M "$dir/$a" <=> -M "$dir/$b" } (@dir);

        # do we have at least one item in array ?
        if (scalar(@dir) >0 ) {
                foreach my $file (@dir) {
                        my $full_path = "$folder/$file";
                        # we only care about files ignoring folders
                        next if (!(-f "$full_path"));

                        # return time diff
                        my $diff = -M "$full_path";

                        if ( $diff >= $maxdays ) {
                                # print file to be deleted
                                #print "[*] $0: INFO: CLEANUP: rm -f " . $full_path . "\n";
                                print color("yellow"),"[*] $0: INFO: bash => rm -f " . $full_path . "\n", color("reset");
                                unlink ("$full_path");
                        }
                }
        }
}

# delete files matching pattern RECURSIVELY
sub delete_files_older_than_recursive() {
        my ($max_days,$folder,$match) = @_;
        my @file_list;
        use File::Find;

        find ( sub {
                 my $file = $File::Find::name;
                 if ( -f $file ) {
                           push (@file_list, $file);
                 }
        }, $folder);

        @file_list = grep {-f && /$match/} @file_list;

        # do we have at least one item in array ?
        if (scalar(@file_list) > 0 ) {
                my @remove_files = grep { -M $_ > $max_days } @file_list;
                for my $file (@remove_files) {
                        print "[$0]: Deleting " . $file . "\n";
                        unlink $file;
                }
        }
}


# append entry to the file
sub AppendEntry
{
        my $file  = shift;
        my $entry = shift;

        my $fh;
        open($fh, '>>', "$file") or die "[*] $0: ERR: cannot write to: $file: $!";
        print $fh "$entry\n";
        close($fh);
}

# recursively create a folder
sub rmkdir{
        my($tpath) = @_;
        my($accum) = '';

        foreach my $mydir (split(/\//, $tpath)){
                $accum = "$accum" . "$mydir/";
                if($mydir ne ""){
                        if(! -d "$accum"){
                                #print "[*] $0: INFO: mkdir $accum\n";
                                print color("yellow"),"[*] $0: INFO: mkdir $accum\n", color("reset");
                                mkdir $accum;
                                chmod(0700, $accum)
                        }
                }
        }
}

# create empty file
sub NukeFile {
        my $dodo = shift;
        open (LR, ">$dodo") && close(LR);
        chmod(0600, $dodo) if ( -f $dodo );
}

sub writeFiles
{
        my ($in,%temp) = @_;
        if (%temp)
        {

                 &NukeFile($in);

                 #generate file to be applied
                 foreach my $badip (keys %temp)
                 {
                         #my $no_hits   = $temp{$badip}{hits};
                         my $mask      = $temp{$badip}{mask};

                         # ipv4
                         if ($badip =~ /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/ && (( $1<=255  && $2<=255 && $3<=255  && $4<=255 )) )
                         {
                                 #&AppendEntry ($in,  "/sbin/ip route add blackhole $badip/$mask table 10" );
                                 &AppendEntry ($in,  "/sbin/ip ro a blackhole $badip/32 t 10" );              # force /32 for ipv4
                         } else
                         # ipv6
                         {
                                 #&AppendEntry ($in,  "/sbin/ip -6 route add blackhole $badip/$mask dev eth0 table 10" );
                                 &AppendEntry ($in,  "/sbin/ip -6 ro a blackhole $badip/128 dev eth0 t 10" ); # force /128 for ipv6
                         }
                 } # end foreach
        } # end if
} # end sub

sub logit
{

        my ($LogFile,$Msg) = @_;

        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

        # Keep the log file under 50 MB. If over then empty it.
        if ( ( -s $LogFile) > 52428800) {
                &NukeFile ($LogFile);
        }

        $year += 1900;
        $mon  = sprintf("%02d", $mon+1);
        $mday = sprintf("%02d", $mday);
        $hour = sprintf("%02d", $hour);
        $min  = sprintf("%02d", $min);
        $sec  = sprintf("%02d", $sec);

        my ($datestamp) = $year ."-" . $mon ."-" . $mday ." " . $hour . ":" . $min .":" . $sec;
        open(FILEH, ">>$LogFile") ||return();
        print FILEH "$datestamp | $Msg\n";
        close(FILEH);

        return 1;
}

sub send_warning () {

        # limit is max number of routes
        my ( $limit ) = shift;

        #Create SMTP connection
        my $smtp=Net::SMTP->new("mail.domain.com",
                                Hello=>"mail.domain.com",
                                Timeout  => 30,
                                Debug => 0
        ) or die "[*] $0: ERR: $! \n";

        $smtp->mail("rtbh\@domain.com");
        $smtp->to("routing\@domain.com");
        $smtp->data();
        $smtp->datasend("To: routing\@domain.com\n");
        $smtp->datasend("Cc: security\@domain.com\n");
        $smtp->datasend("From: rtbh\@domain.com\n");
        $smtp->datasend("Subject: please increase RTBH limit\n");
        $smtp->datasend("\n");
        my $line = sprintf ("Limit of %s routes has been reached\n",$limit);
        $smtp->datasend($line);
        $smtp->datasend();
        $smtp->quit;

}

###########################################
#####  other regular functions I use  #####
###########################################
sub salt8 {
        my $salt = join '', ('a'..'z')[rand 26,rand 26,rand 26,rand 26,rand 26,rand 26,rand 26,rand 26];
        return($salt);
}

sub gettime {
        my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
        $year = 1900 + $year;
        my $monn = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")[$mon];
        my $wdayn = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")[$wday];
        my $filename = $year . "_" . $monn . "_" . sprintf("%02d",$mday) . "_" . $wdayn . "_" . $hour . "_" . $min . "_" . $sec;
        return $filename;
}

sub ltrim {
        my $s = shift;
        $s =~ s/^\s+//;
        return $s;
};

sub rtrim {
        my $s = shift;
        $s =~ s/\s+$//;
        return $s;
};
sub trim  {
        my $s = shift;
        $s =~ s/^\s+|\s+$//g;
        return $s;
};

# http://code.activestate.com/recipes/577450-perl-url-encode-and-decode/
sub urlencode {
    my $s = shift;
    $s =~ s/ /+/g;
    $s =~ s/([^A-Za-z0-9\+-])/sprintf("%%%02X", ord($1))/seg;
    return $s;
}

# http://code.activestate.com/recipes/577450-perl-url-encode-and-decode/
sub urldecode {
    my $s = shift;
    $s =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
    $s =~ s/\+/ /g;
    return $s;
}

sub mygrep ($$$)
{
        my ( $grep_string, $from_file, $save_to_file ) = @_;
        # skip if file does not exist
        next if ( ! -f $from_file );
        print "[*] $0: INFO: egrep -E \"($grep_string)\" $from_file >> $save_to_file\n";
        my %buffer = ();
        my $counter = 0;
        # read file into memmory
        if (open(READ,$from_file)){
                while(my $line=<READ>)
                {
                        chomp($line);

                        if ( $line =~ m/$grep_string/ )
                        {
                                # inject into memmory
                                $buffer{$counter} = $line ;
                                $counter++;
                        }
                }
        }
        close(READ);
        chmod(0600, $from_file);

        # write contents from memory to FILE while sorting hash numerically
        if (open(WRITE,">> $save_to_file")){
                foreach my $liner (sort { $a <=> $b } keys(%buffer) )
                {
                       print WRITE "$buffer{$liner}\n"
                }
        }
        close(WRITE);
        chmod(0600, $save_to_file);
        return (0);
}

sub DateToSeconds {
        use POSIX qw(mktime);      # time options
        my ($day, $month, $year) = @_;
        return mktime 0, 0, 0, $day, $month, $year;
}
sub LastDayOfMonth {
        my($year, $month) = @_;
        my $date = (31,28,31,30,31,30,31,31,30,31,30,31)[$month-1];
        if ( $month == 2 && (($year % 4 == 0) && ($year % 100 != 0) && ($year % 400 == 0) ) ) {
                $date++;
        }
        return $date;
}

# get subfolders non-recursive: # http://www.perlmonks.org/?node_id=106956
sub subdirs {
    my $dir = shift;
    my $DIR;
    my (@alldirs) = ();
    # I use variable file handles so function can be reentrant
    opendir $DIR, $dir or die "opendir $dir - $!";
    my @entries = readdir $DIR;

    # Get only directories from dir listing.
    my @subdirs = grep { -d "$dir/$_" } @entries;

    # Remove "hidden" directories (including . and ..) from that list.
    @subdirs = grep { !/^\./ } @subdirs;

    for my $subdir ( @subdirs ) {
            push(@alldirs, "$dir/$subdir");
            print "[*] $0: INFO: subfolder $dir/$subdir\n";
    }
    closedir $DIR;
    return (@alldirs);
}


1;
