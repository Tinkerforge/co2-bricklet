package main

import (
	"fmt"
	"github.com/tinkerforge/go-api-bindings/co2_bricklet"
	"github.com/tinkerforge/go-api-bindings/ipconnection"
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

	// Get threshold receivers with a debounce time of 10 seconds (10000ms).
	co2.SetDebouncePeriod(10000)

	co2.RegisterCO2ConcentrationReachedCallback(func(co2Concentration uint16) {
		fmt.Printf("CO2 Concentration: %d ppm\n", co2Concentration)
	})

	// Configure threshold for CO2 concentration "greater than 750 ppm".
	co2.SetCO2ConcentrationCallbackThreshold('>', 750, 0)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()

}
