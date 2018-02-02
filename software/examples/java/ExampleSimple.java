import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletCO2;

public class ExampleSimple {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;

	// Change XYZ to the UID of your CO2 Bricklet
	private static final String UID = "XYZ";

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions
	//       you might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletCO2 co2 = new BrickletCO2(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get current CO2 concentration
		int co2Concentration = co2.getCO2Concentration(); // Can throw com.tinkerforge.TimeoutException
		System.out.println("CO2 Concentration: " + co2Concentration + " ppm");

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
