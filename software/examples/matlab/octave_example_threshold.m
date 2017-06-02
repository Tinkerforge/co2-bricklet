function octave_example_threshold()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change XYZ to the UID of your CO2 Bricklet

    ipcon = javaObject("com.tinkerforge.IPConnection"); % Create IP connection
    co2 = javaObject("com.tinkerforge.BrickletCO2", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    co2.setDebouncePeriod(10000);

    % Register CO2 concentration reached callback to function cb_co2_concentration_reached
    co2.addCO2ConcentrationReachedCallback(@cb_co2_concentration_reached);

    % Configure threshold for CO2 concentration "greater than 750 ppm" (unit is ppm)
    co2.setCO2ConcentrationCallbackThreshold(">", 750, 0);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end

% Callback function for CO2 concentration reached callback (parameter has unit ppm)
function cb_co2_concentration_reached(e)
    fprintf("CO2 Concentration: %d ppm\n", e.co2Concentration);
end
