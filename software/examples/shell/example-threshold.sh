#!/bin/sh
# connects to localhost:4223 by default, use --host and --port to change it

# change to your UID
uid=XYZ

# get threshold callbacks with a debounce time of 10 seconds (10000ms)
tinkerforge call co2-bricklet $uid set-debounce-period 10000

# configure threshold for "greater than 750 ppm"
tinkerforge call co2-bricklet $uid set-co2-concentration-callback-threshold greater 750 0

# handle incoming CO2 concentration-reached callbacks (unit is ppm)
tinkerforge dispatch co2-bricklet $uid co2-concentration-reached\
 --execute "echo CO2 Concentration: {co2-concentration} ppm"
