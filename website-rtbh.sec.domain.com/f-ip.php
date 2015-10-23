<?php

/* (c) SecurityGuy 2015.07.10 */

/*
 *
 * Deny access if direct access is requested
 *
 */
if (!defined('DIRECT_ACCESS')) {
   // if our flag is not defined,
   // user is accessing our file directly
   die('ERR: access denied');
   exit;
}
setlocale(LC_ALL, 'en_US.UTF8');


function return_whitelist_4 ()
{

        require_once 'c-pdo.php';
        $db = new dbHelper();
        $rows = $db->select_whitelist("whitelist",array('type'=>'ipv4'));

        $counter = 0;

        $dummy = array();

        if ( count ( $rows['data'] ) > 0)
        {

                foreach($rows['data'] as $array)
                {


                        $network_and_cidr   = $rows['data'][$counter]['network'];

                        /* push to temporary array */
                        array_push($dummy, $network_and_cidr);
                        unset($network_and_cidr);

                        $counter++;

                }
        } else
        {
                /* fallback in case DB gets wiped */

                // ADD YOUR OWN IPv4 NETWORKS IN THIS SECTION

                array_push($dummy, '10.0.0.0/8');
                array_push($dummy, '127.0.0.0/8');
                array_push($dummy, '192.168.0.0/16');
                array_push($dummy, '172.16.0.0/12');
                array_push($dummy, '169.254.0.0/16');
                array_push($dummy, '10.70.16.0/20');
                array_push($dummy, '173.0.84.0/24');
                array_push($dummy, '173.0.88.0/24');
                array_push($dummy, '173.0.92.0/24');
                array_push($dummy, '173.0.93.0/24');
                array_push($dummy, '64.4.248.0/24');
                array_push($dummy, '64.4.249.0/24');
                array_push($dummy, '66.211.168.0/24');
                array_push($dummy, '186.231.0.0/24');
                array_push($dummy, '203.153.12.0/24');
                array_push($dummy, '203.153.13.0/24');
                array_push($dummy, '213.86.141.0/24');
                array_push($dummy, '64.218.169.0/24');
                array_push($dummy, '192.0.2.0/24');
                array_push($dummy, '224.0.0.0/4');
                array_push($dummy, '240.0.0.0/5');
                array_push($dummy, '248.0.0.0/5');
        }

        return ($dummy);
}

function return_whitelist_6 ()
{

        require_once 'c-pdo.php';
        $db = new dbHelper();
        $rows = $db->select_whitelist("whitelist",array('type'=>'ipv6'));

        $counter = 0;

        $dummy = array();

        if ( count ( $rows['data'] ) > 0)
        {

                foreach($rows['data'] as $array)
                {


                        $network_and_cidr   = $rows['data'][$counter]['network'];

                        /* push to temporary array */
                        array_push($dummy, $network_and_cidr);
                        unset($network_and_cidr);

                        $counter++;

                }
        } else
        {
                /* fallback in case DB gets wiped */

                // ADD YOUR OWN IPv6 NETWORKS IN THIS SECTION

                array_push($dummy, 'fc00::/7');
                array_push($dummy, 'fe80::/10');
                array_push($dummy, 'fec0::/10');
                array_push($dummy, 'ff00::/8');
        }

        return ($dummy);
}



function get_client_ip()
{
    $ipaddress = '';
    if ($_SERVER['HTTP_CLIENT_IP'])
        $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
    else if ($_SERVER['HTTP_X_FORWARDED_FOR'])
        $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
    else if ($_SERVER['HTTP_X_FORWARDED'])
        $ipaddress = $_SERVER['HTTP_X_FORWARDED'];
    else if ($_SERVER['HTTP_FORWARDED_FOR'])
        $ipaddress = $_SERVER['HTTP_FORWARDED_FOR'];
    else if ($_SERVER['HTTP_FORWARDED'])
        $ipaddress = $_SERVER['HTTP_FORWARDED'];
    else if ($_SERVER['REMOTE_ADDR'])
        $ipaddress = $_SERVER['REMOTE_ADDR'];
    else
        $ipaddress = 'UNKNOWN';

    return $ipaddress;
}

