function matlab_example_callback()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletCO2;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change XYZ to the UID of your CO2 Bricklet

    ipcon = IPConnection(); % Create IP connection
    co2 = handle(BrickletCO2(UID, ipcon), 'CallbackProperties'); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Register CO2 concentration callback to function cb_co2_concentration
    set(co2, 'CO2ConcentrationCallback', @(h, e) cb_co2_concentration(e));

    % Set period for CO2 concentration callback to 1s (1000ms)
    % Note: The CO2 concentration callback is only called every second
    %       if the CO2 concentration has changed since the last call!
    co2.setCO2ConcentrationCallbackPeriod(1000);

    input('Press key to exit\n', 's');
    ipcon.disconnect();
end

% Callback function for CO2 concentration callback
function cb_co2_concentration(e)
    fprintf('CO2 Concentration: %i ppm\n', e.co2Concentration);
end
