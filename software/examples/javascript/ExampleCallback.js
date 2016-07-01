var Tinkerforge = require('tinkerforge');

var HOST = 'localhost';
var PORT = 4223;
var UID = 'XYZ'; // Change XYZ to the UID of your CO2 Bricklet

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
        // Set period for CO2 concentration callback to 1s (1000ms)
        // Note: The CO2 concentration callback is only called every second
        //       if the CO2 concentration has changed since the last call!
        co2.setCO2ConcentrationCallbackPeriod(1000);
    }
);

// Register CO2 concentration callback
co2.on(Tinkerforge.BrickletCO2.CALLBACK_CO2_CONCENTRATION,
    // Callback function for CO2 concentration callback (parameter has unit ppm)
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
