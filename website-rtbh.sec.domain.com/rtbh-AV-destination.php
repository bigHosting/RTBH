<?php

// (c) George Bolo
// (c) Security Guy


define ('DIRECT_ACCESS', 1);
if (!defined('DIRECT_ACCESS')) {
   // if our flag is not defined,
   // user is accessing our file directly
   die('ERR: access denied');
   exit;
}

include 'f-ip.php';



$MIN_HITS    = 1;
$TIME_PERIOD = 3600;

$output = "# TOP IP SCRIPT VARIABLES: \n";


function getGraylogMessages($range){

        $graylog_sec = 'A.B.90.71';
        $graylog_api_user = 'logplayback';
        $graylog_api_pass = 'GRAYLO2_API_PASSWORD';

        //$query = 'http_method:'.$method.' AND http_request_path:\/*'.$filename;
        $query = 'hService:AlienVault AND _exists_:AttackType AND Reliability:4 AND AttackType:"Brute Force Attack Destination"';
        $e_query = urlencode($query);

        $url = 'http://'.$graylog_sec.':12900/search/universal/relative/terms?field=DestinationIP&query='.$e_query . '&range='.$range;
        echo "# " . $url . "\n";
        $curl = curl_init();

        $opt = array(
                CURLOPT_URL=>$url,
                CURLOPT_USERAGENT => "Mozilla",
                CURLOPT_CUSTOMREQUEST =>"GET",
                CURLOPT_RETURNTRANSFER=>true,
                CURLOPT_FOLLOWLOCATION=>false,
                CURLOPT_CONNECTTIMEOUT=>10,
                CURLOPT_USERPWD=>"$graylog_api_user:$graylog_api_pass",
                CURLOPT_HTTPAUTH,
                CURLAUTH_ANY,
        );
        curl_setopt_array($curl, $opt);
        $output = curl_exec($curl);
        $http_status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
        curl_close($curl);

        return $output;

}



$gl_json = json_decode(getGraylogMessages($TIME_PERIOD), true);


$list = $gl_json['terms'];
arsort($list);

$output .= "\n";
foreach ($list as $ip => $hits) {
        if ( valid_ipv4_host ( $ip ) )
        {
                if ($hits > $MIN_HITS){
                        $output .= "$hits $ip\n";
                }
        }

        if ( valid_ipv6_host ( $ip ) )
        {
                $ip = compress ($ip);
                if ($hits > $MIN_HITS){
                        $output .= "$hits $ip\n";
                }
        }

}

if (php_sapi_name() == "cli") {
        echo $output;
} else {
        echo "<pre>$output<pre>";
}



?>

