<?php

/**
* The MIT License
* http://creativecommons.org/licenses/MIT/
*
* ArrestDB 1.9.0 (github.com/alixaxel/ArrestDB/)
* Copyright (c) 2014 Alix Axel <alix.axel@gmail.com>
**/

/* Added by Security Guy from GSB-ApplicationWinPhone/API github project */
// mysql> GRANT USAGE ON *.* TO 'apiv1'@'nvd.sec.domain.com' IDENTIFIED BY '4m.5J~L4AJc';
// mysql> GRANT SELECT, INSERT, UPDATE, DELETE ON `RTBH`.`temp_whitelist` TO 'apiv1'@'nvd.sec.domain.com';
// mysql> GRANT SELECT, INSERT, UPDATE, DELETE ON `RTBH`.`blacklist` TO 'apiv1'@'nvd.sec.domain.com';
// mysql> flush privileges;

require_once 'f-encryption.php';



$dsn = 'mysql://apiv1:4m.5J~L4AJc@freya.sec.domain.com:3306/RTBH/';

// Added by Security Guy from CouchPDO-PDO githnub project
$logging  = TRUE;

/* Added by Security Guy from GSB-ApplicationWinPhone/API github project */
$auth_key = "d4349b94516a530a74ecba09662fb225382fbed89d0dd141858d6ffceb1fde76";

$client_encryption_keys = array(
        '206.225.90.76'   => 'Mg,5y%N~t4',
        '127.0.0.1'       => 'Qs/7S$N%C8',
);

//$clients = [];
$clients = array
(
        '127.0.0.1',
        '10.70.17.1',
        '10.70.17.2',
        '10.70.17.3',
        '10.70.17.4',
        '10.70.17.5',
        '10.70.17.6',
        '10.70.17.7'
);

/* Added by Security Guy from GSB-ApplicationWinPhone/API github project */
function get_client_ip()
{
        $ipaddress = '';
        if ($_SERVER['HTTP_CLIENT_IP']) $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
        else if ($_SERVER['HTTP_X_FORWARDED_FOR']) $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
        else if ($_SERVER['HTTP_X_FORWARDED']) $ipaddress = $_SERVER['HTTP_X_FORWARDED'];
        else if ($_SERVER['HTTP_FORWARDED_FOR']) $ipaddress = $_SERVER['HTTP_FORWARDED_FOR'];
        else if ($_SERVER['HTTP_FORWARDED']) $ipaddress = $_SERVER['HTTP_FORWARDED'];
        else if ($_SERVER['REMOTE_ADDR']) $ipaddress = $_SERVER['REMOTE_ADDR'];
        else $ipaddress = 'UNKNOWN';
        return $ipaddress;
}



if (strcmp(PHP_SAPI, 'cli') === 0)
{
        exit('ArrestDB should not be run from CLI.' . PHP_EOL);
}


if ( empty($_SERVER['REQUEST_METHOD']) !== true )
{
        $req_method    = strtolower ( $_SERVER['REQUEST_METHOD'] );
        switch ($req_method)
        {

            case 'get':
                break;
            case 'post':
                break;
            case 'put':
                break;
            case 'delete':
                break;
            default:
                exit(ArrestDB::Reply(ArrestDB::$HTTP[414]));
                break;
        }
}

if ( (empty($client_encryption_keys) !== true) && (! is_array ( $client_encryption_keys )) )
{
        exit(ArrestDB::Reply(ArrestDB::$HTTP[411]));
}

$remote_ip = get_client_ip();
if ( array_key_exists ( $remote_ip  , $client_encryption_keys ) ) {
} else {
        exit(ArrestDB::Reply(ArrestDB::$HTTP[412]));
}

$encryption_key = $client_encryption_keys[$remote_ip];

/*  do $_REQUEST as we need auth_key in GET and POST  */
if (empty($auth_key) !== true)
{
        if ( !isset($_REQUEST['auth_key'])) return false;

        $token = $_REQUEST['auth_key'];

        if ( strlen ( $token ) != 80 ) return false;
        if ( !preg_match("/[A-Za-z0-9]+/", $token)) return false;

        if (!check_token($token) )
        {
                exit(ArrestDB::Reply(ArrestDB::$HTTP[413]));
        }
}


if ((empty($clients) !== true) && ( in_array ( $remote_ip , (array) $clients) !== true ) )
{
        exit(ArrestDB::Reply(ArrestDB::$HTTP[403]));
}

