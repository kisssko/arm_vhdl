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

library ieee;
use ieee.std_logic_1164.all;
Library UNISIM;
use UNISIM.vcomponents.all;


entity iobuf_virtex6 is
  port (
    o  : out std_logic;
    io : inout std_logic;
    i  : in std_logic;
    t  : in std_logic
  );
end; 
 
architecture rtl of iobuf_virtex6 is

begin


  io_inst : IOBUF generic map
  (
    DRIVE => 12,
    IOSTANDARD => "DEFAULT",
    SLEW => "SLOW"
  ) port map
  (
    O => o,
    IO => io,
    I => i,
    T => t
  );


end;
