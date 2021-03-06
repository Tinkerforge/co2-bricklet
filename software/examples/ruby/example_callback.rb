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

# Register CO2 concentration callback
co2.register_callback(BrickletCO2::CALLBACK_CO2_CONCENTRATION) do |co2_concentration|
  puts "CO2 Concentration: #{co2_concentration} ppm"
end

# Set period for CO2 concentration callback to 1s (1000ms)
# Note: The CO2 concentration callback is only called every second
#       if the CO2 concentration has changed since the last call!
co2.set_co2_concentration_callback_period 1000

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
