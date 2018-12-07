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

#ifndef __FW_COMMON_MAPS_MAP_GPTIMERS_H__
#define __FW_COMMON_MAPS_MAP_GPTIMERS_H__

#include <inttypes.h>

#define TIMER_CONTROL_ENA      (1 << 0)
#define TIMER_CONTROL_IRQ_ENA  (1 << 1)

typedef struct gptimer_type {
    volatile uint32_t control;
    volatile uint32_t rsv1;
    volatile uint64_t cur_value;
    volatile uint64_t init_value;
    volatile uint32_t rsv2[2];
} gptimer_type;


typedef struct gptimers_map {
        uint64_t highcnt;
        uint32_t pending;
        uint32_t overrun;
        uint32_t rsvr[12];
        gptimer_type timer[4];
} gptimers_map;

#endif  // __FW_COMMON_MAPS_MAP_GPTIMERS_H__
