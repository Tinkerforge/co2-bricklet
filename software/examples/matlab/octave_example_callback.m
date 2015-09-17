function octave_example_callback()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    co2 = java_new("com.tinkerforge.BrickletCO2", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Register CO2 concentration callback to function cb_co2_concentration
    co2.addCO2ConcentrationCallback(@cb_co2_concentration);

    % Set period for CO2 concentration callback to 1s (1000ms)
    % Note: The CO2 concentration callback is only called every second
    %       if the CO2 concentration has changed since the last call!
    co2.setCO2ConcentrationCallbackPeriod(1000);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end

% Callback function for CO2 concentration callback (parameter has unit ppm)
function cb_co2_concentration(e)
    fprintf("CO2 Concentration: %d ppm\n", e.co2Concentration);
end
