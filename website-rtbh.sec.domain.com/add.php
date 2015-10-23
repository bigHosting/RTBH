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


$error = "";

error_log("$time [$script_name] [rtbh] [$remote_addr-$myuser] [request for $script_name]\n", 3, $log_file);


$ip    = isset($_GET['ip']) ? $_GET['ip'] : "";

if (isset($_GET['table']) )
{
        /*  default value  */
        $table_name = "blacklist";

        $table  = $_GET['table'];

        switch($table)
        {
            case "blacklist":
                $table_name = "blacklist";
                break;

            case "temp_whitelist":
                $table_name = "temp_whitelist";
                break;

            default:
                $table_name = "blacklist";
                break;
      } //end switch


} else {
        $table_name = "blacklist";
}
?>
<!doctype html>
<html lang="en-US">
<head>
<meta charset="utf-8" />
<meta name="description" content="rtbh">
<link rel="shortcut icon" href="/common/favicon.ico" />
<title>rtbh</title>


<link href="common/main-2.css" rel="stylesheet" type="text/css">
<link href="common/styles.css" rel="stylesheet" type="text/css">
<link href="common/hint.css" rel="stylesheet" type="text/css">

</head>

<?php include ("menu.php"); ?>

            <h1>RTBH</h1>

           <h3>Add new blacklist rule</h3>
           <fieldset><legend>IPv4/IPv6 form</legend>

           <div class="loginform">

             <form action="add-submit.php" method="post" name="iform" id="iform">
               <table width="100%" border="0" cellpadding="6" cellspacing="0">

               <!-- ACTION -->
               <tr>
                        <td width="22%" valign="top" class="vncellreq"><label for="Action">Action</label></td>
                        <td width="78%" class="vtable">
                                <select name="table" class="formselect">
                                        <option value="<?php echo $table_name?>" selected><?php echo $table_name?></option>
                                </select>
                                <br>
                        </td>
                </tr>
                <tr><td><br></br></tr>


               <!-- SOURCE -->
               <tr>

                        <td width="22%" valign="top" class="vncellreq"><label for="Source">Source</label></td>
                        <td width="78%" class="vtable">
                                <table border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                                <td><label for="srctype">Type:&nbsp;&nbsp;</label></td>
                                                <td>
                                                        <select name="srctype" class="formselect">
                                                                <option value="single" selected>Single host ( /32 or /128 )</option>
                                                        </select>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td><label for="Address1">IP Address:&nbsp;&nbsp;</label></td>
                                                <td>
                                                        <input name="ip" type="text" class="formfldalias" id="ip" size="20" maxlength="150" placeholder="IPv4/IPv6 address" required pattern=".{7,}" value="<?php echo $ip; ?>">
                                                </td>
                                        </tr>
                                </table>

                        </td>
                </tr>
                <tr><td><br></br></tr>



                </table>
                <br>
                </td>
                </tr>


                <tr><td><br></br></tr>

                <tr>
                        <td width="22%" valign="top" class="vncell"><label for="Description">Description</label></td>
                        <td width="78%" class="vtable">
                                <input name="description" type="text" class="unknown" id="unknown" size="36" maxlength="52" required pattern=".{6,}" title="min 6 chars" placeholder="Description_here" required>
                                <br>
                        </td>
                </tr>
                <tr>
                        <td width="22%" valign="top">&nbsp;</td>
                        <td width="78%">
                                &nbsp;<br>&nbsp;
                                <input id="submit" name="submit" type="submit" class="choises" value="Save">
                                <input type="button" class="choises" value="Back" onclick="history.back()">
                                <input type="hidden" value="<?php echo $table_name?>" name="direction">
                        </td>
                </tr>

                <tr>
                        <td>&nbsp;</td>
                </tr>



                <tr>
                        <td>&nbsp;</td>
                </tr>

        </table>
</form>

<br>
<br>

                <tr>
                        <td width="22%" valign="top" class="vncell"><label for="Description">Info</label></td>
                        <td>
                                Temporary whitelist will be done for <font color="red"><b>7 (seven) days</b></font> 
                                and expired entries will be automatically removed. After whitelisting an IP it will take up to 
                                <font color="red"><b>2 HOURS</b></font> for whitelist to take effect. <font color="red"><b>BrightCloud</b></font> updates
                                database removals every <font color="red"><b>24 HOURS</b></font>.
                                <br>
                        </td>
                </tr>

                </div> <!-- Right DIV -->

        </div> <!-- Content DIV -->

</div> <!-- Wrapper Div -->


<?php include ("end.php"); ?>
