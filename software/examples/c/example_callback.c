#include <stdio.h>

#include "ip_connection.h"
#include "bricklet_co2.h"

#define HOST "localhost"
#define PORT 4223
#define UID "XYZ" // Change to your UID

// Callback function for co2 concentration callback (parameter has unit ppm)
void cb_co2_concentration(uint16_t co2_concentration, void *user_data) {
	(void)user_data; // avoid unused parameter warning

	printf("CO2 Concentration: %d ppm.\n", co2_concentration);
}

int main() {
	// Create IP connection
	IPConnection ipcon;
	ipcon_create(&ipcon);

	// Create device object
	CO2 co2;
	co2_create(&co2, UID, &ipcon); 

	// Connect to brickd
	if(ipcon_connect(&ipcon, HOST, PORT) < 0) {
		fprintf(stderr, "Could not connect\n");
		exit(1);
	}
	// Don't use device before ipcon is connected

	// Set Period for co2 concentration callback to 1s (1000ms)
	// Note: The co2 concentration callback is only called every second if the 
	//       co2 concentration has changed since the last call!
	co2_set_co2_concentration_callback_period(&co2, 1000);

	// Register co2 concentration callback to function cb_co2_concentration
	co2_register_callback(&co2,
	                      CO2_CALLBACK_CO2_CONCENTRATION,
	                      (void *)cb_co2_concentration,
	                      NULL);

	printf("Press key to exit\n");
	getchar();
	ipcon_destroy(&ipcon); // Calls ipcon_disconnect internally
}
