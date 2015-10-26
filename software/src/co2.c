/* co2-bricklet
 * Copyright (C) 2015 Olaf Lüke <olaf@tinkerforge.com>
 *
 * co2.c: Implementation of CO2_CONCENTRATION Bricklet messages
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include "co2.h"

#include "bricklib/bricklet/bricklet_communication.h"
#include "bricklib/utility/util_definitions.h"
#include "bricklib/drivers/adc/adc.h"
#include "brickletlib/bricklet_entry.h"
#include "brickletlib/bricklet_simple.h"
#include "config.h"

#define I2C_EEPROM_ADDRESS_HIGH 84
#define I2C_ADDRESS_K30         104
#define I2C_READ                1
#define I2C_WRITE               0
#define I2C_HALF_CLOCK_100KHZ   5000  // 10us per clock

#define SIMPLE_UNIT_CO2_CONCENTRATION 0

const SimpleMessageProperty smp[] = {
	{SIMPLE_UNIT_CO2_CONCENTRATION, SIMPLE_TRANSFER_VALUE, SIMPLE_DIRECTION_GET}, // TYPE_GET_CO2
	{SIMPLE_UNIT_CO2_CONCENTRATION, SIMPLE_TRANSFER_PERIOD, SIMPLE_DIRECTION_SET}, // TYPE_SET_CO2_CALLBACK_PERIOD
	{SIMPLE_UNIT_CO2_CONCENTRATION, SIMPLE_TRANSFER_PERIOD, SIMPLE_DIRECTION_GET}, // TYPE_GET_CO2_CALLBACK_PERIOD
	{SIMPLE_UNIT_CO2_CONCENTRATION, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_SET}, // TYPE_SET_CO2_CALLBACK_THRESHOLD
	{SIMPLE_UNIT_CO2_CONCENTRATION, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_GET}, // TYPE_GET_CO2_CALLBACK_THRESHOLD
	{0, SIMPLE_TRANSFER_DEBOUNCE, SIMPLE_DIRECTION_SET}, // TYPE_SET_DEBOUNCE_PERIOD
	{0, SIMPLE_TRANSFER_DEBOUNCE, SIMPLE_DIRECTION_GET}, // TYPE_GET_DEBOUNCE_PERIOD
};

const SimpleUnitProperty sup[] = {
	{NULL, SIMPLE_SIGNEDNESS_INT, FID_CO2_CONCENTRATION, FID_CO2_CONCENTRATION_REACHED, SIMPLE_UNIT_CO2_CONCENTRATION}, // co2 value
};

const uint8_t smp_length = sizeof(smp);


void invocation(const ComType com, const uint8_t *data) {
	simple_invocation(com, data);

	if(((MessageHeader*)data)->fid > FID_LAST) {
		BA->com_return_error(data, sizeof(MessageHeader), MESSAGE_ERROR_CODE_NOT_SUPPORTED, com);
	}
}

void constructor(void) {
	_Static_assert(sizeof(BrickContext) <= BRICKLET_CONTEXT_MAX_SIZE, "BrickContext too big");

	PIN_AD.type = PIO_INPUT;
	PIN_AD.attribute = PIO_DEFAULT;
	BA->PIO_Configure(&PIN_AD, 1);

	PIN_EN.type = PIO_OUTPUT_1;
	PIN_EN.attribute = PIO_DEFAULT;
	BA->PIO_Configure(&PIN_EN, 1);

	PIN_SCL.type = PIO_INPUT;
	PIN_SCL.attribute = PIO_PULLUP;
	BA->PIO_Configure(&PIN_SCL, 1);

	PIN_SDA.type = PIO_INPUT;
	PIN_SDA.attribute = PIO_PULLUP;
	BA->PIO_Configure(&PIN_SDA, 1);

	simple_constructor();
}

void destructor(void) {
	simple_destructor();
}

void tick(const uint8_t tick_type) {
	if(tick_type & TICK_TASK_TYPE_CALCULATION) {
		if(BC->tick % 500 == 0) {
			uint8_t data[4];
			k30_read_registers(0x08, data, 4);
			const uint8_t checksum = data[0] + data[1] + data[2];

			// In case of "no error", data[3] is the checksum and data[0] is 0.
			// We don't accept a co2 value of 0 (data[1] = data[2] = 0)
			if((checksum == data[3]) && (data[0] == 0) && !(data[1] == 0 && data[2] == 0)) {
				BC->last_value[SIMPLE_UNIT_CO2_CONCENTRATION] = BC->value[SIMPLE_UNIT_CO2_CONCENTRATION];
				BC->value[SIMPLE_UNIT_CO2_CONCENTRATION] = (data[1] << 8) | data[2];
			} else if(data[0] != 0) { // Increase error counter for error
				for(uint8_t i = 0; i < 8; i++) {
					if(data[0] & (1 << i)) {
						BC->error_counter[i]++;
					}
				}
			}
		}
	}

	simple_tick(tick_type);
}

void k30_read_registers(const uint8_t reg, uint8_t *data, const uint8_t length) {
	const uint8_t command_and_bytes_to_read = (2 << 4) | (length-2);
	for(uint8_t i = 0; i < length; i++) {
		data[i] = 0;
	}

/*	i2c_start();
	i2c_send_byte(0);
	i2c_stop();

	SLEEP_MS(1);*/

	i2c_start();
	i2c_send_byte((I2C_ADDRESS_K30 << 1) | I2C_WRITE);
	i2c_send_byte(command_and_bytes_to_read);
	i2c_send_byte(0);
	i2c_send_byte(reg);
	i2c_send_byte(command_and_bytes_to_read + 0 + reg);
	i2c_stop();

	SLEEP_MS(20);

	i2c_start();
	i2c_send_byte((I2C_ADDRESS_K30 << 1) | I2C_READ);
	for(uint8_t i = 0; i < length; i++) {
		data[i] = i2c_recv_byte(i != (length - 1));
	}
	i2c_stop();
}

