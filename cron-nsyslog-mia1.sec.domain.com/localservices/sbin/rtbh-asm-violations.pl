#!/usr/bin/perl

#
# (c) SecurityGuy
#
# Changelog:
#     2015.07.27 - added initial ipv6 support
#

use strict;
use warnings FATAL => 'all';


use POSIX qw(strftime);                         # time options
use Term::ANSIColor;                            # colored output
use File::Copy qw(copy);                        # copy apply file to backup
use DBI;                                        # mysql driver
use LWP::Simple;                                # query remote server and store results into strings
use Sys::Hostname;                              # get the current server name


$| = 1;                                         # flush buffers

use constant
{
        USER       => "dosportal",
        DB         => "RTBH",
        PWD        => "PASSWORD_HERE",
        MYSQLHOST  => "X.Y.90.75",

        VERSION    => "0.1.1",
        RELDATE    => "2015.07.30",
        BY         => "Security Guy"
};

use vars qw(%attr %graylog);                    # make %attr hash definition and params work properly when loaded from external .pm files

use lib '/localservices/sbin/lib/';             # set path to custom files
require 'lock.pm';                              # lock process so one instance runs at a time
require 'sec.pm';                               # regular functions
require 'ipv4.pm';                              # ipv4 functions, order matters, do not change
require 'ipv6.pm';                              # ipv6 functions, order matters, do not change
require 'mysql.pm';                             # mysql functions


# don't hammer mysql database from multiple servers, add random sleep time
&delayme;

my %global = (
        MAX_ENTRIES      => 20000,
        GET_URL          => "https://rtbh.sec.domain.com/rtbh-asm-violations.php?hits=5001&time=3600",
        min_thresh       => 5001,
);

# set to 0 if you don't want debug output
my ($debug)   = 0;

my $db_string = "asm-violations";      # to differenciate between different types of blocks; used by hService and mysql (comments & insertby)
my $i;                                 # url read line by line, see below
my %records   = ();                    # hash with all ips to be blocked

my @violations = (
        'Mandatory HTTP header is missing',
        'Illegal URL',
        'Attack signature detected',
        'Brute Force',
        'Brute Force: Maximum login attempts are exceeded',
        'HTTP protocol compliance failed'
);


