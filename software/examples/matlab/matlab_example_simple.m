function matlab_example_simple()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletCO2;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change to your UID

    ipcon = IPConnection(); % Create IP connection
    co2 = handle(BrickletCO2(UID, ipcon), 'CallbackProperties'); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current CO2 concentration (unit is ppm)
    co2Concentration = co2.getCO2Concentration();
    fprintf('CO2 Concentration: %i ppm\n', co2Concentration);

    input('Press key to exit\n', 's');
    ipcon.disconnect();
end
