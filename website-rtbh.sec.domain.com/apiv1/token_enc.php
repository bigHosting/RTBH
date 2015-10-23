<?php

require_once 'f-encryption.php';

$client_encryption_keys = array(
        '127.0.0.1'       => 'Qs/7S$N%C8',
);
$remote_ip = '127.0.0.1';
$encryption_key = $client_encryption_keys[$remote_ip];

$timeout = 60;
$string = "127.0.0.1" . ":" . time();

$encr = encrypt_decrypt ( 'encrypt', $string ) ;
//echo $encr . "\n";

$encr_b64 = urlsafe_b64encode ($encr );
echo "token: $encr_b64 valid for $timeout sec\n";
echo "curl 'https://rtbh.sec.domain.com/apiv1/temp_whitelist/sourceip/108.59.253.198?auth_key=$encr_b64'\n\n";
echo "php token_dec.php $encr_b64\n\n";

if ( check_token ($encr_b64) )
{
        echo "check_token: true !\n";
} else {
        echo "check_token: INVALID\n";
}

?>