else if (ArrestDB::Query($dsn) === false)
{
        exit(ArrestDB::Reply(ArrestDB::$HTTP[503]));
}

if (array_key_exists('_method', $_GET) === true)
{
        $_SERVER['REQUEST_METHOD'] = strtoupper(trim($_GET['_method']));
}

else if (array_key_exists('HTTP_X_HTTP_METHOD_OVERRIDE', $_SERVER) === true)
{
        $_SERVER['REQUEST_METHOD'] = strtoupper(trim($_SERVER['HTTP_X_HTTP_METHOD_OVERRIDE']));
}


ArrestDB::Serve('GET', '/(#any)/(#any)/(#any)', function ($table, $ip, $data)
{
//        if(verifyAuth())
//        {
                $query = array
                (
                        //sprintf('SELECT * FROM "%s"', $table),
                        sprintf('SELECT id, inet6_ntop(sourceip) as sourceip, cidr, type, inserttime, expiretime, hits, country, comment, insertby, allow_edit FROM "%s"', $table),
                        sprintf('WHERE inet6_ntop("%s") %s ?', $ip, (ctype_digit($data) === true) ? '=' : 'LIKE'),
                );

                if (isset($_GET['by']) === true)
                {
                        if (isset($_GET['order']) !== true)
                        {
                                $_GET['order'] = 'ASC';
                        }

                        $query[] = sprintf('ORDER BY "%s" %s', $_GET['by'], $_GET['order']);
                }

                if (isset($_GET['limit']) === true)
                {
                        $query[] = sprintf('LIMIT %u', $_GET['limit']);

                        if (isset($_GET['offset']) === true)
                        {
                                $query[] = sprintf('OFFSET %u', $_GET['offset']);
                        }
                }

                $query = sprintf('%s;', implode(' ', $query));
                $result = ArrestDB::Query($query, $data);

                if ($result === false)
                {
                        $result = ArrestDB::$HTTP[404];
                }
                else if (empty($result) === true)
                {
                        $result = ArrestDB::$HTTP[204];
                }

                return ArrestDB::Reply($result);

//        } else
//        {
//                $result = ArrestDB::$HTTP[410];
//                return ArrestDB::Reply($result);
//        }
});

ArrestDB::Serve('GET', '/(#any)/(#any)?', function ($table, $ip = null)
{
//        if(verifyAuth())
//        {
                $query = array
                (
                        // sprintf('SELECT * FROM "%s"', $table),
                        sprintf('SELECT id, inet6_ntop(sourceip) as sourceip, cidr, type, inserttime, expiretime, hits, country, comment, insertby, allow_edit FROM "%s"', $table),
                );

                if (isset($ip) === true)
                {
                        $query[] = sprintf('WHERE inet6_ntop("%s") = ? LIMIT 1', 'ip');
                }

                else
                {
                        if (isset($_GET['by']) === true)
                        {
                                if (isset($_GET['order']) !== true)
                                {
                                        $_GET['order'] = 'ASC';
                                }

                                $query[] = sprintf('ORDER BY "%s" %s', $_GET['by'], $_GET['order']);
                        }

                        if (isset($_GET['limit']) === true)
                        {
                                $query[] = sprintf('LIMIT %u', $_GET['limit']);

                                if (isset($_GET['offset']) === true)
                                {
                                        $query[] = sprintf('OFFSET %u', $_GET['offset']);
                                }
                        }
                 }

                $query = sprintf('%s;', implode(' ', $query));
                $result = (isset($ip) === true) ? ArrestDB::Query($query, $ip) : ArrestDB::Query($query);

                if ($result === false)
                {
                        $result = ArrestDB::$HTTP[404];
                }
                else if (empty($result) === true)
                {
                        $result = ArrestDB::$HTTP[204];
                }
                else if (isset($id) === true)
                {
                        $result = array_shift($result);
                }

                return ArrestDB::Reply($result);
//        } else
//        {
//                $result = ArrestDB::$HTTP[410];
//                return ArrestDB::Reply($result);
//        }
});