function valid_ipv4_host( $ip )
{
        if ( !$ip ) return false;

        /* validate ipv4 IP excluding private ranges */
        if(filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4 | FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE )){
                /* safetynet exclude 0.0.0.0 */
                if ($ip === "0.0.0.0") {
                        return false;
                }

                /* safetynet exclude 255.255.255.255 */
                if ($ip === "255.255.255.255") {
                        return false;
                }

                return true;
        }

        return false;

}


function valid_ipv6_host( $ip )
{
        if ( !$ip ) return false;

        /* validate ipv6 IP excluding private ranges */
        if(filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6 | FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE )){
                return true;
        }
        return false;
}

function type  ( $ip )
{
        if ( !$ip ) return false;

        if ( valid_ipv4_host( $ip ) )
        {
                return "ipv4";
        }

        if ( valid_ipv6_host( $ip ) )
        {
                return "ipv6";
        }

        return "unknown";
}


function get_cidr ( $ip )
{
        $my_cidr = 32;

        if(filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4 ))
        {
                $my_cidr = 32;
        }

        else
        /* (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6 )) */
        {
                $my_cidr = 128;
        }

        return $my_cidr;
}

/* ipv6 converts inet_pton output to string with bits */
function inet_to_bits($inet)
{
   $unpacked = unpack('A16', $inet);
   $unpacked = str_split($unpacked[1]);
   $binaryip = '';
   foreach ($unpacked as $char) {
             $binaryip .= str_pad(decbin(ord($char)), 8, '0', STR_PAD_LEFT);
   }
   return $binaryip;
}

/* check if ipv6 address is within cidr block
$ip='21DA:00D3:0000:2F3B:02AC:00FF:FE28:9C5A';
$cidrnet='21DA:00D3:0000:2F3B::/64';
if ( in_subnet_ipv6 ($cidrnet, $ip) )
{
        echo "In subnet\n";
} else
{
        echo "NOT in subnet\n";
}
function in_subnet_ipv6 ($ip, $cidrnet)
{
        if ( !$cidrnet ) return false;
        if ( !$ip ) return false;

        if (! is_array ($cidrnet) )
        {
                return false;
        }


        $ip = inet_pton($ip);
        $binaryip=inet_to_bits6($ip);

        list($net,$maskbits)=explode('/',$cidrnet);
        if ( $net > 127){ return false; };

        $net=inet_pton($net);
        $binarynet=inet_to_bits6($net);

        $ip_net_bits=substr($binaryip,0,$maskbits);
        $net_bits   =substr($binarynet,0,$maskbits);

        if($ip_net_bits!==$net_bits)
        {
                //echo 'Not in subnet';
                return false;
        } else
        {
                //echo 'In subnet';
                return true;
        }

        return false;
} */

function in_subnet_ipv6 ( $ip , $array)
{
        if ( !$ip ) return false;
        if ( !$array ) return false;

        if ( ! is_array ( $array ) )
        {
                //echo "Array is not array.\n";
                return false;
        }

        foreach ( $array as $cidrnet)
        {
                if ( !$cidrnet ) return false;

                // echo "Looping through $cidrnet\n";
                $myip = inet_pton($ip);
                $binaryip=inet_to_bits($myip);

                list($net,$maskbits)=explode('/',$cidrnet);
                $net=inet_pton($net);
                $binarynet=inet_to_bits($net);

                $ip_net_bits=substr($binaryip,0,$maskbits);
                $net_bits   =substr($binarynet,0,$maskbits);

                if ( $ip_net_bits === $net_bits )
                {
                        // echo "Found $ip in $cidrnet\n";
                        return true; /* in subnet */
                }
        }
        return false;
}

/*  check if ipv4 address is within cidr block. cidr replaced with array.
/* function in_subnet_ipv4($ip, $mycidr)
{
        if ( !$ip ) return false;
        if ( !$mycidr ) return false;

        $parts = explode( '/', $mycidr, 2 );
        if ( count( $parts ) != 2 ) {
                return false;
        }

        list($network,$cidr)=explode('/',$mycidr);
        if ( $cidr > 31){ return false; };

        if ((ip2long($ip) & ~((1 << (32 - $cidr)) - 1) ) == ip2long($network))
        {
            return true;
        }

    return false;
} */

