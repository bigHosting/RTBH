#!/usr/bin/perl

#
# (c) SecurityGuy
#


use strict;
use warnings;

use vars qw(%attr %graylog);                    # make %attr hash definition and params work properly when loaded from external .pm files

use POSIX qw(strftime);                         # time options
use Term::ANSIColor;                            # colored output
use DBI;                                        # mysql driver
use Sys::Hostname;                              # get the current server name

$| = 1;                                         # flush buffers

use constant
{
        USER       => "dosportal",
        DB         => "RTBH",
        PWD        => "PASSWORD_HERE",
        MYSQLHOST  => "X.Y.90.75",

        VERSION    => "0.2.23",
        RELDATE    => "2015.07.28",
        BY         => "Security Guy"
};

use lib '/services/analyzeftp/lib/';            # set path to custom files
require 'lock.pm';                              # lock process so one instance runs at a time
require 'sec.pm';                               # regular functions
require 'ipv4.pm';                              # ipv4 functions, order matters, do not change
require 'ipv6.pm';                              # ipv6 functions, order matters, do not change
require 'mysql.pm';                             # mysql functions


# thresholds for last 2 hours
my %thresholds = (
        failed_per_ip               =>  '150',
        success_max_domains_per_ip  =>  '14'
);


# don't hammer mysql database from multiple servers, add random sleep time
&delayme;


# path to ProFTPD log files
#my @files = </.../proftpd.auth/web*>;
my @files = find_recent_log_files ("0","/PATH_TO_LOGS/proftpd.auth","web|ftp");
if (scalar ( @files ) < 1 )
{
        print "[*] $0: ERROR: no log files found!\n";
        exit(1);
}
print "\n";

# time stuff
my @t1 = localtime(time);              # current time
my @t2 = localtime(time - (3600 * 1)); # go back in time 1 hour
my $time_now  = strftime "%j:%H",@t1;  # dayOfYear:hour
my $time_back = strftime "%j:%H",@t2;  # yesterday_dayOfYear:hour

my $time_hr   = strftime "%H",@t1;     # current hour of the day
my $time_hr2  = strftime "%H",@t2;     # previous hour
my $time_day  = strftime "%j",@t1;     # day of the year

my $db_string = "FTP";                 # to differenciate between different types of blocks; used by hService


#############################
#####  parse all files  #####
#############################
my (%failed,%success) = ();
foreach my $file(@files)
{

        if (open(FILE,$file))
        {

                my $fileage = int(-M "$file");
                print color("yellow"), "[*] $0: parsing log file => $file  => $fileage days\n", color("reset");
                # Logs for Brute Force countermeasures
                # $ ln -s PATH_TO_LOGS/proftpd.auth/`hostname` /var/log/proftpd.auth.analyzeftp
                # $ vim proftpd.conf
                #     --->  LogFormat securityauthanalyzeftp "%a %U %m %s %{%j:%H}t"
                #     --->  ExtendedLog /var/log/proftpd.auth.analyzeftp auth securityauthanalyzeftp

                # FAILED Log sample:
                # 117.227.234.1 admin@brownsville****.com PASS 530 037:13
                # 78.26.151.176 brownsville****.com PASS 530 040:14

                # SUCCESS Log sample:
                # 69.112.171.200 netcam.ri****.com PASS 230 042:23

                while(my $line=<FILE>)
                {
                        chomp($line);


                        # count number of fields so we can count total fields, making sure it is what we expect
                        my @num_fields = split /\s+/, $line;
                        next if ( scalar ( @num_fields ) != '5');

                        # split line by spaces and assign to vars
                        my ( $ip,$user,$command,$code,$log_date ) = split(/\s+/,$line);

                        # split log_date by ':' into day:hour
                        my ($log_day,$log_hour) = split(/:/,$log_date);

                        # skip line if lines does not start with multiple digits for IPv4 / IPv6
                        next if ($line !~ m/^(\d+)/o);

                        # strip ip of trining space/tabs
                        chomp($ip);

                        # build a good & bad hash
                        if ( ( $log_date =~ $time_now ) || ( $log_date =~ $time_back ) )
                        {

                                $failed{$ip}{$user}++  if ($code =~ /530/o);
                                $success{$ip}{$user}++ if ($code =~ /230/o);
                        }
                } # end while

        close(FILE);

        } else {
                print "[*] $0: ERR: can't open `$file`.\n"; 
        }
}

print "\n";


##############################
#####  Connect to MySQL  #####
##############################
my $dsn = sprintf("DBI:mysql:database=%s;host=%s;mysql_connect_timeout=30",DB,MYSQLHOST);
my $dbh;
if (!($dbh = DBI->connect($dsn, USER, PWD, \%attr)))
{
        die "[*] $0: Error: $dbh->errstr\n";
        exit;
}

# get a list of whitelisted networks and store them in an array
my @whitelist_ipv4 = &whitelist($dbh,'whitelist','ipv4');
my @whitelist_ipv6 = &whitelist($dbh,'whitelist','ipv6');

