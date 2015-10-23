<?php

/* (c) SecurityGuy 2015.07.10 */

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
 *
 *--------------------------------------------
 * LDAP settings
 *--------------------------------------------
 *
 */
$ldap['base']         = "ou=users,o=Domain,dc=domain,dc=com";
$ldap['attribute']    = "description";
$ldap['filter']       = "(&(objectClass=posixAccount)(uid={login}))"; // custom fields removed
$ldap['group_allow']  = "support|abuse";
$ldap['usr_min_len']  = 3;
$ldap['usr_max_len']  = 50;
$ldap['pass_min_len'] = 6;

/*
 *
 *--------------------------------------------
 * Enumerate all ldap VIPs for random pick
 *--------------------------------------------
 *
 */
$ldap['servers'] = array (
        'umsrv1s.sec.domain.com',
        'umsrv2s.sec.domain.com',
        'umsrv3s.sec.domain.com',
);


/* http://php.net/manual/en/function.ldap-connect.php */
function ldap_ping($host, $port=636, $timeout=5)
{
        $op = fsockopen($host, $port, $errno, $errstr, $timeout);
        if (!$op) return 0; //DC is N/A
        else {
                 fclose($opanak); //explicitly close open socket connection
                 return 1; //DC is up & running, we can safely connect with ldap_connect
        }
}

