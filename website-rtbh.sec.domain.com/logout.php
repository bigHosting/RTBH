<?php
session_set_cookie_params('1'); // 1 sec
session_start();
session_unset();
session_destroy();
$_SESSION = array();
header("Location: index.php");
?>
