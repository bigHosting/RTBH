# INET6_ATON() & INET6_NTOA added to mysql 5.6.3, cannot use them on 5.5 server.
# However there is an UDF mysql plugin which adds this functionality into existing 5.5:
# https://bitbucket.org/watchmouse/mysql-udf-ipv6

use DBI;
use DBD::mysql;

# mysql settings
my %attr = (
        PrintError                  => 1,
        RaiseError                  => 1,
        PrintWarn                   => 0
);

# mysqlrun returns 1 row only, do not use for multiple!
sub mysqlrun
{
        my($dbh,$query)=@_;
        my($s,$r);
        $s=$dbh->prepare($query);
        $r=$s->execute();
        $r=($r>0) ? $s->fetchrow_hashref() : undef;
        $s->finish();
        return($r);
}

sub get_history_count
{
        my($dbh,$table,$ip) = @_;
        #my $query = sprintf("select count(*) AS TOTAL from `%s` where sourceip=inet6_ntop('%s')",$table,$ip);
        my $query =  sprintf("select count(*) as TOTAL from `%s` where inet6_ntop(sourceip) = '%s'",$table,$ip);
        #print "get_history_count: $query\n";
        my($r)=mysqlrun($dbh,$query);
        return (0) if ($r==undef);
        return ($r->{'TOTAL'});
}

# fast way of counting rows
sub mysql_count_rows
{
        my ($dbh,$table) = @_;
        my $num = '0';

        my $query = sprintf("SELECT TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '%s'",$table);
        #print "get_history_count: $query\n";
        my($r)=mysqlrun($dbh,$query);
        return (0) if ($r==undef);
        return ($r->{'TABLE_ROWS'});
}


