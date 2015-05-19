#!/usr/bin/env python
# -*- coding: utf-8 -*-  

HOST = "localhost"
PORT = 4223
UID = "XYZ" # Change to your UID

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_co2 import CO2

# Callback for co2 concentration greater than 20 ppm
def cb_reached(co2_concentration):
    print('CO2 Concentration: ' + str(co2_concentration) + ' ppm.')

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    co2 = CO2(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    co2.set_debounce_period(10000)

    # Register threshold reached callback to function cb_reached
    co2.register_callback(co2.CALLBACK_CO2_CONCENTRATION_REACHED, cb_reached)

    # Configure threshold for "greater than 20 ppm"
    co2.set_co2_concentration_callback_threshold('>', 20, 0)

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.disconnect()
