using System;
using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change XYZ to the UID of your CO2 Bricklet

	// Callback function for CO2 concentration callback (parameter has unit ppm)
	static void CO2ConcentrationCB(BrickletCO2 sender, int co2Concentration)
	{
		Console.WriteLine("CO2 Concentration: " + co2Concentration + " ppm");
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletCO2 co2 = new BrickletCO2(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Register CO2 concentration callback to function CO2ConcentrationCB
		co2.CO2ConcentrationCallback += CO2ConcentrationCB;

		// Set period for CO2 concentration callback to 1s (1000ms)
		// Note: The CO2 concentration callback is only called every second
		//       if the CO2 concentration has changed since the last call!
		co2.SetCO2ConcentrationCallbackPeriod(1000);

		Console.WriteLine("Press enter to exit");
		Console.ReadLine();
		ipcon.Disconnect();
	}
}
