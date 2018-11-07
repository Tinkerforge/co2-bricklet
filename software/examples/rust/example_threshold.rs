use std::{error::Error, io, thread};
use tinkerforge::{co2_bricklet::*, ip_connection::IpConnection};

const HOST: &str = "localhost";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your CO2 Bricklet.

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection.
    let co2 = Co2Bricklet::new(UID, &ipcon); // Create device object.

    ipcon.connect((HOST, PORT)).recv()??; // Connect to brickd.
                                          // Don't use device before ipcon is connected.

    // Get threshold receivers with a debounce time of 10 seconds (10000ms).
    co2.set_debounce_period(10000);

    let co2_concentration_reached_receiver = co2.get_co2_concentration_reached_callback_receiver();

    // Spawn thread to handle received callback messages.
    // This thread ends when the `co2` object
    // is dropped, so there is no need for manual cleanup.
    thread::spawn(move || {
        for co2_concentration_reached in co2_concentration_reached_receiver {
            println!("CO2 Concentration: {} ppm", co2_concentration_reached);
        }
    });

    // Configure threshold for CO2 concentration "greater than 750 ppm".
    co2.set_co2_concentration_callback_threshold('>', 750, 0);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
