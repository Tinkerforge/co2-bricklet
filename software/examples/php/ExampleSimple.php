<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletCO2.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletCO2;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change to your UID

$ipcon = new IPConnection(); // Create IP connection
$co2 = new BrickletCO2(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Get current CO2 concentration (unit is ppm)
$co2_concentration = $co2->getCO2Concentration();
echo "CO2 Concentration: $co2_concentration ppm\n";

echo "Press key to exit\n";
fgetc(fopen('php://stdin', 'r'));
$ipcon->disconnect();

?>
