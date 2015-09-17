function octave_example_simple()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    co2 = java_new("com.tinkerforge.BrickletCO2", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current CO2 concentration (unit is ppm)
    co2Concentration = co2.getCO2Concentration();
    fprintf("CO2 Concentration: %d ppm\n", co2Concentration);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end
