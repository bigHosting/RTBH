<?php

/* (c) SecurityGuy 2015.07.10 */

require_once 'f-session.php';

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

require_once 'f-settings.php';
require_once 'c-pdo.php';

?>
<body>
    <div id="page">
        <div id="section_left">
            <a class="img"><img src="common/logo.jpg" alt="logo" border="0" height="100px" weigh="64px" /></a><br><br>

            <div id='cssmenu'>
              <ul>
                <li><a  class='active'href='whitelist.php'><span>whitelist perm</span></a></li>
                <li><a href='temp-whitelist.php'><span>whitelist temp</span></a></li>
                <li><a href='blacklist.php'><span> blacklist</span></a></li>
                <li><a href='search-blacklist.php'><span>blacklist search</span></a></li>
                <li><a href='search-history.php'><span>blacklist search history</span></a></li>
                <li><a href='add.php'><span>ADD IP BLOCK</span></a></li>
                <li><a href='logout.php'><span>Logout</span></a></li>
              </ul>
            </div><!-- END #section cssmenu--><br>

            <div class="copy">&copy; Security Team <?php echo date("Y"); ?></div>
        </div><!-- END #section_left-->

        <div id="section_center">
            <!-- <p class="time_log"><?php echo $time_log; ?></p> -->
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!--BEGIN: login info -->
            <tbody><tr>
               <td align="right">
                 <table border="0" cellpadding="2" cellspacing="0">
                    <tbody><tr>
                        <td class="login" align="right">Logged in as: </td>
                        <td class="login" align="left">&nbsp;&nbsp;<u><?php echo $_SESSION['USER'] ?></u> &nbsp;</td>
                        <td class="login" align="right"><a href="logout.php">Logout</a></td>
                           </tr>
                    </tbody>
                 </table>
              </td></tr>
            </tbody></table>

