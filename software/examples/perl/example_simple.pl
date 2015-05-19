#!/usr/bin/perl  

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletCO2;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change to your UID

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $co2 = Tinkerforge::BrickletCO2->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get current co2 concentration (unit is ppm)
my $co2_concentration = $co2->get_co2_concentration();
print "CO2 Concentration: $co2_concentration ppm\n";

print "Press any key to exit...\n";
<STDIN>;
$ipcon->disconnect();
