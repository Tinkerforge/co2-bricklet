#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change to your UID

# Get current CO2 concentration (unit is ppm)
tinkerforge call co2-bricklet $uid get-co2-concentration
