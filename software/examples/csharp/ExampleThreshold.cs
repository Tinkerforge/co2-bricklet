using System;
using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change XYZ to the UID of your CO2 Bricklet

	// Callback function for CO2 concentration reached callback (parameter has unit ppm)
	static void CO2ConcentrationReachedCB(BrickletCO2 sender, int co2Concentration)
	{
		Console.WriteLine("CO2 Concentration: " + co2Concentration + " ppm");
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletCO2 co2 = new BrickletCO2(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		co2.SetDebouncePeriod(10000);

		// Register CO2 concentration reached callback to function CO2ConcentrationReachedCB
		co2.CO2ConcentrationReachedCallback += CO2ConcentrationReachedCB;

		// Configure threshold for CO2 concentration "greater than 750 ppm" (unit is ppm)
		co2.SetCO2ConcentrationCallbackThreshold('>', 750, 0);

		Console.WriteLine("Press enter to exit");
		Console.ReadLine();
		ipcon.Disconnect();
	}
}
