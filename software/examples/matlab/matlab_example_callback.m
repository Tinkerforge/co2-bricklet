function matlab_example_callback()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletCO2;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'amb'; % Change to your UID

    ipcon = IPConnection(); % Create IP connection
    co2 = BrickletCO2(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Set Period for CO2 concentration callback to 1s (1000ms)
    % Note: The callback is only called every second if the
    %       CO2 concentration has changed since the last call!
    co2.setCO2ConcentrationCallbackPeriod(1000);

    % Register CO2 concentration callback to function cb_co2_concentration
    set(co2, 'CO2ConcentrationCallback', @(h, e) cb_co2_concentration(e));

    input('Press any key to exit...\n', 's');
    ipcon.disconnect();
end

% Callback function for CO2 concentration callback (parameter has unit ppm)
function cb_co2_concentration(e)
    fprintf('CO2 Concentration: %g ppm\n', e.co2_concentration);
end
