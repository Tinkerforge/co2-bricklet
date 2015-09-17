import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletCO2;

public class ExampleThreshold {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;
	private static final String UID = "XYZ"; // Change to your UID

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions
	//       you might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletCO2 co2 = new BrickletCO2(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		co2.setDebouncePeriod(10000);

		// Add CO2 concentration reached listener (parameter has unit ppm)
		co2.addCO2ConcentrationReachedListener(new BrickletCO2.CO2ConcentrationReachedListener() {
			public void co2ConcentrationReached(int co2Concentration) {
				System.out.println("CO2 Concentration: " + co2Concentration + " ppm");
			}
		});

		// Configure threshold for CO2 concentration "greater than 750 ppm" (unit is ppm)
		co2.setCO2ConcentrationCallbackThreshold('>', 750, 0);

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
