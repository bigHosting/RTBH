<?php

/**
* The MIT License
* http://creativecommons.org/licenses/MIT/
*
* ArrestDB 1.9.0 (github.com/alixaxel/ArrestDB/)
* Copyright (c) 2014 Alix Axel <alix.axel@gmail.com>
**/

/* Added by Security Guy from GSB-ApplicationWinPhone/API github project */
// mysql> GRANT USAGE ON *.* TO 'apiv1'@'nvd.sec.domain.com' IDENTIFIED BY '4m.5J~L4';
// mysql> GRANT SELECT, INSERT, UPDATE, DELETE ON `RTBH`.`temp_whitelist` TO 'apiv1'@'nvd.sec.domain.com';
// mysql> GRANT SELECT, INSERT, UPDATE, DELETE ON `RTBH`.`blacklist` TO 'apiv1'@'nvd.sec.domain.com';
// mysql> flush privileges;

/* helper functions to maintain cipher-algorythm and cookie compatibility
  * regardless of contents.
  * US-ASCII charset is used for encoding/decoding.
  *
  * The Base64 functions (below) were copied from the php manual
  * All credit for these go to: Massimo Scamarcia (massimo dot scamarcia at gmail dot com)
  * Page: http://us2.php.net/manual/en/function.base64-encode.php#63543
  */
function urlsafe_b64encode($string) {
        $data = base64_encode($string);
        $data = str_replace(array('+','/','='),array('-','_','.'),$data);
        return $data;
}

function urlsafe_b64decode($string) {
        $data = str_replace(array('-','_','.'),array('+','/','='),$string);
        $mod4 = strlen($data) % 4;
        if($mod4) $data .= substr('====', $mod4);
        return base64_decode($data);
}

/*
 * simple method to encrypt or decrypt a plain text string
 * initialization vector(IV) has to be the same when encrypting and decrypting
 * PHP 5.4.9
 *
 * this is a beginners template for simple encryption decryption
 * before using this in production environments, please read about encryption
 *
 * @param string $action: can be 'encrypt' or 'decrypt'
 * @param string $string: string to encrypt or decrypt
 *
 * @return string
 */
function encrypt_decrypt($action, $string) {

        if ( !function_exists("openssl_encrypt") )
        {
                die ("openssl function openssl_encrypt does not exist");
        }
        if ( !function_exists("hash") )
        {
                die ("function hash does not exist");
        }

        global $encryption_key;

        $output = false;
        $encrypt_method = "AES-256-CBC";
        //echo "$encryption_key\n";
        $secret_iv = 'RgX54.Ju7h';


        // hash
        $key = hash('sha256', $encryption_key);

        // iv - encrypt method AES-256-CBC expects 16 bytes - else you will get a warning
        $iv = substr(hash('sha256', $secret_iv), 0, 16);

        if( $action == 'encrypt' )
        {
                $output = openssl_encrypt($string, $encrypt_method, $key, 0, $iv);
                $output = base64_encode($output);
        } else if( $action == 'decrypt' )
        {
                $output = openssl_decrypt(base64_decode($string), $encrypt_method, $key, 0, $iv);
        }

        return $output;
}

function check_token($mytoken)
{
        $timeout = 60;
        $decr_b64 = urlsafe_b64decode ($mytoken);
        $decrypted = encrypt_decrypt ( 'decrypt', $decr_b64 );
        $fields = explode(":", $decrypted);

        if (count($fields) == 2)
        {
                list ($ip, $timestamp) = explode(":", $decrypted);
                $nowtime = time();

                //echo "$ip, $timestamp, $timeout\n";
                $sum = (int) ($timestamp + $timeout);
                if ( ( $nowtime > $sum ) || ( $nowtime < $timestamp ) )
                {
                        return false;
                } else {
                        return true;
                }
        } else
        {
                return false;
        }
        return false;
}

?>