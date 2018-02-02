#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change XYZ to the UID of your CO2 Bricklet

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
tinkerforge call co2-bricklet $uid set-debounce-period 10000

# Handle incoming CO2 concentration reached callbacks
tinkerforge dispatch co2-bricklet $uid co2-concentration-reached &

# Configure threshold for CO2 concentration "greater than 750 ppm"
tinkerforge call co2-bricklet $uid set-co2-concentration-callback-threshold threshold-option-greater 750 0

echo "Press key to exit"; read dummy

kill -- -$$ # Stop callback dispatch in background
