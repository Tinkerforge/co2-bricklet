#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change XYZ to the UID of your CO2 Bricklet

# Get current CO2 concentration
tinkerforge call co2-bricklet $uid get-co2-concentration