# get whitelisted networks from the database
sub whitelist {
        my ($dbh,$table,$type) = @_;

        my $cidr_low  = 32;
        my $cidr_high = 128;

        my (@temp) = ();

        return (0) if ( $type !~ /ipv/ );

        print color("yellow"), "[*] $0: mysql => connecting to table => $table - $type [*]\n", color("reset");

        if ( $type eq "ipv4" )
        {
                $cidr_low  = 4;
                $cidr_high = 31;
        }

        if ( $type eq "ipv6" )
        {
                $cidr_low  = 32;
                $cidr_high = 127;
        }

        my $query = sprintf("SELECT CONCAT(inet6_ntop(sourceip),'/',cidr) AS network FROM `%s` WHERE ( cidr BETWEEN %s and %s) AND type='%s' ",$table,$cidr_low, $cidr_high,$type);
        my $sth = $dbh->prepare($query);
        my $count = $sth->execute();

        #print "[$0]: INFO: whitelist => $query";
        while (my $ref = $sth->fetchrow_hashref()) {
               my $entry = $ref->{'network'};

               # IPv4: check ip, CIDR where CIDR >= 4. Why /4 ? Because of 240.0.0.0/4 whitelist. whitelist table does not have /32 s
               if ( $entry =~ m|(^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/(\d{1,2})$| && ( $2 >= 4 ) && ( $2 < 32 ) )
               {
                       push(@temp,$entry);
                       #print "$entry\n";
               }

               # IPv6: check ip
               if ( &valid_ipv6_subnet ($entry))
               {
                       push(@temp,$entry);
                       #print "$entry\n";
               }
        }

        $sth->finish();
        return (@temp);
}

sub tempwhitelist {
        my ($dbh,$table,$type) = @_;

        my (@temp) = ();

        print color("yellow"), "[*] $0: mysql => connecting to table => $table - $type [*]\n", color("reset");

        my $query = sprintf("SELECT inet6_ntop(sourceip) AS sourceip from `%s` where cidr IN ('32','128') and type='%s'",$table,$type);
        my $sth = $dbh->prepare($query);
        my $count = $sth->execute();

        while (my $ref = $sth->fetchrow_hashref()) {
               my $entry = $ref->{'sourceip'};

               # IPv4: check ip. /32 only for ipv4
               if ( &valid_ipv4_host ($entry) )
               {
                       push(@temp,$entry);
                       #print "$entry\n";
               }

               # IPv6: check ip
               #if ( $entry =~ $ipv6 )
               if ( &valid_ipv6_host ($entry))
               {
                       push(@temp,$entry);
                       #print "$entry\n";
               }
        }

        $sth->finish();
        return (@temp);
}

sub auth_thresholds
{
        my ($dbh, $table) = @_;

        my %my_entries = ();

        print color("yellow"), "[*] $0: mysql => connecting to table => $table [*]\n", color("reset");

        my $query = sprintf("SELECT connections,block_for from `%s`",$table);
        my $sth = $dbh->prepare($query);
        my $count = $sth->execute();

        while (my $ref  = $sth->fetchrow_hashref()) {
               my $connections  = $ref->{'connections'};
               my $block_for    = $ref->{'block_for'};
               $my_entries{$connections} = $block_for;
        }

        $sth->finish();
        return (%my_entries);
}

# code copied from auth_thresholds, we should consider having only one function to 'catch' both of them
sub get_history_thresholds
{

        my ($dbh, $table) = @_;
        my %my_entries = ();

        print color("yellow"), "[*] $0: mysql => connecting to table => table $table [*]\n", color("reset");

        my $query = sprintf("SELECT hits,block_for from `%s`",$table);
        my $sth = $dbh->prepare($query);
        my $count = $sth->execute();

        while (my $ref  = $sth->fetchrow_hashref()) {
               my $hits       = $ref->{'hits'};
               my $block_for  = $ref->{'block_for'};
               $my_entries{$hits} = $block_for;
        }

        $sth->finish();
        return (%my_entries);
}


# insert row into DB
sub mysql_insert
{


        my ($dbh,$table,$type,$badip, $num, $sec, $repeted_offender, $country,$insertby,$comment)= @_;

        return (0) if ( $type !~ /ipv/ );

        my ($cidrdb) = 32;

        if ( $type eq "ipv4" )
        {
                $cidrdb = 32;
        }

        if ( $type eq "ipv6" )
        {
                $cidrdb = 128;
        }

        my $expiretime=strftime "%F %T", (localtime(time() + $sec));

        my $query = sprintf("INSERT INTO `%s` (`sourceip`,`cidr`,`expiretime`,`insertby`,`hits`,`comment`,`country`,`type`) 
        VALUES (inet6_pton('%s'),'%s','%s','%s','%s','%s','%s','%s') ON DUPLICATE KEY UPDATE inserttime=VALUES(inserttime),
        expiretime=VALUES(expiretime),hits=VALUES(hits),country=VALUES(country),insertby=VALUES(insertby),comment=VALUES(comment)",
        $table, $badip, $cidrdb, $expiretime, $insertby, $num, $comment, $country, $type );
        #print "$query\n";
        my $sth = $dbh->prepare($query);
        my $count = $sth->execute();

        $sth->finish();
        return 0;

}

sub mysql_getrecords
{

        my ($dbh, $table) = @_;
        my %my_entries = ();

        print color("yellow"), "[*] $0: mysql => connecting => table $table [*]\n", color("reset");

        my $query = sprintf("SELECT inet6_ntop(sourceip) AS ip, cidr from `%s`",$table);
        my $sth = $dbh->prepare($query);
        my $count = $sth->execute();

        while (my $ref  = $sth->fetchrow_hashref()) {
               my $my_ip           = $ref->{'ip'};
               my $my_cidr         = $ref->{'cidr'};
               $my_entries{$my_ip} = $my_cidr;
               #print "$my_ip\n";
        }

        $sth->finish();
        return (%my_entries);
}

sub mysql_getdeltas
{

        my ($dbh, $table, $query) = @_;
        my %my_entries = ();

        print color("yellow"), "[*] $0: mysql => connecting => table $table [*]\n", color("reset");

        #my $query = sprintf("SELECT inet6_ntop(sourceip) AS ip, cidr from `%s`",$table);
        #my $query = sprintf("%s",$q,$table);
        my $sth = $dbh->prepare($query);
        my $count = $sth->execute();

        while (my $ref  = $sth->fetchrow_hashref()) {
               my $my_ip           = $ref->{'ip'};
               $my_entries{$my_ip} = 1;
               #print "$my_ip\n";
        }

        $sth->finish();
        return (%my_entries);
}



1;
