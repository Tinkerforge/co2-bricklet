function octave_example_simple()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change XYZ to the UID of your CO2 Bricklet

    ipcon = javaObject("com.tinkerforge.IPConnection"); % Create IP connection
    co2 = javaObject("com.tinkerforge.BrickletCO2", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current CO2 concentration (unit is ppm)
    co2Concentration = co2.getCO2Concentration();
    fprintf("CO2 Concentration: %d ppm\n", co2Concentration);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end
