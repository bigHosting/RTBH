<?php

/* (c) Security Guy 2015.07.10 */

/*
 *
 *--------------------------------------------
 * Deny direct access if requested
 *--------------------------------------------
 *
 */
if (!defined('DIRECT_ACCESS')) {
   // if our flag is not defined,
   // user is accessing our file directly
   die('ERR: access denied');
   exit;
}
setlocale(LC_ALL, 'en_US.UTF8');

/*
 * This can be set to anything, but default usage is:
 *
 *     development
 *     testing
 *     production
 *
 * NOTE: If you change these, also change the error_reporting() code below
 *
 */

define('ENVIRONMENT', 'production');

/*
 *---------------------------------------------------------------
 * ERROR REPORTING
 *---------------------------------------------------------------
 *
 * Different environments will require different levels of error reporting.
 * By default development will show errors but testing and live will hide them.
 */

if (defined('ENVIRONMENT'))
{
        switch (ENVIRONMENT)
        {
                case 'development':
                        /*  debugging turned on  */
                        error_reporting(E_ALL);
                        ini_set('display_errors', 1);
                        ini_set('log_errors', 1);
                        ini_set('display_startup_errors', 1);
                break;

                case 'testing':
                case 'production':
                        /*  debugging turned off  */
                        error_reporting(0);
                        ini_set('display_errors', 0);
                        ini_set('log_errors', 1);
                        ini_set('display_startup_errors', 0);
                break;

                default:
                        exit('The application environment is not set correctly.');
        }
}



/*
 *
 *-------------------------------------------
 * Check and set default time zone
 *-------------------------------------------
 *
 */
if ( ! ini_get('date.timezone') )
{
        date_default_timezone_set('America/New_York');
}

/*  session_regenerate_id will send new cookie, disabling these both  */
//ini_set("session.use_cookies",0);
//ini_set("session.use_only_cookies",1);

ini_set('session.use_trans_sid', '0');
ini_set('session.entropy_file', "/dev/urandom");

ini_set("session.gc_probability",1);
ini_set("session.gc_divisor",1);


/*
 *
 *----------------------------------------------
 * Check and set default session time out 5 min
 *----------------------------------------------
 *
 */
if ( ! ini_get('session.gc-maxlifetime') )
{
        ini_set('session.gc-maxlifetime', 300);
}

/*
 *
 *--------------------------------------------
 * common settings
 *--------------------------------------------
 *
 */
$remote_addr = $_SERVER['REMOTE_ADDR'];
$script_name = pathinfo($_SERVER['PHP_SELF'], PATHINFO_FILENAME);
$time        = @date('[d/M/Y:H:i:s]');
$time_log    = @date('[d/M/Y:H:i:s]');
$todaysdate  = @date('Ymd');

$log_file    = "/var/log/rtbh.log";

/* $cidr_exceptions = array("0", "1", "2", "3","4","5","6","7","8","9","10","11","12","13","14","15");
$cidr_exceptions = array("0", "1", "2", "3"); */


?>


