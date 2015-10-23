<?php
/* (c) SecurityGuy 2015.07.10 */

/*
 *
 * Deny access if direct access is requested
 *
 */
if (!defined('DIRECT_ACCESS')) {
   // if our flag is not defined,
   // user is accessing our file directly
   die('ERR: access denied');
   exit;
}

?>

        <div class="clear"></div>
    </div><!-- END #page-->
    <br>

</body>
</html>