foreach my $violation (@violations)
{
        ##########################################
        #####  read list from remote server  #####
        ##########################################
        print color("yellow"),"[*] $0: get => DEBUG: getting list of IPv4 entries from $global{'GET_URL'}\n", color("reset") if ($debug);
        my $remote = sprintf ("%s?time=5001&hits=%s&SEARCH='%s'",$global{'GET_URL'},$global{'min_thresh'},$violation);
        #print "$remote\n";
        my $list = get($remote);
        if( ! defined( $list ) ) {
                die( "[*] $0: ERROR: Can not fetch addresses from $global{'GET_URL'}\n" );
        }

        foreach my $line (split( /\n/, $list )) {
                $line = &trim($line);
                next if ( ( $line =~ /^$/ ) || ($line =~ /^\s+$/) || ( $line =~ /^#/ ) );  # skip blank lines & lines beggining with comments
                next unless length($line);                                                 # skip if if don't have at least a character

                my ($hits,$my_ip) = split(/\s+/,$line);
                next if ( (! defined ($hits) ) || (! defined ($my_ip) ) );                 # make sure we have 2 elements, hits & ip

                if ( ( &valid_ipv4_host ( $my_ip ) ) && ($hits > $global{'min_thresh'}) )
                {

                        $records{$my_ip} = $hits;                                          # build hash of IPs,  ipv4
                        #print "$my_ip $hits\n";
                }

                if ( ( &valid_ipv6_host ( $my_ip ) ) && ($hits > $global{'min_thresh'}) )
                {

                        $records{$my_ip} = $hits;                                          # build hash of IPs,  ipv6
                        #print "$my_ip $hits\n";
                }
        }

}
print color("yellow"),"[*] $0: lwp::simple => DEBUG: records hash has " . scalar (keys %records) . " items\n", color("reset") if ($debug);
if ( scalar ( keys %records) < 1)
{
        print "[*] $0: ERROR: no entries found in hash records\n";
        exit(1);
}

if ( scalar ( keys %records) > $global{'MAX_ENTRIES'})
{
        print "[*] $0: ERROR: MAX_ENTIES reached $global{'MAX_ENTRIES'}, cannot continue, list too big\n";
        exit(1);
}


##############################
#####  Connect to MySQL  #####
##############################
print color("yellow"),"[*] $0: mysql => DEBUG: connecting to database\n", color("reset") if ($debug);
my $dsn = sprintf("DBI:mysql:database=%s;host=%s;mysql_connect_timeout=30",DB,MYSQLHOST);
my $dbh;
if (!($dbh = DBI->connect($dsn, USER, PWD, \%attr)))
{
        die "[*] $0: Error: $dbh->errstr\n";
        exit;
}


###############################################################################################
#####  get a list of whitelisted networks and store them in an array. Must not be empty!  #####
###############################################################################################
my @whitelist_ipv4 = &whitelist($dbh,'whitelist','ipv4');
my @whitelist_ipv6 = &whitelist($dbh,'whitelist','ipv6');

# @tempwhitelist* could be empty
my @tempwhitelist_ipv4 = &tempwhitelist($dbh,'temp_whitelist','ipv4');
my @tempwhitelist_ipv6 = &tempwhitelist($dbh,'temp_whitelist','ipv6');

print "\n";

print color("yellow"),"[*] $0: mysql DEBUG: whitelist_ipv4 has " . scalar (@whitelist_ipv4) . " items\n", color("reset") if ($debug);
print color("yellow"),"[*] $0: mysql DEBUG: whitelist_ipv6 has " . scalar (@whitelist_ipv6) . " items\n", color("reset") if ($debug);

print color("yellow"),"[*] $0: mysql DEBUG: tempwhitelist_ipv4 has " . scalar (@tempwhitelist_ipv4) . " items\n", color("reset") if ($debug);
print color("yellow"),"[*] $0: mysql DEBUG: tempwhitelist_ipv6 has " . scalar (@tempwhitelist_ipv6) . " items\n", color("reset") if ($debug);

if ( (scalar( @whitelist_ipv4 ) == 0 ) || (scalar( @whitelist_ipv6 ) == 0 ) )
{
        print "[*] $0: ERROR: whitelist for ipv4/ipv6 is empty\n";
        exit (1);
}

print "\n";

my %dist               = &auth_thresholds($dbh,"graylog_settings_connections");       # get a list of settings stored in mysql
my %history_thresholds = &get_history_thresholds ($dbh,"history_thresholdhits");      # get a list of settings stored in mysql
print color("yellow"),"[*] $0: mysql => DEBUG: dist hash has " . scalar (keys %dist) . " items\n", color("reset") if ($debug);
print color("yellow"),"[*] $0: mysql => DEBUG: history_thresholds hash has " . scalar (keys %history_thresholds) . " items\n", color("reset") if ($debug);
if ( scalar ( keys %dist) < 1)
{
        print "[*] $0: ERROR: records hash has 0 records ?!?\n";
        exit(1);
}
if ( scalar ( keys %history_thresholds) < 1)
{
        print "[*] $0: ERROR: history_thresholds hash has 0 records ?!?\n";
        exit(1);
}


##############################
#####  check whitelists  #####
##############################

foreach my $ip (keys %records)
{
        my ($found) = 0;

        my $type = &type ($ip);
        next if ( $type =~ "unknown" );


        ##################
        #####  IPv4  #####
        ##################
        if ( &valid_ipv4_host ( $ip ) )
        {


                if (scalar( @tempwhitelist_ipv4 ) > 1)
                {
                        if ( grep { $_ eq $ip} @tempwhitelist_ipv4 )
                        {
                                print color("yellow"),"[*] $0: info => DEBUG: $ip found in tempwhitelisted_ipv4 array\n", color("reset") if ($debug);
                                $found = '1';
                        }
                }

                # if we found a match in @tempwhitelist_ipv4 skip IP
                next if ( $found == 1 );

                foreach my $subnet ( @whitelist_ipv4 )
                {
                        if(&in_subnet_ipv4($ip, $subnet ))
                        {
                                print color("yellow"),"[*] $0: info => DEBUG: $ip found in whitelisted_ipv4 array\n", color("reset") if ($debug);
                                $found = '1';
                                last;
                        }
                }
        }

        # if we found a match in @whitelist_ipv4 skip IP
        next if ( $found == 1 );

        ##################
        #####  IPv6  #####
        ##################
        if ( &valid_ipv6_host ( $ip ) )
        {

                # apply ipv6 short notation
                $ip = &ip_compress_address ("$ip",6);

                my ($found) = '0';

                if (scalar( @tempwhitelist_ipv6 ) > 1)
                {
                        if ( grep { $_ eq $ip} @tempwhitelist_ipv6 )
                        {
                                print color("yellow"),"[*] $0: info => DEBUG: $ip found in tempwhitelisted_ipv6 array\n", color("reset") if ($debug);
                                $found = '1';
                        }
                }
                # if we found a match in @tempwhitelist_ipv6 skip IP
                next if ( $found == 1 );

                foreach my $subnet ( @whitelist_ipv6 )
                {
                        if ( &in_subnet_ipv6 ($subnet, "$ip/128") )
                        {
                                print color("yellow"),"[*] $0: info => DEBUG: $ip found in whitelisted_ipv6 array\n", color("reset") if ($debug);
                                $found = '1';
                                last;
                        }
                }

                # if we found a match in @whitelist_ipv6 skip IP
                next if ( $found == 1 );
        }
        next if ( $found == 1 );

        ##########################
        #####  BLOCKING section  #
        ##########################
        if ($found == '0')
        {
                print color("yellow"),"[*] $0: info => DEBUG: blocking $ip\n", color("reset") if ($debug);

                # set to a random number, this get overwritten below
                my $block_seconds = '7200';

                # get the number of hits
                my $no_hits = $records{$ip};

                my $geoip_country = &return_country ($ip);

                my $n = 0;
                $n = &get_history_count($dbh, "blacklist", $ip);

                if ($n > 0 ) {
                            # is IP repeated offender ?
                            $block_seconds = nearest( $no_hits, \%history_thresholds );
                } else {
                            # is IP temp offender ?
                            $block_seconds = nearest( $no_hits, \%dist );
                }

                printf("%-15s %-20s %-10s %9s %5s\n", $ip, $no_hits, $n, $geoip_country, $type);

                # set hostname into database so wen identify which environment was bruteforced
                my $insertby = $db_string . "-" . hostname;
                $insertby    = substr( $insertby, 0, 170 );  # DB entry max 200 chars, truncate to 170

                # insert the IP into the DB
                &mysql_insert($dbh,'blacklist',$type,$ip,$no_hits,$block_seconds,$n,$geoip_country,$insertby,"graylog-".$db_string);

                # next we log the block into separate graylog server for reporting
                &log_bad_ip ($ip,$db_string,$no_hits,$block_seconds,$n,$geoip_country,$type);


        }

} # end $found


#######################
#####  End MySQL  #####
#######################
print color("yellow"),"[*] $0: mysql => DEBUG: disconnect\n", color("reset") if ($debug);
$dbh->disconnect();

exit(0);
#################
#####  END  #####
#################
