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
        ROUTES_APPLY    => "top-ips-apply",
        RTBH_DIR        => "/localservices/rtbh",
        RTBH_APPLIED    => "/localservices/rtbh/rtbh_applied",
        MAX_ROUTES      => 99000,
);

# set to 0 if you don't want debug output
my ($debug) = 0;


#######################################
#####  create folders if missing  #####
#######################################
if (! -d $global{'RTBH_DIR'} )
{
        print color("yellow"),"[*] $0: mysql DEBUG: mkdir -p $global{'RTBH_DIR'}\n", color("reset") if ($debug);
        rmkdir($global{'RTBH_DIR'} ) ;
}
if (! -d $global{'RTBH_APPLIED'} )
{
        print color("yellow"),"[*] $0: mysql DEBUG: mkdir -p $global{'RTBH_APPLIED'}\n", color("reset") if ($debug);
        rmkdir($global{'RTBH_APPLIED'} ) ;
}

#########################################################################################
#####  clean up after ourselves. Keep 3 days works of backups and remove everything else
#########################################################################################
print color("yellow"),"[*] $0: DEBUG: deleting older files from $global{'RTBH_APPLIED'}\n", color("reset") if ($debug);
&delete_files_older_than(2,"$global{'RTBH_APPLIED'}","top-ips-apply");
print "\n";



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



# date for ip output file
my $DATE   = strftime "%Y-%m-%d_%H.%M.%S", (localtime(time()) );
# current routes files
my $apply       = $global{"RTBH_DIR"} . "/" . $global{"ROUTES_APPLY"};
# keep history file
my $backup_apply  = $global{"RTBH_APPLIED"} . "/" . $global{"ROUTES_APPLY"}  . "-" . $DATE;



################################
#####  proccess DB entries  ####
################################

print color("yellow"),"[*] $0: mysql => DEBUG: get all records from database\n", color("reset") if ($debug);
my %records = &mysql_getrecords($dbh, "blacklist");
print color("yellow"),"[*] $0: mysql => DEBUG: records hash has " .  scalar (keys (%records)) . " items\n", color("reset") if ($debug);
if (scalar ( keys (%records)) < 1 )
{
        print "[*] $0: ERROR: no records found in the database\n";
        exit (1);
}

print color("yellow"),"[*] $0: mysql => DEBUG: disconnect\n", color("reset") if ($debug);
$dbh->disconnect();
#######################
#####  End MySQL  #####
#######################

##############################
#####  check whitelists  #####
##############################
my (%final) = ();
foreach my $ip (keys %records)
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
                $final{$ip} = 1;
                #print "=== $ip ===\n";
        }

} # end $found



print color("yellow"),"[*] $0: info => DEBUG: > $apply\n", color("reset") if ($debug);
&NukeFile ($apply);

print color("yellow"),"[*] $0: info => DEBUG: writeFiles final array to $apply\n", color("reset") if ($debug);
&writeFiles ( $apply , %final);

if ( -f $apply) {
       print color("yellow"),"[*] $0: info => DEBUG: cp $apply $backup_apply\n", color("reset") if ($debug);
       copy ($apply, $backup_apply) or die "[*] $0: ERROR: cp $apply $backup_apply";

       ########################
       #####  ipv4 FLUSH  #####
       ########################
       print color("yellow"),"[*] $0: INFO: ipv4 FLUSH\n", color("reset");
       print color("yellow"),"[*] $0: info => DEBUG: /sbin/ip route flush table 10\n", color("reset") if ($debug);
       system("/sbin/ip ro flush table 10");

       ########################
       #####  ipv6 FLUSH  #####
       ########################
       print color("yellow"),"[*] $0: INFO: ipv6 FLUSH\n", color("reset");
       print color("yellow"),"[*] $0: info => DEBUG: /sbin/ip -6 route flush table 10\n", color("reset") if ($debug);
       system("/sbin/ip -6 ro flush table 10");

       ###################
       #####  APPLY  #####
       ###################
       print color("yellow"),"[*] $0: INFO: APPLY: $apply\n", color("reset");
       print color("yellow"),"[*] $0: info => DEBUG: /bin/bash $apply\n", color("reset") if ($debug);
       system("/bin/bash $apply");
##       &logit(LOG,"[*] $0: INFO: -> $apply");
}

exit(0);
#################
#####  END  #####
#################
