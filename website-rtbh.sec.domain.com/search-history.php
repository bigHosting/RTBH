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

?>
<!doctype html>
<html lang="en-US">
<head>
<meta charset="utf-8" />
<meta name="description" content="RTBH">

<title>RTBH</title>

<link rel="shortcut icon" href="/common/favicon.ico" />

<link href="common/main-2.css" rel="stylesheet" type="text/css">
<link href="common/styles.css" rel="stylesheet" type="text/css">
<link href="common/hint.css" rel="stylesheet" type="text/css">


<link href="common/ajax.css" rel="stylesheet" type="text/css">

</head>

<?php include ("menu.php"); ?>

<h1>RTBH</h1>

<fieldset>
<legend>RTBH Blacklist Search</legend>
<form name="search_form" method="GET" action="search-history-submit.php">
    <center>

    <div><input type="text" name="ip" id="keyword" class="typeahead tt-query" autocomplete="on" spellcheck="false" placeholder="Type your IP or subnet">
    <input class="submitbutton" value="View entry" type="submit"></div>

    <br><br>

    </center>
</form>
</fieldset>

<br>
<br><br>
<br><br>
<br><br>
<br><br>
<br>
<br><br>
<br><br>
<br><br>
<br><br>
<br>
<br><br>
<br><br>
<br><br>


<?php include ("end.php"); ?>
