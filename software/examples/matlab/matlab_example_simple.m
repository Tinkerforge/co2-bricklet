function matlab_example_simple()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletCO2;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'amb'; % Change to your UID

    ipcon = IPConnection(); % Create IP connection
    co2 = BrickletCO2(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current co2 concentration (unit is ppm)
    co2_concentration = al.getCO2Concentration();
    fprintf('CO2 Concentration: %g ppm\n', co2_concentration);

    input('Press any key to exit...\n', 's');
    ipcon.disconnect();
end
