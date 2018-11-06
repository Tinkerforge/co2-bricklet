use std::{error::Error, io, thread};
use tinkerforge::{co2_bricklet::*, ipconnection::IpConnection};

const HOST: &str = "127.0.0.1";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your CO2 Bricklet

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection
    let co2_bricklet = CO2Bricklet::new(UID, &ipcon); // Create device object

    ipcon.connect(HOST, PORT).recv()??; // Connect to brickd
                                        // Don't use device before ipcon is connected

    //Create listener for CO2 concentration events.
    let co2_concentration_listener = co2_bricklet.get_co2_concentration_receiver();
    // Spawn thread to handle received events. This thread ends when the co2_bricklet
    // is dropped, so there is no need for manual cleanup.
    thread::spawn(move || {
        for event in co2_concentration_listener {
            println!("CO2 Concentration: {}{}", event, " ppm");
        }
    });

    // Set period for CO2 concentration listener to 1s (1000ms)
    // Note: The CO2 concentration callback is only called every second
    //       if the CO2 concentration has changed since the last call!
    co2_bricklet.set_co2_concentration_callback_period(1000);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