ArrestDB::Serve('DELETE', '/(#any)/(#num)', function ($table, $id)
{
	$query = array
	(
		sprintf('DELETE FROM "%s" WHERE "%s" = ?', $table, 'id'),
	);

	$query = sprintf('%s;', implode(' ', $query));
	$result = ArrestDB::Query($query, $id);

	if ($result === false)
	{
		$result = ArrestDB::$HTTP[404];
	}

	else if (empty($result) === true)
	{
		$result = ArrestDB::$HTTP[204];
	}

	else
	{
		$result = ArrestDB::$HTTP[200];
	}

	return ArrestDB::Reply($result);
});

if (in_array($http = strtoupper($_SERVER['REQUEST_METHOD']), ['POST', 'PUT']) === true)
{
	if (preg_match('~^\x78[\x01\x5E\x9C\xDA]~', $data = file_get_contents('php://input')) > 0)
	{
		$data = gzuncompress($data);
	}

	if ((array_key_exists('CONTENT_TYPE', $_SERVER) === true) && (empty($data) !== true))
	{
		if (strncasecmp($_SERVER['CONTENT_TYPE'], 'application/json', 16) === 0)
		{
			$GLOBALS['_' . $http] = json_decode($data, true);
		}

		else if ((strncasecmp($_SERVER['CONTENT_TYPE'], 'application/x-www-form-urlencoded', 33) === 0) && (strncasecmp($_SERVER['REQUEST_METHOD'], 'PUT', 3) === 0))
		{
			parse_str($data, $GLOBALS['_' . $http]);
		}
	}

	if ((isset($GLOBALS['_' . $http]) !== true) || (is_array($GLOBALS['_' . $http]) !== true))
	{
		$GLOBALS['_' . $http] = [];
	}

	unset($data);
}

ArrestDB::Serve('POST', '/(#any)', function ($table)
{
	if (empty($_POST) === true)
	{
		$result = ArrestDB::$HTTP[204];
	}

	else if (is_array($_POST) === true)
	{
		$queries = [];

		if (count($_POST) == count($_POST, COUNT_RECURSIVE))
		{
			$_POST = [$_POST];
		}

		foreach ($_POST as $row)
		{
			$data = [];

			foreach ($row as $key => $value)
			{
				$data[sprintf('"%s"', $key)] = $value;
			}

			$query = array
			(
				sprintf('INSERT INTO "%s" (%s) VALUES (%s)', $table, implode(', ', array_keys($data)), implode(', ', array_fill(0, count($data), '?'))),
			);

			$queries[] = array
			(
				sprintf('%s;', implode(' ', $query)),
				$data,
			);
		}

		if (count($queries) > 1)
		{
			ArrestDB::Query()->beginTransaction();

			while (is_null($query = array_shift($queries)) !== true)
			{
				if (($result = ArrestDB::Query($query[0], $query[1])) === false)
				{
					ArrestDB::Query()->rollBack(); break;
				}
			}

			if (($result !== false) && (ArrestDB::Query()->inTransaction() === true))
			{
				$result = ArrestDB::Query()->commit();
			}
		}

		else if (is_null($query = array_shift($queries)) !== true)
		{
			$result = ArrestDB::Query($query[0], $query[1]);
		}

		if ($result === false)
		{
			$result = ArrestDB::$HTTP[409];
		}

		else
		{
			$result = ArrestDB::$HTTP[201];
		}
	}

	return ArrestDB::Reply($result);
});

/*  we don't need to have update enabled, commenting out this block
ArrestDB::Serve('PUT', '/(#any)/(#num)', function ($table, $id)
{
	if (empty($GLOBALS['_PUT']) === true)
	{
		$result = ArrestDB::$HTTP[204];
	}

	else if (is_array($GLOBALS['_PUT']) === true)
	{
		$data = [];

		foreach ($GLOBALS['_PUT'] as $key => $value)
		{
			$data[$key] = sprintf('"%s" = ?', $key);
		}

		$query = array
		(
			sprintf('UPDATE "%s" SET %s WHERE "%s" = ?', $table, implode(', ', $data), 'id'),
		);

		$query = sprintf('%s;', implode(' ', $query));
		$result = ArrestDB::Query($query, $GLOBALS['_PUT'], $id);

		if ($result === false)
		{
			$result = ArrestDB::$HTTP[409];
		}

		else
		{
			$result = ArrestDB::$HTTP[200];
		}
	}

	return ArrestDB::Reply($result);
}); */

exit(ArrestDB::Reply(ArrestDB::$HTTP[400]));

