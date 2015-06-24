#!/bin/sh
# connects to localhost:4223 by default, use --host and --port to change it

# change to your UID
uid=XYZ

# set period for CO2 concentration callback to 1s (1000ms)
# note: the CO2 concentration callback is only called every second if the
#       CO2 concentration has changed since the last call!
tinkerforge call co2-bricklet $uid set-co2-concentration-callback-period 1000

# handle incoming CO2 concentration callbacks (unit is ppm)
tinkerforge dispatch co2-bricklet $uid co2-concentration
