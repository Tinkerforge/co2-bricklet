using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change to your UID

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletCO2 co2 = new BrickletCO2(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get current CO2 concentration (unit is ppm)
		int co2Concentration = co2.GetCO2Concentration();

		System.Console.WriteLine("CO2 Concentration: " + co2Concentration + " ppm");

		System.Console.WriteLine("Press enter to exit");
		System.Console.ReadLine();
		ipcon.Disconnect();
	}
}