void k30_write_register(const uint8_t reg, const uint8_t value) {
	i2c_start();
	i2c_send_byte((I2C_ADDRESS_K30 << 1) | I2C_WRITE);
	i2c_send_byte(reg);
	i2c_send_byte(value);
	i2c_stop();
}

bool i2c_scl_value(void) {
	return PIN_SCL.pio->PIO_PDSR & PIN_SCL.mask;
}

void i2c_scl_high(void) {
	PIN_SCL.pio->PIO_ODR = PIN_SCL.mask;
	while(!i2c_scl_value()); // allow slave to clock-stretch
}

void i2c_scl_low(void) {
	PIN_SCL.pio->PIO_OER = PIN_SCL.mask;
}

bool i2c_sda_value(void) {
	return PIN_SDA.pio->PIO_PDSR & PIN_SDA.mask;
}

void i2c_sda_high(void) {
	PIN_SDA.pio->PIO_ODR = PIN_SDA.mask;
}

void i2c_sda_low(void) {
	PIN_SDA.pio->PIO_OER = PIN_SDA.mask;
}

void i2c_sleep_halfclock(void) {
	SLEEP_NS(I2C_HALF_CLOCK_100KHZ);
}

void i2c_stop(void) {
	i2c_scl_low();
	i2c_sda_low();
	i2c_sleep_halfclock();
	i2c_scl_high();
	i2c_sleep_halfclock();
	i2c_sda_high();
	i2c_sleep_halfclock();
}

void i2c_start(void) {
	i2c_scl_high();
	i2c_sleep_halfclock();
	i2c_sda_low();
	i2c_sleep_halfclock();
}

uint8_t i2c_recv_byte(bool ack) {
	uint8_t value = 0;

	for(int8_t i = 7; i >= 0; i--) {
		i2c_scl_low();
		i2c_sda_high(); // allow slave to read
		i2c_sleep_halfclock();
		i2c_scl_high();
		if(i2c_sda_value()) {
			value |= (1 << i);
		}
		i2c_sleep_halfclock();
	}

	// ACK
	i2c_scl_low();
	if(ack) {
		i2c_sda_low();
	} else {
		i2c_sda_high();
	}
	i2c_sleep_halfclock();
	i2c_scl_high();
	i2c_sleep_halfclock();

	return value;
}

bool i2c_send_byte(const uint8_t value) {
	for(int8_t i = 7; i >= 0; i--) {
		i2c_scl_low();
		if((value >> i) & 1) {
			i2c_sda_high();
		} else {
			i2c_sda_low();
		}
		i2c_sleep_halfclock();
		i2c_scl_high();
		i2c_sleep_halfclock();
	}

	i2c_sda_high(); // Make sure SDA is always released

	// Wait for ACK
	bool ret = false;

	i2c_scl_low();
	i2c_sleep_halfclock();
	i2c_scl_high();
	if(!i2c_sda_value()) {
		ret = true;
	}

	i2c_sleep_halfclock();

	return ret;
}