function ldap_auth($usr, $pass)
{
        /*
         *---------------------------------------------------------------
         * Check if ldap extension exists
         *---------------------------------------------------------------
         *
         */
         if (version_compare(phpversion(), "4", ">"))
         {
                 if (!extension_loaded('ldap'))
                 {
                         die ( "ERR: LDAP extension not loaded!" );
                         exit;
                 }
                 if (!function_exists("ldap_connect"))
                 {
                         die ("ERR: LDAP extension not installed.");
                         exit;
                 }

         } else {
                 die ( "ERR: php version not supported!");
                 exit;
         }

        /*
         *---------------------------------------------------------------
         * Check if global vars are set. If not, reset them to defaults
         *---------------------------------------------------------------
         *
         */
        if (array_key_exists('script_name',$GLOBALS))
        {
                global $script_name;
        } else {
                $script_name = pathinfo($_SERVER['PHP_SELF'], PATHINFO_FILENAME);
        }

        if (array_key_exists('remote_addr',$GLOBALS))
        {
                global $remote_addr;
        } else {
                $remote_addr = $_SERVER['REMOTE_ADDR'];
        }

        if (array_key_exists('time',$GLOBALS))
        {
                global $time;
        } else {
                $time        = @date('[d/M/Y:H:i:s]');
        }

        if (array_key_exists('log_file',$GLOBALS))
        {
                global $log_file;
        } else {
                $log_file    = "/var/log/ldap.log";
        }

        if (array_key_exists('ldap',$GLOBALS))
        {
                global $ldap;
        } else {
                /*
                 *
                 *--------------------------------------------
                 * LDAP settings
                 *--------------------------------------------
                 *
                 */
                 $ldap['base']         = "ou=users,o=Domain,dc=domain,dc=com";
                 $ldap['attribute']    = "description";
                 $ldap['filter']       = "(&(objectClass=posixAccount)(uid={login}))";
                 $ldap['group_allow']  = "support|abuse";
                 $ldap['usr_min_len']  = 3;
                 $ldap['usr_max_len']  = 50;
                 $ldap['pass_min_len'] = 6;

                 $ldap['servers'] = array (
                         'umsrv1s.sec.domain.com',
                         'umsrv2s.sec.domain.com',
                         'umsrv3s.sec.domain.com',
                 );


        }

        /*
         *---------------------------------------------------------------
         * Check if log file exists and is regular file
         *---------------------------------------------------------------
         *
         */
         if ( ( ! file_exists ( $log_file )) || ( ! is_file ( $log_file )) )
         {
                 $error = "log file $log_file does not exist OR is not regular file";
                 /* obviously we cannot use error_log as that needs access to exist */
                 die("[ERR ($error)]\n");
                 return FALSE;
         }

        /*
         *---------------------------------------------------------------
         * Check if log file is writable
         *---------------------------------------------------------------
         *
         */
         if ( ! is_writable($log_file))
         {
                 $error = "log file $log_file is NOT writable! ";
                 /* obviously we cannot use error_log as that needs access to write to the file */
                 die("[ERR ($error)]\n");
                 return FALSE;
         }

        /*
         *---------------------------------------------------------------
         * Sanitize username
         *---------------------------------------------------------------
         *
         */
        $usr  = filter_var($usr, FILTER_SANITIZE_STRING);
        $usr  = filter_var($usr, FILTER_SANITIZE_SPECIAL_CHARS, FILTER_FLAG_STRIP_HIGH);

        /*
         *---------------------------------------------------------------
         * Sanitize password
         *---------------------------------------------------------------
         *
         */
        $pass = stripslashes($pass);

        $pass = filter_var($pass, FILTER_SANITIZE_STRING);
        //$pass = filter_var($pass, FILTER_SANITIZE_SPECIAL_CHARS, FILTER_FLAG_STRIP_HIGH);

        /*
         *---------------------------------------------------------------
         * Check username format
         *---------------------------------------------------------------
         *
         */
         if (!preg_match('/^[a-z]+$/',$usr)) {
                 $error = "Your username must be in a-z format";
                 error_log("$time [$script_name] [$remote_addr] [ERR ($error)]\n", 3, $log_file);
                 return FALSE;
         }

        /*
         *---------------------------------------------------------------
         * Check user & password length
         *---------------------------------------------------------------
         *
         */
         if ( ( strlen( trim($usr) ) <= $ldap['usr_min_len']) || (strlen( trim($usr)) ) > $ldap['usr_max_len'] )
         {
                 $error = "Your username must be between ". $ldap['usr_min_len'] . " and " . $ldap['usr_max_len'] . "chars long";
                 error_log("$time [$script_name] [$remote_addr] [ERR ($error)]\n", 3, $log_file);
                 return FALSE;
         }

         if ( strlen ( trim($pass) ) < $ldap['pass_min_len'] ) {
                 $error = "Your password length is < " . $ldap['pass_min_len'] . " characters long. ";
                 error_log("$time [$script_name] [$remote_addr] [ERR ($error)]\n", 3, $log_file);
                 return FALSE;
         }


        /*
         *---------------------------------------------------------------
         * Set ldaprdn in proper ldap format. We should be using sprintf
         *---------------------------------------------------------------
         *
         */
         $ldaprdn  = "uid=" . $usr  . "," . $ldap['base'];
         error_log("$time [$script_name] [$remote_addr] [INFO (ldaprdn = $ldaprdn)]\n", 3, $log_file);

        /*
         *---------------------------------------------------------------
         * Do not verify remote cert
         *---------------------------------------------------------------
         *
         */
         putenv('LDAPTLS_REQCERT=never');

        /*
         *---------------------------------------------------------------
         * Get random server name from ldap VIPs
         *---------------------------------------------------------------
         *
         */
         $ldap_url = "ldaps://" . $ldap['servers'][rand(0, count($ldap['servers']) - 1)];

        /*
         *---------------------------------------------------------------
         * Check if ldap connection can be established
         *---------------------------------------------------------------
         *
         */
         $ldapconn = ldap_connect($ldap_url);
         error_log("$time [$script_name] [$remote_addr] [INFO (ldapconnect = $ldap_url)]\n", 3, $log_file);

         if(!$ldapconn) {
                 $error = "Error: cannot connect to ldap server. ";
                 error_log("$time [$script_name] [$remote_addr] [ERROR ($error $ldap_url)]\n", 3, $log_file);
                 ldap_close ($ldapconn);
                 return FALSE;
         }

        /*
         *---------------------------------------------------------------
         * Set flags on ldap connection
         *---------------------------------------------------------------
         *
         */
         if ( ! ldap_set_option($ldapconn, LDAP_OPT_PROTOCOL_VERSION, 3) )
         {
                 $error = "Error: cannot set LDAP_OPT_PROTOCOL_VERSION to 3";
                 error_log("$time [$script_name] [$remote_addr] [ERROR ($error $ldap_url)]\n", 3, $log_file);
                 ldap_close ($ldapconn);
                 return FALSE;
         }

         if ( ! ldap_set_option($ldapconn, LDAP_OPT_REFERRALS, 0) )
         {
                 $error = "Error: cannot set LDAP_OPT_REFERRALS to 0";
                 error_log("$time [$script_name] [$remote_addr] [ERROR ($error $ldap_url)]\n", 3, $log_file);
                 ldap_close ($ldapconn);
                 return FALSE;
         }

         // ldap_set_option(NULL, LDAP_OPT_DEBUG_LEVEL, 7);

        /*
         *---------------------------------------------------------------
         * Bind to ldap with the user name and password
         *---------------------------------------------------------------
         *
         */
         if ($ldapconn) {
                 error_log("$time [$script_name] [$remote_addr] [INFO (ldapconn = $ldap_url)]\n", 3, $log_file);
                 // binding to ldap server
                 $ldapbind = @ldap_bind($ldapconn, $ldaprdn, $pass);

                 // verify binding
                 if (!$ldapbind) {
                         $error = "Wrong LDAP username or password";
                         error_log("$time [$script_name] [$remote_addr] [ERROR ($error - Cannot bind '$usr', '$ldaprdn' to $ldap_url)]\n", 3, $log_file);
                         ldap_close ($ldapconn);
                         return FALSE;
                 } else {
                         error_log("$time [$script_name] [$remote_addr] [SUCCESS (bind '$usr', '$ldaprdn' auth to $ldap_url)]\n", 3, $log_file);
                 }
        }


        /*
         *---------------------------------------------------------------
         * Find user in ldap tree
         *---------------------------------------------------------------
         *
         */
        $ldap['filter'] = str_replace("{login}", $usr, $ldap['filter']);
        $search = ldap_search($ldapconn, $ldap['base'], $ldap['filter']);
        $errno = ldap_errno($ldapconn);
        if ( $errno ) {
                $error = "LDAP - Search error";
                error_log("$time [$script_name] [$remote_addr] [ERROR (LDAP - Search error: $ldap_filter, $errno)]\n", 3, $log_file);
                @ldap_close ($ldapconn);
                return FALSE;
        }

        $entry = ldap_first_entry($ldapconn, $search);
        $userdn = ldap_get_dn($ldapconn, $entry);

        if( !$userdn ) {
                $error = "LDAP Search failed"; // It means user not found in ldap tree
                error_log("$time [$script_name] [$remote_addr] [ERROR (LDAP Search failed for $userdn)]\n", 3, $log_file);
                @ldap_close ($ldapconn);
                return FALSE;
        }

        /*
         *---------------------------------------------------------------
         * Find description attributes and check against allowed groups
         *---------------------------------------------------------------
         *
         */
        $Values = ldap_get_values($ldapconn, $entry, $ldap['attribute']);
        if ( $Values["count"] > 0 )
        {
                // find the number of groups
                $groupnum = $Values["count"];

                //loop through the groups and print them in the logfile. Match the allowed group as well
                for ($i=0; $i<$groupnum; $i++) {
                        $mail = $Values[$i];
                        //error_log("$time [$script_name] [dosportal] [$remote_addr] [SUCCESS (Found description group: $mail ($i))]\n", 3, $log_file);

                        $groups = $ldap['group_allow'];
                        //if the user IS part of allowed groups, allow access by setting a var = 1
                        if (preg_match("/$groups/i",$mail)) {
                                //$in_security_group = "1";
                                error_log("$time [$script_name] [$remote_addr] [SUCCESS (user $usr FOUND in GROUP $groups)]\n", 3, $log_file);
                                @ldap_close ($ldapconn);
                                return TRUE;
                        }
                }

        } else {
                $error = "Missing information";
                error_log("$time [$script_name] [$remote_addr] [ERROR (Missing information for $usr - no description field found in LDAP tree)]\n", 3, $log_file);
                @ldap_close ($ldapconn);
                return FALSE;
        }

        /*
         *---------------------------------------------------------------
         * Close connection to ldap server
         *---------------------------------------------------------------
         *
         */
        if ( ! is_null ( $ldapconn ) )
        {
                @ldap_close ( $ldapconn );
        }

        return FALSE;

}

?>


