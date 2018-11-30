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
library techmap;
use techmap.gencomp.all;
use techmap.types_mem.all;
library commonlib;
use commonlib.types_common.all;
--! AMBA system bus specific library
library ambalib;
--! AXI4 configuration constants.
use ambalib.types_amba4.all;

entity BootRom_tech is
generic (
    memtech : integer := 0;
    abits : integer := 12;
    sim_hexfile1 : string;  -- [63:32] rdata
    sim_hexfile0 : string   -- [31:0]  rdata

);
port (
    clk       : in std_logic;
    cs        : in std_logic;
    oe        : in std_logic;
    address   : in global_addr_array_type;
    data      : out std_logic_vector(CFG_NASTI_DATA_BITS-1 downto 0)
);
end;

architecture rtl of BootRom_tech is

  component BootRom_inferred is
  generic (
    abits : integer := 12;
    dbits : integer := 32;
    hex_filename : string
  );
  port (
    clk     : in  std_ulogic;
    address : in std_logic_vector(abits-1 downto 0);
    data    : out std_logic_vector(dbits-1 downto 0)
  );
  end component;

  component BootRom_mikron180 is
  port (
    clk     : in  std_logic;
    cs      : in std_logic;
    oe      : in std_logic;
    address : in global_addr_array_type;
    data    : out std_logic_vector(CFG_NASTI_DATA_BITS-1 downto 0)
  );
  end component;

begin

  genrom0 : if memtech = inferred or is_fpga(memtech) /= 0 generate
      inf1 : BootRom_inferred  generic map (abits-3, 32, sim_hexfile1)
             port map (clk, address(1)(abits-1 downto 3), data(63 downto 32));

      inf0 : BootRom_inferred  generic map (abits-3, 32, sim_hexfile0)
             port map (clk, address(0)(abits-1 downto 3), data(31 downto 0));
  end generate;

  genrom1 : if memtech = mikron180 generate
      mik180 : BootRom_mikron180 port map (clk, cs, oe, address, data);
  end generate;
end; 


