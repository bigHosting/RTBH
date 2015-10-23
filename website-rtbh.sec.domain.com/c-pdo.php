<?php

/* (c) SecurityGuy 2015.07.10 */

//define ('DIRECT_ACCESS', 1);

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


if(!defined('DB_HOST'))     define('DB_HOST', 'freya.sec.domain.com');
if(!defined('DB_NAME'))     define('DB_NAME', 'RTBH');
if(!defined('DB_USERNAME')) define('DB_USERNAME', 'dosportal');
if(!defined('DB_PASSWORD')) define('DB_PASSWORD', 'MYSQL_PASSWORD_HERE'); // MYSQL PASSWORD !!!

class dbHelper {

        private $db;
        private $err;

        function __construct() {
                $dsn = 'mysql:host='.DB_HOST.';dbname='.DB_NAME.';charset=utf8';
                try
                {
                        $this->db = new PDO($dsn, DB_USERNAME, DB_PASSWORD, array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
                } catch (PDOException $e) {
                        $response["status"] = "error";
                        $response["message"] = 'Connection failed: ' . $e->getMessage();
                        $response["data"] = null;
                        exit;
                }
        }

        function select($table, $where){
                try
                {
                        $a = array();
                        $w = "";
                        foreach ($where as $key => $value) {
                                $w .= " and " .$key. " like :".$key;
                                $a[":".$key] = $value;
                        }

                        $stmt = $this->db->prepare("select * from ".$table." where 1=1 ". $w);
                        $stmt->execute($a);
                        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

                        if(count($rows)<=0)
                        {
                                $response["status"] = "warning";
                                $response["message"] = "No data found.";
                        }else{
                                $response["status"] = "success";
                                $response["message"] = "Data selected from database";
                        }
                        $response["data"] = $rows;

                }catch(PDOException $e){
                        $response["status"] = "error";
                        $response["message"] = 'Select Failed: ' .$e->getMessage();
                        $response["data"] = null;
                }

                return $response;
    }

    function select_whitelist($table, $where){
        try{
            $a = array();
            $w = "";
            foreach ($where as $key => $value) {
                $w .= " and " .$key. " like :".$key;
                $a[":".$key] = $value;
            }
            $stmt = $this->db->prepare("select CONCAT(inet6_ntop(sourceip),'/',cidr) AS network from ".$table." where 1=1 ". $w);
            $stmt->execute($a);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if(count($rows)<=0){
                $response["status"] = "warning";
                $response["message"] = "No data found.";
            }else{
                $response["status"] = "success";
                $response["message"] = "Data selected from database";
            }
                $response["data"] = $rows;
        }catch(PDOException $e){
            $response["status"] = "error";
            $response["message"] = 'Select_whitelist Failed: ' .$e->getMessage();
            $response["data"] = null;
        }
        return $response;
    }

    function select6($table, $where){
        try{
            $a = array();
            $w = "";
            foreach ($where as $key => $value) {
                $w .= " and " .$key. " like :".$key;
                $a[":".$key] = $value;
            }
            $stmt = $this->db->prepare("select id, inet6_ntop(sourceip) as ip, cidr, type, inserttime, expiretime, hits, country, comment, insertby, allow_edit FROM ".$table." where 1=1 ". $w);
            $stmt->execute($a);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if(count($rows)<=0){
                $response["status"] = "warning";
                $response["message"] = "No data found.";
            }else{
                $response["status"] = "success";
                $response["message"] = "Data selected from database";
            }
                $response["data"] = $rows;
        }catch(PDOException $e){
            $response["status"] = "error";
            $response["message"] = 'Select6 Failed: ' .$e->getMessage();
            $response["data"] = null;
        }
        return $response;
    }

        function rawSelect($sql, $params = null) {

                $response = array();
                $response["status"] = "error";
                $response["message"] = "Unknown error";
                $response["data"] = null;

                try{
                        $stmt = $this->db->prepare($sql);
                        $stmt->execute($params);
                        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

                        if(count($rows)<=0){
                                $response["status"] = "warning";
                                $response["message"] = "No data found.";
                        }
                        else{
                                $response["status"] = "success";
                                $response["message"] = "Data selected from database";
                        }

                        $response["data"] = $rows;
                }
                catch(PDOException $e){
                        $response["status"] = "error";
                        $response["message"] = "RawSelect Failed: " .$e->getMessage();
                        $response["data"] = null;
                }
                return $response;
        }

    function select_where($table, $columns, $where, $order){
        try{
            $a = array();
            $w = "";
            if($where!=null) {
                foreach ($where as $key => $value) {
                    $w .= " and " .$key. " like :".$key;
                    $a[":".$key] = $value;
                }
            }
            $stmt = $this->db->prepare("select ".$columns." from ".$table." where 1=1 ". $w." ".$order);
            $stmt->execute($a);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if(count($rows)<=0){
                $response["status"] = "warning";
                $response["message"] = "No data found.";
            }else{
                $response["status"] = "success";
                $response["message"] = "Data selected from database";
            }
                $response["data"] = $rows;
        }catch(PDOException $e){
            $response["status"] = "error";
            $response["message"] = 'Select Failed: ' .$e->getMessage();
            $response["data"] = null;
        }
        return $response;
    }



    function insert($table, $columnsArray, $requiredColumnsArray) {
        $this->verifyRequiredParams($columnsArray, $requiredColumnsArray);

        try{
            $a = array();
            $c = "";
            $v = "";
            foreach ($columnsArray as $key => $value) {
                $c .= $key. ", ";
                $v .= ":".$key. ", ";
                $a[":".$key] = $value;
            }
            $c = rtrim($c,', ');
            $v = rtrim($v,', ');
            $stmt =  $this->db->prepare("INSERT INTO $table($c) VALUES($v)");
            $stmt->execute($a);
            $affected_rows = $stmt->rowCount();
            $response["status"] = "success";
            $response["message"] = $affected_rows." row inserted into database";
        }catch(PDOException $e){
            $response["status"] = "error";
            $response["message"] = 'Insert Failed: ' .$e->getMessage();
        }
        return $response;
    }

        /*  $rows = $db->rawInsert("insert into blacklist (sourceip, cidr, type, inserttime,expiretime,hits,country,comment,insertby,allow_edit) VALUES (inet6_pton('2600:3c03::f03c:91ff:feae:3aea'),'128','ipv6', NOW(), '9999-12-31 23:59:59',1000,'US','testing','testing','Y')");  */
        function rawInsert($sql, $params = null) {
                $response = array();
                $response["status"] = "error";
                $response["message"] = "Unknown error";
                $response["data"] = null;

                try{
                        $stmt =  $this->db->prepare($sql);
                        $stmt->execute($params);
                        $affected_rows = $stmt->rowCount();
                        $response["data"] = $this->db->lastInsertId();
                        $response["status"] = "success";
                        $response["message"] = $affected_rows." row inserted into database";
                }
                catch(PDOException $e){
                        $response["status"] = "error";
                        $response["message"] = "RawInsert Failed: " .$e->getMessage();
                }
                return $response;
        }

    function update($table, $columnsArray, $where, $requiredColumnsArray){ 
        $this->verifyRequiredParams($columnsArray, $requiredColumnsArray);
        try{
            $a = array();
            $w = "";
            $c = "";
            foreach ($where as $key => $value) {
                $w .= " and " .$key. " = :".$key;
                $a[":".$key] = $value;
            }
            foreach ($columnsArray as $key => $value) {
                $c .= $key. " = :".$key.", ";
                $a[":".$key] = $value;
            }
                $c = rtrim($c,", ");

            $stmt =  $this->db->prepare("UPDATE $table SET $c WHERE 1=1 ".$w);
            $stmt->execute($a);
            $affected_rows = $stmt->rowCount();
            if($affected_rows<=0){
                $response["status"] = "warning";
                $response["message"] = "No row updated";
            }else{
                $response["status"] = "success";
                $response["message"] = $affected_rows." row(s) updated in database";
            }
        }catch(PDOException $e){
            $response["status"] = "error";
            $response["message"] = "Update Failed: " .$e->getMessage();
        }
        return $response;
    }

        function rawUpdate($sql, $params = null){

                        $response = array();
                        $response["status"] = "error";
                        $response["message"] = "Unknown error";
                        $response["data"] = null;

                        try{
                                $stmt = $this->db->prepare($sql);
                                $stmt->execute($params);
                                $affected_rows = $stmt->rowCount();

                                if($affected_rows<=0){
                                        $response["status"] = "warning";
                                        $response["message"] = "No row updated";
                                }
                                else{
                                        $response["status"] = "success";
                                        $response["message"] = $affected_rows." row(s) updated in database";
                                }

                                $response["data"] = $affected_rows;
                        }
                        catch(PDOException $e){
                                $response["status"] = "error";
                                $response["message"] = "RawUpdate Failed: " .$e->getMessage();
                        }

                        return $response;
                }


    function delete($table, $where){
        if(count($where)<=0){
            $response["status"] = "warning";
            $response["message"] = "Delete Failed: At least one condition is required";
        }else{
            try{
                $a = array();
                $w = "";
                foreach ($where as $key => $value) {
                    $w .= " and " .$key. " = :".$key;
                    $a[":".$key] = $value;
                }
                $stmt =  $this->db->prepare("DELETE FROM $table WHERE 1=1 ".$w." LIMIT 1");
                $stmt->execute($a);
                $affected_rows = $stmt->rowCount();
                if($affected_rows<=0){
                    $response["status"] = "warning";
                    $response["message"] = "No row deleted";
                }else{
                    $response["status"] = "success";
                    $response["message"] = $affected_rows." row(s) deleted from database";
                }
            }catch(PDOException $e){
                $response["status"] = "error";
                $response["message"] = 'Delete Failed: ' .$e->getMessage();
            }
        }
        return $response;
    }

        function rawDelete($sql, $params = null){

                        $response = array();
                        $response["status"] = "error";
                        $response["message"] = "Unknown error";
                        $response["data"] = null;

                        try{

                                $stmt =  $this->db->prepare($sql);
                                $stmt->execute($params);
                                $affected_rows = $stmt->rowCount();

                                if($affected_rows<=0){
                                        $response["status"] = "warning";
                                        $response["message"] = "No row deleted";
                                }
                                else{
                                        $response["status"] = "success";
                                        $response["message"] = $affected_rows." row(s) deleted from database";
                                }

                                $response["data"] = $affected_rows;
                        }
                        catch(PDOException $e){
                                $response["status"] = "error";
                                $response["message"] = "RawDelete Failed: " .$e->getMessage();
                        }

                        return $response;
                }


    function verifyRequiredParams($inArray, $requiredColumns) {
        $error = false;
        $errorColumns = "";
        foreach ($requiredColumns as $field) {
            if (!isset($inArray[$field]) || strlen(trim($inArray[$field])) <= 0) {
                $error = true;
                $errorColumns .= $field . ', ';
            }
        }

        if ($error) {
            $response = array();
            $response["status"] = "error";
            $response["message"] = 'Required field(s) ' . rtrim($errorColumns, ', ') . ' is missing or empty';
            print_r($response);
            exit;
        }
    }

/* other functions */

        function toJson ($response) {
                return json_encode($response,JSON_NUMERIC_CHECK);
        }



}

?>
