<?php

namespace Modules\Tokenbox\src;

# Run: php modules/tokenbox/src/calc.php 10 62 1000
# Out: 1000 [10 => 62] >> g8

use Src83\TokenBoxCore\lib\Calc;
use Src83\TokenBoxCore\src\DTO\Calc\ConfigDTO;
use Src83\TokenBoxCore\src\Utils\Calc\InputValidator;

require_once dirname(__DIR__, 3) . '/vendor/autoload.php';

define('TIME_START', microtime(true));

// -----------------------------------------------------------------------------

if (!InputValidator::validateArguments($argv)) {
    exit(1);
}

$configDTO = new ConfigDTO($argv[1], $argv[2], $argv[3]);

$calc = new Calc($configDTO);
$calc->makeCalc();
$calc->printResult();

if (in_array('--stat', $argv, true)) {
    $calc->printStat();
}
