import com.tinkerforge.BrickletCO2;
import com.tinkerforge.IPConnection;

public class ExampleCallback {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;
	private static final String UID = "XYZ"; // Change to your UID

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions you
	//       might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletCO2 co2 = new BrickletCO2(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Set Period for co2 concentration callback to 1s (1000ms)
		// Note: The co2 concentration callback is only called every second if the 
		//       co2 concentration has changed since the last call!
		co2.setCO2ConcentrationCallbackPeriod(1000);

		// Add and implement co2 concentration listener (called if co2 concentration changes)
		co2.addCO2ConcentrationListener(new BrickletCO2.CO2ConcentrationListener() {
			public void co2Concentration(int co2Concentration) {
				System.out.println("CO2 Concentration: " + co2Concentration + " ppm");
			}
		});

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
