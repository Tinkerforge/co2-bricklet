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

	co2.RegisterCO2ConcentrationCallback(func(co2Concentration uint16) {
		fmt.Printf("CO2 Concentration: %d ppm\n", co2Concentration)
	})

	// Set period for CO2 concentration receiver to 1s (1000ms).
	// Note: The CO2 concentration callback is only called every second
	//       if the CO2 concentration has changed since the last call!
	co2.SetCO2ConcentrationCallbackPeriod(1000)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()

}
