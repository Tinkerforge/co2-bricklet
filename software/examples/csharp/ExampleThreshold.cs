using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change to your UID

	// Callback for co2 concentration greater than 20 ppm
	static void ReachedCB(BrickletCO2 sender, int co2Concentration)
	{
		System.Console.WriteLine("CO2 Concentration: " + co2Concentration + " ppm.");
	}

	static void Main() 
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletCO2 co2 = new BrickletCO2(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		co2.SetDebouncePeriod(10000);

		// Register threshold reached callback to function ReachedCB
		co2.CO2ConcentrationReached += ReachedCB;

		// Configure threshold for "greater than 20 ppm"
		co2.SetCO2ConcentrationCallbackThreshold('>', 20, 0);

		System.Console.WriteLine("Press enter to exit");
		System.Console.ReadLine();
		ipcon.Disconnect();
	}
}
