<?php

/* (c) SecurityGuy 2015.07.10 */

require_once 'f-session.php';

/*
 *
 *--------------------------------------------
 * Deny direct access if requested
 *--------------------------------------------
 *
 */
define ('DIRECT_ACCESS', 1);
if (!defined('DIRECT_ACCESS')) {
   // if our flag is not defined,
   // user is accessing our file directly
   die('ERR: access denied');
   exit;
}

require_once 'f-settings.php';
require_once 'c-pdo.php';
require_once 'f-ip.php';

$db = new dbHelper();

error_log("$time [$script_name] [rtbh] [$remote_addr] [request for $script_name]\n", 3, $log_file);

$error = "";

// source, destination fields can be missing, let's check the required ones first
if (isset($_POST['ip']) && isset($_POST['direction']) && isset($_POST['description']) )
{

        $direction = $_POST['direction'];

        /* 1. sanitize direction (table_name) */
        switch($direction)
        {
            case "blacklist":
                $table_name = "blacklist";
                $expiretime = '9999-12-31 23:59:59';
                break;

            case "temp_whitelist":
                $table_name = "temp_whitelist";
                $expiretime = date('Y-m-d H:i:s', strtotime(date("Y-m-d H:i:s") . ' + 7 days'));
                break;

            default:
                $table_name = "blacklist";
                $expiretime = '9999-12-31 23:59:59';
                break;
        } //end switch

        /* 2. sanitize description  */
        $description = filter_var($_POST['description'], FILTER_SANITIZE_SPECIAL_CHARS);
        $description = filter_var($description, FILTER_SANITIZE_SPECIAL_CHARS, FILTER_FLAG_STRIP_HIGH);
        //$description = make_safe( $description );

        /* 3. sanitize IP  */
        $ip     = $_POST['ip'];

        if(!filter_var($ip, FILTER_VALIDATE_IP)) {
                error_log("$time [$script_name] [rtbh] [$remote_addr-$myuser] [IP $ip NOT valid ]\n", 3, $log_file);
                $error = " IP not valid ";
        }


        /*  check what type of IP we're dealing with  */
        if ($error === "") {
                $type = type ($ip);
                if ( $type === "unknown" )
                {
                        error_log("$time [$script_name] [rtbh] [$remote_addr-$myuser] [IP $ip unknown, possible private range ]\n", 3, $log_file);
                        $error = " IP unknown ";
                }
        }

        if ($error === "") {
                if ( valid_ipv4_host ($ip) )
                {
                        $type = "ipv4";
                        $cidr = 32;
                }elseif ( valid_ipv6_host ($ip) )
                {
                        $type = "ipv6";
                        $cidr = 128;

                        /*  compress ipv6 to short form & lowercase  */
                        $ip = compress($ip);
                } else
                {
                        error_log("$time [$script_name] [rtbh] [$remote_addr-$myuser] [IP $ip invalid ]\n", 3, $log_file);
                        $error = " IP invalid ";
                }

        }

        // grab entries from DB
        if ($error === "") {

                if ( $type === "ipv4")
                {

                        $whitelist_4 = array();
                        $whitelist_4 = return_whitelist_4();

                        // check if the IP matches entries in our whitelist
                        if ( in_subnet_ipv4 ( $ip, $whitelist_4 ) ) {
                                error_log("$time [$script_name] [rtbh] [$remote_addr-$myuser] [FAILED to insert, IP $ip matches whitelist_4 ranges]\n", 3, $log_file);
                                $error = " IP matches in whitelist ranges, cannot continue ";
                        }
                }

                if ( $type === "ipv6")
                {

                        $whitelist_6 = array();
                        $whitelist_6 = return_whitelist_6();

                        // check if the IP matches entries in our whitelist
                        if ( in_subnet_ipv6 ( $ip, $whitelist_6 ) ) {
                                error_log("$time [$script_name] [rtbh] [$remote_addr-$myuser] [FAILED to insert, IP $ip matches whitelist_6 ranges]\n", 3, $log_file);
                                $error = " IP matches in whitelist ranges, cannot continue ";
                        }
                }
        }

        if ($error === "") {
                //$rows = $db->insert6($table_name, $ip, $cidr, $type, $description);
                $query_insert = sprintf ("insert into `%s` (sourceip, cidr, type, inserttime,expiretime,hits,country,comment,insertby,allow_edit) VALUES (inet6_pton('%s'),'%s','%s', NOW(), '%s',0,'US','%s','%s','Y') ON DUPLICATE KEY UPDATE inserttime=VALUES(inserttime),expiretime=VALUES(expiretime),hits=VALUES(hits),country=VALUES(country),insertby=VALUES(insertby),comment=VALUES(comment)", $table_name, $ip, $cidr, $type, $expiretime, $description, $_SESSION['USER'] );
                //echo $query_insert;
                $rows = $db->rawInsert($query_insert);
        }

// main if
} else {
      // missing required POST vars
      error_log("$time [$script_name] [rtbh] [$remote_addr-$myuser] [invalid POST data]\n", 3, $log_file);
      $error = " invalid post data ";
}

?>
<!doctype html>
<html lang="en-US">
<head>
<meta charset="utf-8" />
<meta name="description" content="rtbh">

<title>rtbh</title>

<link href="common/main-2.css" rel="stylesheet" type="text/css">
<link href="common/styles.css" rel="stylesheet" type="text/css">
<link href="common/hint.css" rel="stylesheet" type="text/css">
<script>
function goBack()
{
    window.history.back()
}
</script>
</head>

<?php include ("menu.php"); ?>

            <h1>RTBH</h1>

           <h3>Add new rtbh blocking rule <?php echo $desc ?></h3>
           <fieldset><legend>Result</legend>
           <?php

           if ($error === "") {
                   echo "<P class=\"notes\"> STATUS: &nbsp;<font style=\"color:red; font-weight:bold;\">". $rows['status'] . ", Message: ". $rows['message'].": '$ip/$cidr'</font> into table '$table_name'.";
                   echo "<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>\n";
           } else {
                   echo "<P class=\"notes\"> STATUS: " . $rows['status'] . ", Message: " . $rows['error'] . " Go <a><span onclick=\"goBack()\">Back</span></a> to retry.";
                   echo "<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>\n";
           }
           ?>

<?php include ("end.php"); ?>

