function octave_example_simple()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "amb"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    co2 = java_new("com.tinkerforge.BrickletCO2", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current co2 concentration (unit is ppm)
    co2_concentration = co2.getCO2Concentration();
    fprintf("CO2 Concentration: %g ppm\n", co2_concentration);

    input("Press any key to exit...\n", "s");
    ipcon.disconnect();
end
