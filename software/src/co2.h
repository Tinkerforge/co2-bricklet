/* co2-bricklet
 * Copyright (C) 2015 Olaf Lüke <olaf@tinkerforge.com>
 *
 * co2.h: Implementation of CO2_CONCENTRATION Bricklet messages
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

#ifndef CO2_CONCENTRATION_H
#define CO2_CONCENTRATION_H

#include <stdint.h>
#include "bricklib/com/com_common.h"

#define FID_GET_CO2_CONCENTRATION 1
#define FID_SET_CO2_CONCENTRATION_CALLBACK_PERIOD 2
#define FID_GET_CO2_CONCENTRATION_CALLBACK_PERIOD 3
#define FID_SET_CO2_CONCENTRATION_CALLBACK_THRESHOLD 4
#define FID_GET_CO2_CONCENTRATION_CALLBACK_THRESHOLD 5
#define FID_SET_DEBOUNCE_PERIOD 6
#define FID_GET_DEBOUNCE_PERIOD 7
#define FID_CO2_CONCENTRATION 8
#define FID_CO2_CONCENTRATION_REACHED 9

#define FID_LAST 7

void invocation(const ComType com, const uint8_t *data);
void constructor(void);
void destructor(void);
void tick(const uint8_t tick_type);

void k30_read_registers(const uint8_t reg, uint8_t *data, const uint8_t length);
void k30_write_register(const uint8_t reg, const uint8_t value);

bool i2c_scl_value(void);
void i2c_scl_high(void);
void i2c_scl_low(void);
bool i2c_sda_value(void);
void i2c_sda_high(void);
void i2c_sda_low(void);
void i2c_sleep_halfclock(void);
void i2c_stop(void);
void i2c_start(void);
uint8_t i2c_recv_byte(bool ack);
bool i2c_send_byte(const uint8_t value);

#endif
