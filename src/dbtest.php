<?php

namespace App\Console\src;

use ClickHouseDB\Client;

require_once dirname(__DIR__, 3) . '/vendor/autoload.php';

// -----------------------------------------------------------------------------

$config = getConfig($argv);

$db = new Client($config);
$db->database($config['database']);
$db->setTimeout(1.5);             // 1 second , support only Int value
$db->setTimeout(10);              // 10 seconds
$db->setConnectTimeOut(5);        // 5 seconds
$st = $db->ping();                // if can`t connect throw exception

echo 'Connect: ';
echo ($st) ? 'true'."\n" : 'false'."\n";

// -----------------------------------------------------------------------------

function getConfig(array $argv): array
{
    return [
        'host' => $argv[1],
        'username' => $argv[2],
        'password' => $argv[3],
        'database' => $argv[4],
        'port' => $argv[5],
        'https' => $argv[6] === 'true',
    ];
}