my @tempwhitelist_ipv4 = &tempwhitelist($dbh,'temp_whitelist','ipv4');
my @tempwhitelist_ipv6 = &tempwhitelist($dbh,'temp_whitelist','ipv6');

# get a list of settings stored in mysql
my %dist = &auth_thresholds($dbh,'graylog_settings_connections');
if (scalar(keys(%dist)) < 1)
{
        print "[*] $0: ERROR: graylog_settings_connections table is empty!\n";
        $dbh->disconnect();
        exit(1);
}

# get a list of settings stored in mysql

my %history_thresholds = &get_history_thresholds ($dbh,'history_thresholdhits');
if (scalar(keys(%history_thresholds)) < 1)
{
        print "[*] $0: ERROR: history_thresholdhits table is empty!\n";
        $dbh->disconnect();
        exit(1);
}

print "\n";

####################################
#####  proccess FAILED entries  ####
####################################
if (scalar(keys(%failed)) > 0)
{

        foreach my $ip ( keys %failed )
        {

                my ($found,$counter_failed) = 0;

                my $type = &type ($ip);
                next if ( $type =~ "unknown" );

                ##################
                #####  IPv4  #####
                ##################
                if ( &valid_ipv4_host ( $ip ) )
                {

                        # IPv4: check if the IP is whitelisted: cidr 32
                        if (scalar( @tempwhitelist_ipv4 ) > 0)
                        {
                                if ( grep { $_ eq $ip} @tempwhitelist_ipv4 )
                                {
                                        $found = '1';
                                }
                        }


                        # if we found a match in @tempwhitelist_ipv4 skip IP
                        next if ( $found == 1 );

                        # IPv4: check if IP is whitelisted: cidr var
                        if (scalar( @whitelist_ipv4 ) > 0)
                        {
                                foreach my $subnet ( @whitelist_ipv4 ) 
                                {
                                        if(&in_subnet_ipv4($ip, $subnet ))
                                        {
                                                $found = '1';
                                                last;
                                        }
                                }
                        }

                        # if we found a match in @whitelist_ipv4 skip IP
                        next if ( $found == 1 );
                }

                # Did we miss anything ?
                next if ( $found == 1 );

                ##################
                #####  IPv6  #####
                ##################
                if ( &valid_ipv6_host ( $ip ) )
                {

                        ($found,$counter_failed) = '0';

                        # IPv4: check if the IP is whitelisted: cidr 32
                        if (scalar( @tempwhitelist_ipv6 ) > 0)
                        {
                                if ( grep { $_ eq $ip} @tempwhitelist_ipv6 )
                                {
                                        $found = '1';
                                }
                        }

                        # if we found a match in @tempwhitelist_ipv4 skip IP
                        next if ( $found == 1 );


                        # IPv4: check if IP is whitelisted: cidr var
                        if (scalar( @whitelist_ipv6 ) > 0)
                        {
                                foreach my $subnet ( @whitelist_ipv6 ) 
                                {
                                        if ( &in_subnet_ipv6 ($subnet, "$ip/128") )
                                        {
                                                $found = '1';
                                                last;
                                        }
                                }
                        }

                        # if we found a match in @whitelist_ipv4 skip IP
                        next if ( $found == 1 );
                }
                next if ( $found == 1 );

                # we are not in the whitelist
                if ($found == '0')
                {

                        # FAILED AUTH. Need to go through all domains.
                        foreach my $dom (sort keys %{$failed{$ip}})
                        {
                                #print "$ip, $dom: $failed{$ip}{$dom}\n"; #if ($failed{$ip}{$dom} > 5);
                                $counter_failed += $failed{$ip}{$dom};
                        }

                        # if number of  failed logins > threshold then take action
                        if ( $counter_failed > $thresholds{'failed_per_ip'} )
                        {

                                 my $n = &get_history_count($dbh,"history",$ip);
                                 # set to a random number, this get overwritten below
                                 my $block_seconds = 3600;

                                 my $geoip_country = &return_country ($ip);

                                 if ($n > 0 )
                                 {
                                             # is IP repeated offender ?
                                             $block_seconds = nearest( $counter_failed, \%history_thresholds );
                                 } else {
                                             # is IP temp offender ?
                                             $block_seconds = nearest( $counter_failed, \%dist );
                                 }

                                 print color("yellow"), "[*] $0: mysql => block IP:";
                                 print color("red"), "$ip";
                                 print color("yellow"), ",FAILED_HITS:$counter_failed,HISTORY:$n,Country:$geoip_country\n", color("reset");

                                 # set hostname into database so wen identify which environment was bruteforced
                                 my $insertby = "graylog-ftp-" . hostname;
                                 $insertby    = substr( $insertby, 0, 170 );  # DB entry max 200 chars, truncate to 170

                                 # insert the IP into the DB
                                 #&mysql_insert($dbh,'blacklist',"$type",$ip,$counter_failed,$block_seconds,$n,$geoip_country);
                                 &mysql_insert($dbh,'blacklist',$type,$ip,$counter_failed,$block_seconds,$n,$geoip_country,$insertby,"graylog-ftp");

                                 # next we log the block into separate graylog server for reporting
                                 &log_bad_ip ($ip,$db_string,$counter_failed,$block_seconds,$n,$geoip_country,$type);
                        } # end if
                } # end $found
        } # end foreach
} # end scalar

