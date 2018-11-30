--!
--! Copyright 2018 Sergey Khabarov, sergeykhbr@gmail.com
--!
--! Licensed under the Apache License, Version 2.0 (the "License");
--! you may not use this file except in compliance with the License.
--! You may obtain a copy of the License at
--!
--!     http://www.apache.org/licenses/LICENSE-2.0
--!
--! Unless required by applicable law or agreed to in writing, software
--! distributed under the License is distributed on an "AS IS" BASIS,
--! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--! See the License for the specific language governing permissions and
--! limitations under the License.
--!
--! @{
--!

--! Standard library
library IEEE;
--! Standard signal definitions
use IEEE.STD_LOGIC_1164.ALL;

--! Technology definition library
library techmap;
--! Generic IDs constants import
use techmap.gencomp.all;

--! @brief   Techology independent configuration settings.
--! @details This file defines configuration that are valid for all supported
--!          targets: behaviour simulation, FPGAs or ASICs.
package config_common is


--! @brief   HEX-image for the initialization of the Boot ROM.
--! @details This file is used by \e inferred ROM implementation.
--! @warning Used ONLY in INFERED and FPGAs targets. ASIC uses hardcoded names in verilog
constant CFG_SIM_BOOTROM_HEX : string := 
              "../../fw_images/bootimage.hex";


--! @brief Hardware SoC Identificator.
--!
--! @details Read Only unique platform identificator that could be
--!          read by firmware from the Plug'n'Play support module.
constant CFG_HW_ID : std_logic_vector(31 downto 0) := X"20181129";

end;

--! @}
--!
