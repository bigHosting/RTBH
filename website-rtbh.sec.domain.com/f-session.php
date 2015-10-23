<?php

/*  (c) SecurityGuy 2015.08.22  */

/*
 *
 *---------------------------------------------------------------
 * Session constants
 *---------------------------------------------------------------
 *
 */
define ( 'TIMEOUT', 300 );  /*  Redirect to logout.php page if number > X  */
define ( 'VISITS',  100 );  /*  Redirect to logout.php page if number of clicks > 100 */

/*
 *---------------------------------------------------------------
 * Session time out in seconds
 *---------------------------------------------------------------
 *
 */
ini_set("session.gc_maxlifetime", TIMEOUT);


/*
 *---------------------------------------------------------------
 * Session time out in seconds
 *---------------------------------------------------------------
 *
 */
if(!isset($_SESSION)) session_start();
session_set_cookie_params(TIMEOUT);  // 5 min session

/*
 *---------------------------------------------------------------
 * Session time out in seconds
 *---------------------------------------------------------------
 *
 */
function get_remote_ip()
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

/*
 *---------------------------------------------------------------
 * Session time out in seconds
 *---------------------------------------------------------------
 *
 */
/*  validate session vars  */
if ( !isset ( $_SESSION['USER'] ) || empty ( $_SESSION['USER'] ) ) {
    header("location: logout.php");
    die();
}
if ( !isset ( $_SESSION['IPADDRESS'] ) || empty ( $_SESSION['IPADDRESS'] ) ) {
    header("location: logout.php");
    die();
}
if ( !isset ( $_SESSION['USERAGENT'] ) || empty ( $_SESSION['USERAGENT'] ) ) {
    header("location: logout.php");
    die();
}
if ( !isset ( $_SESSION['FINGERPRINT'] ) || empty ( $_SESSION['FINGERPRINT'] ) )
{
        header("location: logout.php");
        die();
}
if ( !isset ( $_SESSION['last_action'] ) || empty ( $_SESSION['last_action'] ) )
{
        header("location: logout.php");
        die();
}
if ( !isset ( $_SESSION['visits'] ) || empty ( $_SESSION['visits'] ) )
{
        header("location: logout.php");
        die();
}


/*
 *---------------------------------------------------------------
 * Session time out in seconds
 *---------------------------------------------------------------
 *
 */
/*  verify fingerprint, important for session highjacking  */
$IPADDRESS   = get_remote_ip();
$USERAGENT   = $_SERVER['HTTP_USER_AGENT'];
$FINGERPRINT = md5 ( $_SESSION['USER'] . $_SESSION['IPADDRESS'] .  $_SESSION['USERAGENT'] );

if ( $FINGERPRINT !== $_SESSION['FINGERPRINT'] )
{
        header("location: index.php");
        die();
}

/*
 *
 *---------------------------------------------------------------
 * Session time out in seconds
 *---------------------------------------------------------------
 *
 */
/*  Session fixation fix  */
if (!isset($_SESSION['initiated']))
{
        session_regenerate_id(false); /*  send new cookie  */
        $_SESSION['initiated'] = true;
}

if ($_SESSION['visits'] > VISITS)
{
        // last request was more than 300 seconds ago
        session_unset();     // unset $_SESSION variable for the run-time
        session_destroy();   // destroy session data in storage
        header("location: logout.php");                /*  User has been inactive for too long. Kill their session.  */
        die();
}
$_SESSION['visits']++;

/*
 *
 *---------------------------------------------------------------
 * Expire the session if user is inactive for > X seconds
 *---------------------------------------------------------------
 */
if ( time() - $_SESSION['last_action'] > TIMEOUT)
{
        // last request was more than 300 seconds ago
        session_unset();     // unset $_SESSION variable for the run-time
        session_destroy();   // destroy session data in storage
        header("location: logout.php");                /*  User has been inactive for too long. Kill their session.  */
        die();
}
$_SESSION['last_action'] = time();                     /*  Update last activity time stamp  */


/*
 *
 *--------------------------------------------------------------------------------------------------------------------------
 * Defeat Accunetix CSRF - generate nonce - this nonce will be used for this session only, using random values and the time
 *--------------------------------------------------------------------------------------------------------------------------
 *
 */
if ( !isset ( $_SESSION['nonce'] ) || empty ( $_SESSION['nonce'] ) )
{
       $nonce             = hash ("md5",rand().time().rand());
       $_SESSION['nonce'] = $nonce;
}

?>
