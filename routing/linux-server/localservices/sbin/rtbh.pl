#!/usr/bin/perl

#
# (c) SecurityGuy
#
# Changelog:
#     2015.07.27 - added initial ipv6 support
#

use strict;
use warnings;


use POSIX qw(strftime);                         # time options
use Term::ANSIColor;                            # colored output
use File::Copy qw(copy);                        # copy apply file to backup
use DBI;                                        # mysql driver

$| = 1;                                         # flush buffers

use constant
{
        USER       => "dosportal",
        DB         => "RTBH",
        PWD        => "PASSWORD_HERE",
        MYSQLHOST  => "X.Y.90.75",

        VERSION    => "0.2.22",
        RELDATE    => "2015.07.27",
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
#&delayme;

my %global = (
        MAX_ROUTES      => 99000,
);

# set to 0 if you don't want debug output
my ($debug) = 1;


##############################
#####  Connect to MySQL  #####
##############################
print color("yellow"),"[*] $0: DEBUG: connecting to database\n", color("reset") if ($debug);
my $dsn = sprintf("DBI:mysql:database=%s;host=%s;mysql_connect_timeout=30",DB,MYSQLHOST);
my $dbh;
if (!($dbh = DBI->connect($dsn, USER, PWD, \%attr)))
{
        die "[*] $0: Error: $dbh->errstr\n";
        exit;
}


##################################################
#####  email us if # of routes > MAX_ROUTES  #####
##################################################
print color("yellow"),"[*] $0: DEBUG: get total rows\n", color("reset") if ($debug);
my $total_rows = &mysql_count_rows($dbh,"blacklist");
if ( $total_rows > $global{'MAX_ROUTES'} )
{
        &send_warning($global{'MAX_ROUTES'});
        print color("red"),"[*] $0: ERROR: max routes reached!\n", color("reset");
        exit(1);
}
print color("yellow"),"[*] $0: INFO: TOTAL_ROWS: $total_rows\n\n", color("reset");

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


################################
#####  proccess DB entries  ####
################################

print color("yellow"),"[*] $0: mysql => DEBUG: get deltas from database\n", color("reset") if ($debug);

my %records_add = &mysql_getdeltas($dbh, "blacklist",       "SELECT inet6_ntop(sourceip) as ip FROM `blacklist` WHERE cidr IN ('32','128') AND ( inserttime > DATE_SUB(now(), INTERVAL 10 MINUTE) ) limit 99900");
my %records_del = &mysql_getdeltas($dbh, "history","SELECT DISTINCT inet6_ntop(sourceip) as ip FROM `history`   WHERE cidr IN ('32','128') AND ( inserttime > DATE_SUB(now(), INTERVAL 10 MINUTE) ) limit 99900");

print color("yellow"),"[*] $0: mysql => DEBUG: records_add hash has " . (scalar(keys %records_add ) ) . " items\n", color("reset") if ($debug);
print color("yellow"),"[*] $0: mysql => DEBUG: records_del hash has " . (scalar(keys %records_del ) ) . " items\n", color("reset") if ($debug);

print color("yellow"),"[*] $0: mysql => DEBUG: disconnect\n", color("reset") if ($debug);
$dbh->disconnect();
#######################
#####  End MySQL  #####
#######################


#############################
#####  INCREMENTAL ADD  #####
#############################
print color("yellow"),"[*] $0: info => ADD check whitelists\n", color("reset") if ($debug);
foreach my $ip (keys %records_add)
{
        my ($found) = 0;
        #my $no_hits   = $del{$delbadip}{hits};
        #my $cidr     = $hash{$ip};

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

        # we are not in the whitelist
        if ($found == '0')
        {
                #print color("yellow"),"[*] $0: info => DEBUG: building final array $ip\n", color("reset") if ($debug);
                # ipv4
                if ($ip =~ /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/ && (( $1<=255  && $2<=255 && $3<=255  && $4<=255 )) )
                {
                        #my $no_hits   = $add{$addbadip}{hits};
                        #my $addmask      = $add{$addbadip}{mask};
                        #print color("yellow"),"[*] $0: info => /sbin/ip route add blackhole $ip/$addmask table 10\n", color("reset");
                        print color("yellow"),"[*] $0: info => /sbin/ip ro a blackhole $ip/32 t 10\n", color("reset");
                        system "/sbin/ip ro a blackhole $ip/32 t 10\n";
                } else
                {
                        print color("yellow"),"[*] $0: info => /sbin/ip -6 route add blackhole $ip/128 dev eth0 table 10\n", color("reset");
                        system "/sbin/ip -6 route add blackhole $ip/128 dev eth0 table 10\n";
                }
        }

} # end $found



#############################
#####  INCREMENTAL DEL  #####
#############################
print color("yellow"),"[*] $0: info => DEL check whitelists\n", color("reset") if ($debug);
foreach my $ip (keys %records_del)
{
        my ($found) = 0;
        #my $no_hits   = $del{$delbadip}{hits};
        #my $cidr     = $hash{$ip};

        my $type = &type ($ip);
        next if ( $type =~ "unknown" );

        # disabling this section. If ip to be removed is whitelisted, it is better remove the entry than to leave it blocked (assuming that somehow it got to blackhole kernel table.

        ##################
        #####  IPv4  #####
        ##################
        #if ( &valid_ipv4_host ( $ip ) )
        #{


                #if (scalar( @tempwhitelist_ipv4 ) > 1)
                #{
                #        if ( grep { $_ eq $ip} @tempwhitelist_ipv4 )
                #        {
                #                print color("yellow"),"[*] $0: info => DEBUG: $ip found in tempwhitelisted_ipv4 array\n", color("reset") if ($debug);
                #                $found = '1';
                #        }
                #}

                # if we found a match in @tempwhitelist_ipv4 skip IP
                #next if ( $found == 1 );

                # disabling this section. If ip to be removed is whitelisted, it is better remove the entry than to leave it blocked (assuming that somehow it got to blackhole kernel table.
                #foreach my $subnet ( @whitelist_ipv4 )
                #{
                #        if(&in_subnet_ipv4($ip, $subnet ))
                #        {
                #                print color("yellow"),"[*] $0: info => DEBUG: $ip found in whitelisted_ipv4 array\n", color("reset") if ($debug);
                #                $found = '1';
                #                last;
                #        }
                #}
        #}

        # if we found a match in @whitelist_ipv4 skip IP
        #next if ( $found == 1 );

        ##################
        #####  IPv6  #####
        ##################
        #if ( &valid_ipv6_host ( $ip ) )
        #{
        #
        #        my ($found) = '0';
        #
        #        if (scalar( @tempwhitelist_ipv6 ) > 1)
        #        {
        #                if ( grep { $_ eq $ip} @tempwhitelist_ipv6 )
        #                {
        #                        print color("yellow"),"[*] $0: info => DEBUG: $ip found in tempwhitelisted_ipv6 array\n", color("reset") if ($debug);
        #                        $found = '1';
        #                }
        #        }
        #        # if we found a match in @tempwhitelist_ipv6 skip IP
        #        next if ( $found == 1 );
        #
        #        foreach my $subnet ( @whitelist_ipv6 )
        #        {
        #                if ( &in_subnet_ipv6 ($subnet, "$ip/128") )
        #                {
        #                        print color("yellow"),"[*] $0: info => DEBUG: $ip found in whitelisted_ipv6 array\n", color("reset") if ($debug);
        #                        $found = '1';
        #                        last;
        #                }
        #        }
        #
        #        # if we found a match in @whitelist_ipv6 skip IP
        #        next if ( $found == 1 );
        #}
        #next if ( $found == 1 );

        # we are not in the whitelist
        #if ($found == '0')
        #{
        #        #print color("yellow"),"[*] $0: info => DEBUG: building final array $ip\n", color("reset") if ($debug);
        #        # ipv4
                if ( &valid_ipv4_host ( $ip ) )
                {
                        #my $no_hits   = $add{$addbadip}{hits};
                        #my $addmask      = $add{$addbadip}{mask};
                        #print color("yellow"),"[*] $0: info => /sbin/ip route add blackhole $ip/$addmask table 10\n", color("reset");
                        print color("yellow"),"[*] $0: info => /sbin/ip ro d blackhole $ip/32 t 10\n", color("reset");
                        system "/sbin/ip ro d blackhole $ip/32 t 10\n";
                }

                if ( &valid_ipv6_host ( $ip ) )
                {
                        print color("yellow"),"[*] $0: info => /sbin/ip -6 ro d blackhole $ip/128 dev eth0 t 10\n", color("reset");
                        system "/sbin/ip -6 ro d blackhole $ip/128 dev eth0 t 10\n";
                }
        #}

} # end $found


exit(0);
#################
#####  END  #####
#################
