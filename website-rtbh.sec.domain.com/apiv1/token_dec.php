<?php

require_once 'f-encryption.php';
$client_encryption_keys = array(
        '127.0.0.1'       => 'Qs/7S$N%C8',
);
$remote_ip = '206.225.90.76';
$encryption_key = $client_encryption_keys[$remote_ip];

$timeout = 60;

echo "Decrypting: $argv[1]\n\n";
$decr_b64 = urlsafe_b64decode ($argv[1]);
$decrypted = encrypt_decrypt ( 'decrypt', $decr_b64 );

$fields = explode(":", $decrypted);

if (count($fields) == 2)
{

        // sleep (3);
        list ($ip, $timestamp) = explode(":", $decrypted);
        $nowtime = time();

        //echo "$ip, $timestamp, $timeout\n";
        $sum = (int) ($timestamp + $timeout);

        if ( ( $nowtime > $sum ) || ( $nowtime < $timestamp ) )
        {
            echo "Expired key\n";
        }

        echo "IP:$ip,TIMESTAMP:$timestamp\n";

}

check_token ( $argv[1] );

?>
