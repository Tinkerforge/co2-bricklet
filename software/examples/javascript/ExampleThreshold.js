var Tinkerforge = require('tinkerforge');

var HOST = 'localhost';
var PORT = 4223;
var UID = 'XYZ'; // Change to your UID

var ipcon = new Tinkerforge.IPConnection(); // Create IP connection
var co2 = new Tinkerforge.BrickletCO2(UID, ipcon); // Create device object

ipcon.connect(HOST, PORT,
    function (error) {
        console.log('Error: ' + error);
    }
); // Connect to brickd
// Don't use device before ipcon is connected

ipcon.on(Tinkerforge.IPConnection.CALLBACK_CONNECTED,
    function (connectReason) {
        // Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        co2.setDebouncePeriod(10000);

        // Configure threshold for CO2 concentration "greater than 750 ppm" (unit is ppm)
        co2.setCO2ConcentrationCallbackThreshold('>', 750, 0);
    }
);

// Register CO2 concentration reached callback
co2.on(Tinkerforge.BrickletCO2.CALLBACK_CO2_CONCENTRATION_REACHED,
    // Callback function for CO2 concentration reached callback (parameter has unit ppm)
    function (co2Concentration) {
        console.log('CO2 Concentration: ' + co2Concentration + ' ppm');
    }
);

console.log('Press key to exit');
process.stdin.on('data',
    function (data) {
        ipcon.disconnect();
        process.exit(0);
    }
);
