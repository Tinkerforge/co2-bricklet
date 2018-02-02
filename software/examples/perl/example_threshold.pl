#!/usr/bin/perl

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletCO2;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change XYZ to the UID of your CO2 Bricklet

# Callback subroutine for CO2 concentration reached callback
sub cb_co2_concentration_reached
{
    my ($co2_concentration) = @_;

    print "CO2 Concentration: $co2_concentration ppm\n";
}

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $co2 = Tinkerforge::BrickletCO2->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$co2->set_debounce_period(10000);

# Register CO2 concentration reached callback to subroutine cb_co2_concentration_reached
$co2->register_callback($co2->CALLBACK_CO2_CONCENTRATION_REACHED,
                        'cb_co2_concentration_reached');

# Configure threshold for CO2 concentration "greater than 750 ppm"
$co2->set_co2_concentration_callback_threshold('>', 750, 0);

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
