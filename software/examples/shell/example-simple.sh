#!/bin/sh
# connects to localhost:4223 by default, use --host and --port to change it

# change to your UID
uid=XYZ

# get current CO2 concentration (unit is ppm)
tinkerforge call co2-bricklet $uid get-co2-concentration
