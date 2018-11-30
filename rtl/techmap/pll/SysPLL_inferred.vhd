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
--!
--! "Output    Output      Phase     Duty      Pk-to-Pk        Phase"
--! "Clock    Freq (MHz) (degrees) Cycle (%) Jitter (ps)  Error (ps)"
--!
--! CLK_OUT1____70.000
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library commonlib;
use commonlib.types_common.all;

--library unisim;
--use unisim.vcomponents.all;

entity SysPLL_inferred is
port
 (-- Clock in ports
  CLK_IN            : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic;
  -- Status and control signals
  RESET             : in     std_logic;
  LOCKED            : out    std_logic
 );
end SysPLL_inferred;

architecture rtl of SysPLL_inferred is
 
begin

  CLK_OUT1 <= CLK_IN;
  LOCKED <= not RESET;

end rtl;
