#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change XYZ to the UID of your CO2 Bricklet

# Handle incoming CO2 concentration callbacks
tinkerforge dispatch co2-bricklet $uid co2-concentration &

# Set period for CO2 concentration callback to 1s (1000ms)
# Note: The CO2 concentration callback is only called every second
#       if the CO2 concentration has changed since the last call!
tinkerforge call co2-bricklet $uid set-co2-concentration-callback-period 1000

echo "Press key to exit"; read dummy

kill -- -$$ # Stop callback dispatch in background
