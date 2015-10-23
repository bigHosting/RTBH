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
$rows = $db->select6("temp_whitelist",array());

?>
<!doctype html>
<html lang="en-US">
<head>
<meta charset="utf-8" />
<meta name="description" content="RTBH">
<link rel="shortcut icon" href="common/favicon.ico" />
<title>RTBH</title>

<link href="common/main-2.css" rel="stylesheet" type="text/css">
<link href="common/styles.css" rel="stylesheet" type="text/css">
<link href="common/hint.css" rel="stylesheet" type="text/css">

<link rel="stylesheet" type="text/css" href="./media/css/jquery.dataTables.css">

</head>

<?php include ("menu.php"); ?>


<?php


echo "<h1>RTBH</h1>

<h3>Permanently whitelisted networks</h3>
<fieldset><legend>Source networks</legend>
<table border=0 cellpadding=2 cellspacing=0 width=100% id=\"example\" class=\"display\">
        <thead>
        <tr>
                <th align=left class=table_sub_sub_header>Id&nbsp;&nbsp</th>
                <th align=left class=table_sub_sub_header>IP&nbsp;&nbsp</th>
                <th align=left class=table_sub_sub_header>CIDR&nbsp;&nbsp</th>
                <th align=left class=table_sub_sub_header>Type&nbsp;&nbsp</th>
                <th align=left class=table_sub_sub_header>&nbsp;Inserted on&nbsp;&nbsp</th>
                <th align=left class=table_sub_sub_header>&nbsp;Expires on&nbsp;&nbsp</th>
                <th align=left class=table_sub_sub_header>&nbsp;Hits&nbsp;&nbsp</th>
                <th align=left class=table_sub_sub_header>&nbsp;Comment&nbsp;&nbsp</th>
                <th align=left class=table_sub_sub_header>&nbsp;Insertby&nbsp;&nbsp</th>
                <th align=left class=table_sub_sub_header>&nbsp;Country&nbsp</th>
                <th align=left class=table_sub_sub_header>&nbsp;Action&nbsp</th>
       </tr>
       </thead>";

echo " <tfoot>
        <tr>
                <th>Id</th>
                <th>IP</th>
                <th>CIDR</th>
                <th>Type</th>
                <th>Inserted</th>
                <th>Expiretime</th>
                <th>Hits</th>
                <th>Comment</th>
                <th>Insertby</th>
                <th>Country</th>
                <th>Action</th>

       </tr>
       </tfoot>";
if ( count ( $rows['data'] ) > 0)
{

         $counter = 0;
         $numar   = 0;

         foreach($rows['data'] as $array){

                        $numar++;
                        if(($numar%2)==1){ $col='1'; } else { $col='2';}

                        $id         = $rows['data'][$counter]['id'];
                        $sourceip   = $rows['data'][$counter]['ip'];
                        $cidr       = $rows['data'][$counter]['cidr'];
                        $type       = $rows['data'][$counter]['type'];
                        $expiretime = $rows['data'][$counter]['expiretime'];
                        $inserttime = $rows['data'][$counter]['inserttime'];
                        $comment    = $rows['data'][$counter]['comment'];
                        $insertby   = $rows['data'][$counter]['insertby'];
                        $hits       = $rows['data'][$counter]['hits'];
                        $country    = $rows['data'][$counter]['country'];

                        if (preg_match("/9999/i",$expiretime)) {
                                $expiretime = "never";
                        }

                        echo "\n<tr class=table_row$col>
                                    <td align=left><font color=\"black\">$id.&nbsp;</font></td>
                                    <td align=left><font color=\"black\">$sourceip</font></td>
                                    <td align=left><font color=\"black\">$cidr</font></td>
                                    <td align=left><font color=\"black\">$type</font></td>
                                    <td align=left><font color=\"black\">$inserttime</font></td>
                                    <td align=left><font color=\"black\">$expiretime</font></td>
                                    <td align=left><font color=\"black\">$hits</font></td>
                                    <td align=left><font color=\"black\">$comment</font></td>
                                    <td align=left><font color=\"black\">$insertby</font></td>
                                    <td align=left><font color=\"black\">$country</font></td>";

                        echo       "<td align=left nowrap>
                                        <a href=\"delete.php?table=temp_whitelist&id=$id\"  class=\"hint--left  hint--error hint--rounded\"   data-hint=\"Delete entry\" onclick=\"return confirm('Are you sure to remove row id=$id ?')\"><img src=\"common/118.png\" height=\"16px\" weigh=\"16px\"></a>
                                        <a href=\"add.php?table=temp_whitelist\"            class=\"hint--left  hint--success hint--rounded\" data-hint=\"Add new entry\"><img src=\"common/112.png\" height=\"16px\" weigh=\"16px\"></a>";


                        $counter++;
        }
} else
{
        /* 0 records */
        echo "<tr><td class=\"table_row1\" colspan=\"9\" width=\"100%\"><center><b> Invalid request or 0 results returned<b></b></b></center></td></tr></tbody></table></fieldset><br>";

}

         echo "</td></tr>";
         echo "</table><br></fieldset><br><br>";

?>

        <div>
            <script type="text/javascript" language="javascript" src="./media/js/jquery.js"></script>
            <script type="text/javascript" language="javascript" src="./media/js/jquery.dataTables.js"></script>
            <script>
                $(document).ready(function() {
                    $('#example').dataTable( {
                            "lengthMenu": [[10, 25, 100, -1], [10, 25, 100, "All"]]
                    } );
                });
            </script>
        </div>

<?php include ("end.php"); ?>
