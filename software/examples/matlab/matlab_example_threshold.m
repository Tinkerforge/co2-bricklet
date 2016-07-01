function matlab_example_threshold()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletCO2;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change XYZ to the UID of your CO2 Bricklet

    ipcon = IPConnection(); % Create IP connection
    co2 = handle(BrickletCO2(UID, ipcon), 'CallbackProperties'); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    co2.setDebouncePeriod(10000);

    % Register CO2 concentration reached callback to function cb_co2_concentration_reached
    set(co2, 'CO2ConcentrationReachedCallback', @(h, e) cb_co2_concentration_reached(e));

    % Configure threshold for CO2 concentration "greater than 750 ppm" (unit is ppm)
    co2.setCO2ConcentrationCallbackThreshold('>', 750, 0);

    input('Press key to exit\n', 's');
    ipcon.disconnect();
end

% Callback function for CO2 concentration reached callback (parameter has unit ppm)
function cb_co2_concentration_reached(e)
    fprintf('CO2 Concentration: %i ppm\n', e.co2Concentration);
end
