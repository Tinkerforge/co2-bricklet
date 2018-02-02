#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_co2'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'XYZ' # Change XYZ to the UID of your CO2 Bricklet

ipcon = IPConnection.new # Create IP connection
co2 = BrickletCO2.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Get current CO2 concentration
co2_concentration = co2.get_co2_concentration
puts "CO2 Concentration: #{co2_concentration} ppm"

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
