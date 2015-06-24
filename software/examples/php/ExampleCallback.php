<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletCO2.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletCO2;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change to your UID

// Callback function for CO2 concentration callback (parameter has unit ppm)
function cb_co2_concentration($co2Concentration)
{
    echo "CO2 Concentration: " . $co2Concentration . " ppm\n";
}

$ipcon = new IPConnection(); // Create IP connection
$co2 = new BrickletCO2(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Set Period for CO2 concentration callback to 1s (1000ms)
// Note: The CO2 concentration callback is only called every second if the
//       CO2 concentration has changed since the last call!
$co2->setCO2ConcentrationCallbackPeriod(1000);

// Register CO2 concentration callback to function cb_co2_concentration
$co2->registerCallback(BrickletCO2::CALLBACK_CO2_CONCENTRATION, 'cb_co2_concentration');

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
