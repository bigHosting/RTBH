<?php

//session_name('RTBH' . '_Session');

// Set the domain to default to the current domain.
//$domain = isset($domain) ? $domain : isset($_SERVER['SERVER_NAME']);

// Set the default secure value to whether the site is being accessed with SSL
//$https = isset($secure) ? $secure : isset($_SERVER['HTTPS']);
//session_set_cookie_params($limit, $path, $domain, $secure, true);

session_start();


/*
 *
 *--------------------------------------------
 * Deny direct access unless defined
 *--------------------------------------------
 *
 */
define ('DIRECT_ACCESS', 1);
if ( ! defined ('DIRECT_ACCESS') )
{
        die('ERR: access denied');
        die();
}

require_once 'f-settings.php';
require_once 'f-ldap.php';
require_once 'f-ip.php';

if ( isset ($_POST['myusername'], $_POST['mypassword']) )
{

        ob_start();

        /*
         *---------------------------------------------------------------
         * Call ldap_auth function from f-ldap.php
         *---------------------------------------------------------------
         *
         */
        if ( ldap_auth ($_POST['myusername'],$_POST['mypassword']) )
        {

                $my_usr = $_POST['myusername'];
                /*
                 *---------------------------------------------------------------
                 * Sanitize username
                 *---------------------------------------------------------------
                 *
                 */
                $my_usr  = filter_var($my_usr, FILTER_SANITIZE_STRING);
                $my_usr  = filter_var($my_usr, FILTER_SANITIZE_SPECIAL_CHARS, FILTER_FLAG_STRIP_HIGH);


                /*
                 *---------------------------------------------------------------
                 * Save the vars accross pages
                 *---------------------------------------------------------------
                 *
                 */
                $_SESSION = array();
                $_SESSION['USER']        = $my_usr;

                $_SESSION['IPADDRESS']   = get_client_ip();
                $_SESSION['USERAGENT']   = $_SERVER['HTTP_USER_AGENT'];
                $_SESSION['FINGERPRINT'] = md5 ( $_SESSION['USER'] . $_SESSION['IPADDRESS'] .  $_SESSION['USERAGENT'] );
                $_SESSION['visits']      = 1;

                $_SESSION['last_action'] = time();

                session_regenerate_id(false);
                $_SESSION['initiated']   = true;

                header("location: search-blacklist.php");
                die();

        } else {
                /*  redirect failed logins  */
                header("location: logine.php");
                die();
        }

        ob_end_flush();
}
/*  if we reached this step something must have gone wrong  */
header("location: logine.php");
die();

?>