class ArrestDB
{
	public static $HTTP = [
		200 => [
			'success' => [
				'code' => 200,
				'status' => 'OK',
			],
		],
		201 => [
			'success' => [
				'code' => 201,
				'status' => 'Created',
			],
		],
		204 => [
			'error' => [
				'code' => 204,
				'status' => 'No Content',
			],
		],
		400 => [
			'error' => [
				'code' => 400,
				'status' => 'Bad Request',
			],
		],
		403 => [
			'error' => [
				'code' => 403,
				'status' => 'Forbidden',
			],
		],
		404 => [
			'error' => [
				'code' => 404,
				'status' => 'Not Found',
			],
		],
		409 => [
			'error' => [
				'code' => 409,
				'status' => 'Conflict',
			],
		],
		410 => [
			'error' => [
				'code' => 403,
				'status' => 'Invalid Token',
			],
		],
                411 => [
                        'error' => [
                                'code' => 403,
                                'status' => 'Encryption keys not set up',
                       ],
                ],
                412 => [
                        'error' => [
                                'code' => 403,
                                'status' => 'IP allowed but no auth_key set',
                       ],
                ],
                413 => [
                        'error' => [
                                'code' => 403,
                                'status' => 'Client sending invalid auth_key',
                       ],
                ],
                414 => [
                        'error' => [
                                'code' => 403,
                                'status' => 'Invalid http method',
                       ],
                ],
		503 => [
			'error' => [
				'code' => 503,
				'status' => 'Service Unavailable',
			],
		],
	];

	public static function Query($query = null)
	{
		static $db = null;
		static $result = [];

                // Added by Security Guy from CouchPDO-PDO githnub project
                global $logging;

		try
		{
			if (isset($db, $query) === true)
			{
				if (strncasecmp($db->getAttribute(\PDO::ATTR_DRIVER_NAME), 'mysql', 5) === 0)
				{
					$query = strtr($query, '"', '`');
				}

				if (empty($result[$hash = crc32($query)]) === true)
				{
					$result[$hash] = $db->prepare($query);
				}

				$data = array_slice(func_get_args(), 1);

				if (count($data, COUNT_RECURSIVE) > count($data))
				{
					$data = iterator_to_array(new \RecursiveIteratorIterator(new \RecursiveArrayIterator($data)), false);
				}

                                // Added by Security Guy from CouchPDO-PDO githnub project
                                if ($logging) file_put_contents(__DIR__ . '/query.log', '[IP] '.get_client_ip() . ' [QUERY] ' . vsprintf(str_replace(array('%', '?'), array('%%', "'%s'"), $query), $data) . "\n", FILE_APPEND);

				if ($result[$hash]->execute($data) === true)
				{
					$sequence = null;

					if ((strncmp($db->getAttribute(\PDO::ATTR_DRIVER_NAME), 'pgsql', 5) === 0) && (sscanf($query, 'INSERT INTO %s', $sequence) > 0))
					{
						$sequence = sprintf('%s_id_seq', trim($sequence, '"'));
					}

					switch (strstr($query, ' ', true))
					{
						case 'INSERT':
						case 'REPLACE':
							return $db->lastInsertId($sequence);

						case 'UPDATE':
						case 'DELETE':
							return $result[$hash]->rowCount();

						case 'SELECT':
						case 'EXPLAIN':
						case 'PRAGMA':
						case 'SHOW':
							return $result[$hash]->fetchAll();
					}

					return true;
				}

				return false;
			}

			else if (isset($query) === true)
			{
				$options = array
				(
					\PDO::ATTR_CASE => \PDO::CASE_NATURAL,
					\PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC,
					\PDO::ATTR_EMULATE_PREPARES => false,
					\PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
					\PDO::ATTR_ORACLE_NULLS => \PDO::NULL_NATURAL,
					\PDO::ATTR_STRINGIFY_FETCHES => false,
				);

				if (preg_match('~^sqlite://([[:print:]]++)$~i', $query, $dsn) > 0)
				{
					$options += array
					(
						\PDO::ATTR_TIMEOUT => 3,
					);

					$db = new \PDO(sprintf('sqlite:%s', $dsn[1]), null, null, $options);
					$pragmas = array
					(
						'automatic_index' => 'ON',
						'cache_size' => '8192',
						'foreign_keys' => 'ON',
						'journal_size_limit' => '67110000',
						'locking_mode' => 'NORMAL',
						'page_size' => '4096',
						'recursive_triggers' => 'ON',
						'secure_delete' => 'ON',
						'synchronous' => 'NORMAL',
						'temp_store' => 'MEMORY',
						'journal_mode' => 'WAL',
						'wal_autocheckpoint' => '4096',
					);

					if (strncasecmp(PHP_OS, 'WIN', 3) !== 0)
					{
						$memory = 131072;

						if (($page = intval(shell_exec('getconf PAGESIZE'))) > 0)
						{
							$pragmas['page_size'] = $page;
						}

						if (is_readable('/proc/meminfo') === true)
						{
							if (is_resource($handle = fopen('/proc/meminfo', 'rb')) === true)
							{
								while (($line = fgets($handle, 1024)) !== false)
								{
									if (sscanf($line, 'MemTotal: %d kB', $memory) == 1)
									{
										$memory = round($memory / 131072) * 131072; break;
									}
								}

								fclose($handle);
							}
						}

						$pragmas['cache_size'] = intval($memory * 0.25 / ($pragmas['page_size'] / 1024));
						$pragmas['wal_autocheckpoint'] = $pragmas['cache_size'] / 2;
					}

					foreach ($pragmas as $key => $value)
					{
						$db->exec(sprintf('PRAGMA %s=%s;', $key, $value));
					}
				}

				else if (preg_match('~^(mysql|pgsql)://(?:(.+?)(?::(.+?))?@)?([^/:@]++)(?::(\d++))?/(\w++)/?$~i', $query, $dsn) > 0)
				{
					if (strncasecmp($query, 'mysql', 5) === 0)
					{
						$options += array
						(
							\PDO::ATTR_AUTOCOMMIT => true,
							\PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES "utf8" COLLATE "utf8_general_ci", time_zone = "+05:00";',
							\PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true,
						);
					}

					$db = new \PDO(sprintf('%s:host=%s;port=%s;dbname=%s', $dsn[1], $dsn[4], $dsn[5], $dsn[6]), $dsn[2], $dsn[3], $options);
				}
			}
		}

		catch (\Exception $exception)
		{
                        // Added by Security Guy from CouchPDO-PDO githnub project
                        if ($logging) file_put_contents(__DIR__ . '/query.log', '[IP] '.get_client_ip() . ' [EXCEPTION] ' . $e->getMessage() . "\n", FILE_APPEND);
			return false;
		}

		return (isset($db) === true) ? $db : false;
	}

