function octave_example_threshold()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "amb"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    co2 = java_new("com.tinkerforge.BrickletCO2", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Set threshold callbacks with a debounce time of 10 seconds (10000ms)
    co2.setDebouncePeriod(10000);

    % Configure threshold for "greater than 750 ppm"
    co2.setCO2ConcentrationCallbackThreshold(co2.THRESHOLD_OPTION_GREATER, 750, 0);

    % Register threshold reached callback to function cb_reached
    co2.addCO2ConcentrationReachedCallback(@cb_reached);

    input("Press any key to exit...\n", "s");
    ipcon.disconnect();
end

% Callback function for CO2 concentration callback (parameter has unit ppm)
function cb_reached(e)
    fprintf("CO2 Concentration: %g ppm\n", e.co2_concentration);
end