print "\n";

#########################################
#####  proccess SUCCESSFUL entries  #####
#########################################
if (scalar(keys(%success)) > 0)
{

        #foreach my $ip (sort ipsort_ipv4 keys %success) {
        foreach my $ip ( keys %success )
        {

                 my ($found,$counter_success) = 0;

                 my $type = &type ($ip);
                 next if ( $type =~ "unknown" );

                 ##################
                 #####  IPv4  #####
                 ##################
                 if ( &valid_ipv4_host ( $ip ) )
                 {
                         ($found,$counter_success) = '0';

                         # IPv4: check if the IP is whitelisted: cidr 32
                         if (scalar( @tempwhitelist_ipv4 ) > 0)
                         {
                                 if ( grep { $_ eq $ip} @tempwhitelist_ipv4 )
                                 {
                                         $found = '1';
                                 }
                         }

                         # if we found a match in @tempwhitelist_ipv4 skip IP
                         next if ( $found == 1 );

                         # IPv4: check if IP is whitelisted: cidr var
                         if (scalar( @whitelist_ipv4 ) > 0)
                         {
                                 foreach my $subnet ( @whitelist_ipv4 )
                                 {
                                         if(in_subnet_ipv4($ip, $subnet ))
                                         {
                                                 $found = '1';
                                                 last; # replaced next with last
                                         }
                                 }
                         }

                         # if we found a match in @whitelist_ipv4 skip IP
                         next if ( $found == 1 );
                  }
                  next if ( $found == 1 );

                 ##################
                 #####  IPv6  #####
                 ##################
                 if ( &valid_ipv6_host ( $ip ) )
                 {
                         ($found,$counter_success) = '0';

                         # IPv4: check if the IP is whitelisted: cidr 32
                         if (scalar( @tempwhitelist_ipv6 ) > 0)
                         {
                                 if ( grep { $_ eq $ip} @tempwhitelist_ipv6 ) 
                                 {
                                         $found = '1';
                                 }
                         }

                         # if we found a match in @tempwhitelist_ipv4 skip IP
                         next if ( $found == 1 );

                         # IPv4: check if IP is whitelisted: cidr var
                         if (scalar( @whitelist_ipv6 ) > 0)
                         {
                                 foreach my $subnet ( @whitelist_ipv6 )
                                 {
                                         if ( &in_subnet_ipv6 ($subnet, "$ip/128") )
                                         {
                                                 $found = '1';
                                                 last; # replaced next with last
                                         }
                                 }
                         }

                         # if we found a match in @whitelist_ipv4 skip IP
                         next if ( $found == 1 );

                }

                # we are not in the whitelist
                if ($found == '0')
                {

                        # SUCCESSFUL AUTH
                        $counter_success = grep {defined} keys %{$success{$ip}};
                        # my $counter_success = scalar(keys $success{$ip});

                        # if number of  failed logins > threshold then take action
                        if ( $counter_success > $thresholds{'success_max_domains_per_ip'} )
                        {

                                 my $n = &get_history_count($dbh,"history",$ip);

                                 # set to a random number, this get overwritten below
                                 my $block_seconds = '3600';

                                 my $geoip_country = &return_country ($ip);

                                 if ($n > 0 )
                                 {
                                         # is IP repeated offender ?
                                         $block_seconds = nearest( $counter_success, \%history_thresholds );
                                 } else {
                                         # is IP temp offender ?
                                         $block_seconds = nearest( $counter_success, \%dist );
                                 }

                                 print color("yellow"), "[*] $0: mysql => block IP:";
                                 print color("red"), "$ip";
                                 print color("yellow"), ",FAILED_HITS:$counter_success,HISTORY:$n,Country:$geoip_country\n", color("reset");

                                 # set hostname into database so wen identify which environment was bruteforced
                                 my $insertby = "graylog-ftp-" . hostname;

                                 # insert the IP into the DB
                                 #&mysql_insert($dbh,'blacklist',"$type",$ip,$counter_success,$block_seconds,$n,$geoip_country);
                                 &mysql_insert($dbh,'blacklist',$type,$ip,$counter_success,$block_seconds,$n,$geoip_country,$insertby,"graylog-ftp");

                                 # next we log the block into separate graylog server
                                 &log_bad_ip ($ip,$db_string,$counter_success,$block_seconds,$n,$geoip_country,$type);

                         } # end if
                } # end $found
        } # end foreach
} # end scalar

$dbh->disconnect();
#######################
#####  End MySQL  #####
#######################

exit(0);
#################
#####  END  #####
#################
