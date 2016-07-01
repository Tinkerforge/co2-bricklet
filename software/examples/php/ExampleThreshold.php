<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletCO2.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletCO2;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change XYZ to the UID of your CO2 Bricklet

// Callback function for CO2 concentration reached callback (parameter has unit ppm)
function cb_co2ConcentrationReached($co2_concentration)
{
    echo "CO2 Concentration: $co2_concentration ppm\n";
}

$ipcon = new IPConnection(); // Create IP connection
$co2 = new BrickletCO2(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$co2->setDebouncePeriod(10000);

// Register CO2 concentration reached callback to function cb_co2ConcentrationReached
$co2->registerCallback(BrickletCO2::CALLBACK_CO2_CONCENTRATION_REACHED,
                       'cb_co2ConcentrationReached');

// Configure threshold for CO2 concentration "greater than 750 ppm" (unit is ppm)
$co2->setCO2ConcentrationCallbackThreshold('>', 750, 0);

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
