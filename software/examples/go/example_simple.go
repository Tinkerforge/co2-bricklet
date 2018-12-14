package main

import (
	"fmt"
	"tinkerforge/co2_bricklet"
	"tinkerforge/ipconnection"
)

const ADDR string = "localhost:4223"
const UID string = "XYZ" // Change XYZ to the UID of your CO2 Bricklet.

func main() {
	ipcon := ipconnection.New()
	defer ipcon.Close()
	co2, _ := co2_bricklet.New(UID, &ipcon) // Create device object.

	ipcon.Connect(ADDR) // Connect to brickd.
	defer ipcon.Disconnect()
	// Don't use device before ipcon is connected.

	// Get current CO2 concentration.
	co2Concentration, _ := co2.GetCO2Concentration()
	fmt.Printf("CO2 Concentration:  ppm\n", co2Concentration)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()

}
