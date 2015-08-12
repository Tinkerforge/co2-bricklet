#include <stdio.h>

#include "ip_connection.h"
#include "bricklet_co2.h"

#define HOST "localhost"
#define PORT 4223
#define UID "XYZ" // Change to your UID

// Callback function for CO2 concentration greater than 750 ppm (parameter has unit ppm)
void cb_co2_concentration_reached(uint16_t co2_concentration, void *user_data) {
	(void)user_data; // avoid unused parameter warning

	printf("CO2 Concentration: %d ppm\n", co2_concentration);
}

int main(void) {
	// Create IP connection
	IPConnection ipcon;
	ipcon_create(&ipcon);

	// Create device object
	CO2 co2;
	co2_create(&co2, UID, &ipcon);

	// Connect to brickd
	if(ipcon_connect(&ipcon, HOST, PORT) < 0) {
		fprintf(stderr, "Could not connect\n");
		return 1;
	}
	// Don't use device before ipcon is connected

	// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
	co2_set_debounce_period(&co2, 10000);

	// Register threshold reached callback to function cb_co2_concentration_reached
	co2_register_callback(&co2,
	                      CO2_CALLBACK_CO2_CONCENTRATION_REACHED,
	                      (void *)cb_co2_concentration_reached,
	                      NULL);

	// Configure threshold for "greater than 750 ppm" (unit is ppm)
	co2_set_co2_concentration_callback_threshold(&co2, '>', 750, 0);

	printf("Press key to exit\n");
	getchar();
	ipcon_destroy(&ipcon); // Calls ipcon_disconnect internally
	return 0;
}
