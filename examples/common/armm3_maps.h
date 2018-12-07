/*
 *  Copyright 2018 Sergey Khabarov, sergeykhbr@gmail.com
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#ifndef __FW_COMMON_ARMM3_MAPS_H__
#define __FW_COMMON_ARMM3_MAPS_H__

#include <inttypes.h>
#include "maps/map_uart.h"
#include "maps/map_gptimers.h"

#define ADDR_HSLV2_SRAM0     0x20000000
#define ADDR_HSLV3_SRAM1     0x20008000
#define ADDR_HSLV4_SRAM2     0x20010000
#define ADDR_HSLV5_SRAM3     0x20018000
#define ADDR_PSLV0_UART1     0x40000000

void irq_handler_c(void);

#endif  // __FW_COMMON_ARMM3_MAPS_H__