	public static function Reply($data)
	{
		$bitmask = 0;
		$options = ['UNESCAPED_SLASHES', 'UNESCAPED_UNICODE'];

		if (empty($_SERVER['HTTP_X_REQUESTED_WITH']) === true)
		{
			$options[] = 'PRETTY_PRINT';
		}

		foreach ($options as $option)
		{
			$bitmask |= (defined('JSON_' . $option) === true) ? constant('JSON_' . $option) : 0;
		}

		if (($result = json_encode($data, $bitmask)) !== false)
		{
			$callback = null;

			if (array_key_exists('callback', $_GET) === true)
			{
				$callback = trim(preg_replace('~[^[:alnum:]\[\]_.]~', '', $_GET['callback']));

				if (empty($callback) !== true)
				{
					$result = sprintf('%s(%s);', $callback, $result);
				}
			}

			if (headers_sent() !== true)
			{
				header(sprintf('Content-Type: application/%s; charset=utf-8', (empty($callback) === true) ? 'json' : 'javascript'));
			}
		}

		return $result;
	}

	public static function Serve($on = null, $route = null, $callback = null)
	{
		static $root = null;

		if (isset($_SERVER['REQUEST_METHOD']) !== true)
		{
			$_SERVER['REQUEST_METHOD'] = 'CLI';
		}

		if ((empty($on) === true) || (strcasecmp($_SERVER['REQUEST_METHOD'], $on) === 0))
		{
			if (is_null($root) === true)
			{
				$root = preg_replace('~/++~', '/', substr($_SERVER['PHP_SELF'], strlen($_SERVER['SCRIPT_NAME'])) . '/');
			}

			if (preg_match('~^' . str_replace(['#any', '#num'], ['[^/]++', '[0-9]++'], $route) . '~i', $root, $parts) > 0)
			{
				return (empty($callback) === true) ? true : exit(call_user_func_array($callback, array_slice($parts, 1)));
			}
		}

		return false;
	}
}
