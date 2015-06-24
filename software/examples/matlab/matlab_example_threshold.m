function matlab_example_threshold()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletCO2;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'amb'; % Change to your UID

    ipcon = IPConnection(); % Create IP connection
    co2 = BrickletCO2(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Set threshold callbacks with a debounce time of 10 seconds (10000ms)
    co2.setDebouncePeriod(10000);

    % Register threshold reached callback to function cb_reached
    set(co2, 'CO2ConcentrationReachedCallback', @(h, e) cb_reached(e));

    % Configure threshold for "greater than 750 ppm" (unit is ppm)
    co2.setCO2ConcentrationCallbackThreshold('>', 750, 0);

    input('Press any key to exit...\n', 's');
    ipcon.disconnect();
end

% Callback for CO2 concentration greater than 750 ppm
function cb_reached(e)
    fprintf('CO2 Concentration: %g ppm\n', e.co2_concentration);
end