function in_subnet_ipv4($ip,$array)
{

        if ( !$ip ) return false;
        if ( !$array ) return false;

        if (! is_array ($array) )
        {
                return false;
        }

        foreach ($array as $mycidr) {

                $parts = explode( '/', $mycidr, 2 );
                if ( count( $parts ) != 2 ) {
                        return false;
                }

                list($network,$cidr)=explode('/',$mycidr);
                if ( $cidr > 31){ return false; };

                if ((ip2long($ip) & ~((1 << (32 - $cidr)) - 1) ) == ip2long($network))
                {
                        return true;
                }

                return false;
        }
}
/*

$arr = array("10.0.0.0/8","127.0.0.0/8");
if ( in_subnet_ipv4 ( '104.10.11.26', $arr) )
{
    echo "IN\n";
} else {
    echo "NOT\n";
}
*/

/* http://algorytmy.pl/doc/php/function.ip2long.php */
function matchCIDR($addr, $cidr) {
        // $addr should be an ip address in the format '0.0.0.0'
        // $cidr should be a string in the format '10/8'
        //      or an array where each element is in the above format
        $output = false;

        if ( is_array($cidr) ) {

                foreach ( $cidr as $cidrlet ) {
                        if ( matchCIDR( $addr, $cidrlet) ) {
                                $output = true;
                        }
                }
        } else {
                list($ip, $mask) = explode('/', $cidr);
                $mask = 0xffffffff << (32 - $mask);
                $output = ((ip2long($addr) & $mask) == (ip2long($ip) & $mask));
        }
        return $output;
}

// echo inet6_ntop(inet6_pton('2001:4860:a005::68')) . "\n";
// https://bitbucket.org/watchmouse/mysql-udf-ipv6
// http://stackoverflow.com/questions/10085266/php5-calculate-ipv6-range-from-cidr-prefix
/**
 * dtr_pton
 *
 * Converts a printable IP into an unpacked binary string
 *
 * @author Mike Mackintosh - mike@bakeryphp.com
 * @param string $ip
 * @return string $bin
 */
function inet6_pton( $ip ){

    if(filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)){
        return current( unpack( "A4", inet_pton( $ip ) ) );
    }
    elseif(filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6)){
        return current( unpack( "A16", inet_pton( $ip ) ) );
    }

    throw new \Exception("Please supply a valid IPv4 or IPv6 address");

    return false;
}

// http://stackoverflow.com/questions/10085266/php5-calculate-ipv6-range-from-cidr-prefix
/**
 * dtr_ntop
 *
 * Converts an unpacked binary string into a printable IP
 *
 * @author Mike Mackintosh - mike@bakeryphp.com
 * @param string $str
 * @return string $ip
 */
function inet6_ntop( $str ){
    if( strlen( $str ) == 16 OR strlen( $str ) == 4 ){
        return inet_ntop( pack( "A".strlen( $str ) , $str ) );
    }

    throw new \Exception( "Please provide a 4 or 16 byte string" );

    return false;
}

/* copied from SimplePie ipv6.php */
/**
     * Compresses an IPv6 address
     *
     * RFC 4291 allows you to compress concecutive zero pieces in an address to
     * '::'. This method expects a valid IPv6 address and compresses consecutive
     * zero pieces to '::'.
     *
     * Example:  FF01:0:0:0:0:0:0:101   ->  FF01::101
     *           0:0:0:0:0:0:0:1        ->  ::1
     *
     * @see uncompress()
     * @param string $ip An IPv6 address
     * @return string The compressed IPv6 address
*/

/* added strtolower */
function compress($ip)
{
        // Prepare the IP to be compressed
        $ip = uncompress($ip);
        $ip_parts = split_v6_v4($ip);

        // Replace all leading zeros
        $ip_parts[0] = preg_replace('/(^|:)0+([0-9])/', '\1\2', $ip_parts[0]);

        // Find bunches of zeros
        if (preg_match_all('/(?:^|:)(?:0(?::|$))+/', $ip_parts[0], $matches, PREG_OFFSET_CAPTURE))
        {
            $max = 0;
            $pos = null;
            foreach ($matches[0] as $match)
            {
                if (strlen($match[0]) > $max)
                {
                    $max = strlen($match[0]);
                    $pos = $match[1];
                }
            }

            $ip_parts[0] = substr_replace($ip_parts[0], '::', $pos, $max);
        }

        if ($ip_parts[1] !== '')
        {
            return strtolower ( implode(':', $ip_parts) );
        }
        else
        {
            return strtolower ( $ip_parts[0] );
        }
}

