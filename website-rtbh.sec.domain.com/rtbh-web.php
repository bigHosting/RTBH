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


$MIN_HITS    = 5000;
$TIME_PERIOD = 3600;

$METHOD = "POST";
$FILENAME = "wp-login.php";

$output = "# TOP IP SCRIPT VARIABLES: \n";

if ( isset($_GET['hits']) && is_numeric($_GET['hits']) && ($_GET['hits'] > $MIN_HITS ) )
{
    $MIN_HITS = $_GET['hits'];
    $output .= "# using custom value for hits: minimum $MIN_HITS hits per IP \n";
} else {
    $output .= "# using default value for hits: minimum $MIN_HITS hits per IP (100-5000 allowed range)\n";
}

if ( isset($_GET['time']) && is_numeric($_GET['time']) && ($_GET['time'] > 300 ) && ($_GET['time'] < 86400) )
{
    $TIME_PERIOD = $_GET['time'];
    $output .= "# using custom value for time: last $TIME_PERIOD seconds \n";
} else {
    $output .= "# using default value for time: last $TIME_PERIOD seconds (300-3600 allowed range)\n";
}

if ( isset($_GET['method']) && !is_numeric($_GET['method']) && (strtoupper($_GET['method']) === 'GET' || strtoupper($_GET['method']) === 'POST') )
{
    $METHOD = strtoupper($_GET['method']);
    $output .= "# using custom value for method: $METHOD \n";
} else {
    $output .= "# using default value for method: $METHOD (possible values: get,post) \n";
}

if ( isset($_GET['filename']) && !is_numeric($_GET['filename']) )
{
    $FILENAME = $_GET['filename'];
    $output .= "# using custom value for filename: $FILENAME \n";
} else {
    $output .= "# using default value for filename: $FILENAME \n";
}

function getGraylogMessages($range,$method,$filename){

        $graylog_sec = 'X.Y.55.216';
        $graylog_api_user = 'logplayback';
        $graylog_api_pass = 'GRAYLOG2_API_PASSWORD_HERE';

        $query = 'http_method:'.$method.' AND http_request_path:\/*'.$filename;
        $e_query = urlencode($query);

        $url = 'http://'.$graylog_sec.':12900/search/universal/relative/terms?field=source_ip&query='.$e_query.'&range='.$range;
        echo "# " . $url;
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



$gl_json = json_decode(getGraylogMessages($TIME_PERIOD,$METHOD,$FILENAME), true);


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

