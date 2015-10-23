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

$db = new dbHelper();
$error = "";

include ("menu.php");



if ( isset ( $_GET['id'] ) &&  isset ( $_GET['table'] ) )
{

        $id      = $_GET['id'];
        $table   = $_GET['table'];

        if ( ! is_numeric ( $id ) )
        {
                $error   = " id is not numeric ";
                $status  = "ERROR";
                $message = $error;
        }

        switch($table)
        {
            case "blacklist":
                error_log("$time [$script_name] [rtbh] [$remote_addr-$myuser] [add to blacklist]\n", 3, $log_file);
                $table_name = "blacklist";
                break;

            case "temp_whitelist":
                //error_log("$time [$script_name] [rtbh] [$remote_addr-$myuser] [dynamic-add.php add into DYNAMIC_HTTP_OUT]\n", 3, $log_file);
                $table_name = "temp_whitelist";
                break;

            default:
                //error_log("$time [$script_name] [rtbh] [$remote_addr-$myuser] [failed action $chain]\n", 3, $log_file);
                $error = " invalid table ";
                $status  = "ERROR";
                $message = $error;
                break;
      } //end switch
} else {
        //error_log("$time [$script_name] [rtbh] [$remote_addr-$myuser] [no chain specified]\n", 3, $log_file);
        $error    = " invalid params ";
        $status   = "ERROR";
        $message  = $error;
}

        if ( $error === "")
        {
              /* select row from DB */

              $del_user = $_SESSION['USER'];

              $rows = $db->select6($table_name,array('id'=>"$id"));

              /* make sure we have at leats 1 row . If not it means rowid not in DB */
              if ( count ( $rows['data'] )  > 0)
              {
                      $sourceip   = $rows['data'][0]['ip'];

                      /* keep track of the user deleting the row */
                      $rows = $db->update($table_name,array('insertby' => "$del_user"),array('id'=>"$id"), array('insertby'));

                      /* delete the row */
                      $rows    = $db->delete($table_name, array('id' => "$id"));

                      $status  = $rows['status'];
                      $message = $rows['message'] . ", $sourceip deleted.";
              } else {
                      $error    = " row id does not exist ";
                      $status   = "ERROR";
                      $message  = $error;
              }
        }
?>
<!doctype html>
<html lang="en-US">
<head>
<meta charset="utf-8" />
<meta name="description" content="RTBH">
<link rel="shortcut icon" href="/common/favicon.ico" />
<title>RTBH</title>

<link href="common/main-2.css" rel="stylesheet" type="text/css">
<link href="common/styles.css" rel="stylesheet" type="text/css">
<link href="common/hint.css" rel="stylesheet" type="text/css">
</head>

<h1>RTBH</h1>

<h3>Delete IP status</h3>
<fieldset><legend>Table: <?php echo $table_name; ?></legend>
    <table border=0 cellpadding=2 cellspacing=0 width=100% class="sortable">
        <tr>
            <td class="table_row1" colspan="9" width="100%"><center><b><?php echo "STATUS: $status, Message: $message"; ?><b></b></b></center></td>
        </tr>
    </tbody>
    </table>
</fieldset><br></td></tr>
</table><br></fieldset><br><br><br><br><br><br><br><br><br><br><br>

<?php include ("end.php"); ?>