/* copied from SimplePie ipv6.php */
function uncompress($ip)
{
        $c1 = -1;
        $c2 = -1;
        if (substr_count($ip, '::') === 1)
        {
            list($ip1, $ip2) = explode('::', $ip);
            if ($ip1 === '')
            {
                $c1 = -1;
            }
            else
            {
                $c1 = substr_count($ip1, ':');
            }
            if ($ip2 === '')
            {
                $c2 = -1;
            }
            else
            {
                $c2 = substr_count($ip2, ':');
            }
            if (strpos($ip2, '.') !== false)
            {
                $c2++;
            }
            // ::
            if ($c1 === -1 && $c2 === -1)
            {
                $ip = '0:0:0:0:0:0:0:0';
            }
            // ::xxx
            else if ($c1 === -1)
            {
                $fill = str_repeat('0:', 7 - $c2);
                $ip = str_replace('::', $fill, $ip);
            }
            // xxx::
            else if ($c2 === -1)
            {
                $fill = str_repeat(':0', 7 - $c1);
                $ip = str_replace('::', $fill, $ip);
            }
            // xxx::xxx
            else
            {
                $fill = ':' . str_repeat('0:', 6 - $c2 - $c1);
                $ip = str_replace('::', $fill, $ip);
            }
        }
        return strtolower ( $ip );
}

/* copied from SimplePie ipv6.php */
/**
     * Splits an IPv6 address into the IPv6 and IPv4 representation parts
     *
     * RFC 4291 allows you to represent the last two parts of an IPv6 address
     * using the standard IPv4 representation
     *
     * Example:  0:0:0:0:0:0:13.1.68.3
     *           0:0:0:0:0:FFFF:129.144.52.38
     *
     * @param string $ip An IPv6 address
     * @return array [0] contains the IPv6 represented part, and [1] the IPv4 represented part
*/
function split_v6_v4($ip)
{
        if (strpos($ip, '.') !== false)
        {
            $pos = strrpos($ip, ':');
            $ipv6_part = substr($ip, 0, $pos);
            $ipv4_part = substr($ip, $pos + 1);
            return array($ipv6_part, $ipv4_part);
        }
        else
        {
            return array($ip, '');
        }
}

/* copied from SimplePie ipv6.php */
/**
     * Checks an IPv6 address
     *
     * Checks if the given IP is a valid IPv6 address
     *
     * @param string $ip An IPv6 address
     * @return bool true if $ip is a valid IPv6 address
*/
function check_ipv6($ip)
{
        $ip = uncompress($ip);
        list($ipv6, $ipv4) = split_v6_v4($ip);
        $ipv6 = explode(':', $ipv6);
        $ipv4 = explode('.', $ipv4);
        if (count($ipv6) === 8 && count($ipv4) === 1 || count($ipv6) === 6 && count($ipv4) === 4)
        {
            foreach ($ipv6 as $ipv6_part)
            {
                // The section can't be empty
                if ($ipv6_part === '')
                    return false;

                // Nor can it be over four characters
                if (strlen($ipv6_part) > 4)
                    return false;

                // Remove leading zeros (this is safe because of the above)
                $ipv6_part = ltrim($ipv6_part, '0');
                if ($ipv6_part === '')
                    $ipv6_part = '0';

                // Check the value is valid
                $value = hexdec($ipv6_part);
                if (dechex($value) !== strtolower($ipv6_part) || $value < 0 || $value > 0xFFFF)
                    return false;
            }
            if (count($ipv4) === 4)
            {
                foreach ($ipv4 as $ipv4_part)
                {
                    $value = (int) $ipv4_part;
                    if ((string) $value !== $ipv4_part || $value < 0 || $value > 0xFF)
                        return false;
                }
            }
            return true;
        }
        else
        {
            return false;
        }
}

//echo compress ( 'FF01:0:0:0:0:0:0:101') . "\n";
//echo compress ( '2001:0000:1234:0000:0000:C1C0:ABCD:0876' ) . "\n";
//echo compress ( '0:0:0:0:0:0:0:1') . "\n";

?>


