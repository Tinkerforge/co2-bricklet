import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletCO2;

public class ExampleCallback {
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

		// Add CO2 concentration listener
		co2.addCO2ConcentrationListener(new BrickletCO2.CO2ConcentrationListener() {
			public void co2Concentration(int co2Concentration) {
				System.out.println("CO2 Concentration: " + co2Concentration + " ppm");
			}
		});

		// Set period for CO2 concentration callback to 1s (1000ms)
		// Note: The CO2 concentration callback is only called every second
		//       if the CO2 concentration has changed since the last call!
		co2.setCO2ConcentrationCallbackPeriod(1000);

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
