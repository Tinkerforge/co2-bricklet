#!/usr/bin/perl

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletCO2;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change XYZ to the UID of your CO2 Bricklet

# Callback subroutine for CO2 concentration callback (parameter has unit ppm)
sub cb_co2_concentration
{
    my ($co2_concentration) = @_;

    print "CO2 Concentration: $co2_concentration ppm\n";
}

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $co2 = Tinkerforge::BrickletCO2->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Register CO2 concentration callback to subroutine cb_co2_concentration
$co2->register_callback($co2->CALLBACK_CO2_CONCENTRATION, 'cb_co2_concentration');

# Set period for CO2 concentration callback to 1s (1000ms)
# Note: The CO2 concentration callback is only called every second
#       if the CO2 concentration has changed since the last call!
$co2->set_co2_concentration_callback_period(1000);

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
