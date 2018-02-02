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

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
co2.set_debounce_period 10000

# Register CO2 concentration reached callback
co2.register_callback(BrickletCO2::CALLBACK_CO2_CONCENTRATION_REACHED) do |co2_concentration|
  puts "CO2 Concentration: #{co2_concentration} ppm"
end

# Configure threshold for CO2 concentration "greater than 750 ppm"
co2.set_co2_concentration_callback_threshold '>', 750, 0

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
