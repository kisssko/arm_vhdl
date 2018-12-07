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

library commonlib;
use commonlib.types_common.all;

library techmap;
use techmap.gencomp.all;
use techmap.types_mem.all;

--! AMBA system bus specific library.
library ambalib;
--! AXI4 configuration constants.
use ambalib.types_amba.all;

entity srambytes_tech is
generic (
    memtech : integer := 0;
    abits   : integer := 16;
    init_file : string := ""
);
port (
    clk       : in std_logic;
    raddr     : in std_logic_vector(abits-1 downto 0);
    rdata     : out std_logic_vector(31 downto 0);
    waddr     : in std_logic_vector(abits-1 downto 0);
    we        : in std_logic;
    wstrb     : in std_logic_vector(3 downto 0);
    wdata     : in std_logic_vector(31 downto 0)
);
end;

architecture rtl of srambytes_tech is

signal address : std_logic_vector(abits-1 downto 0);
signal wr_ena : std_logic_vector(3 downto 0);

  --! @brief   Declaration of the one-byte SRAM element.
  --! @details This component is used for the FPGA implementation.
  component sram8_inferred is
  generic (
     abits : integer := 12;
     byte_idx : integer := 0
  );
  port (
    clk     : in  std_ulogic;
    address : in  std_logic_vector(abits-1 downto 0);
    rdata   : out std_logic_vector(7 downto 0);
    we      : in  std_logic;
    wdata   : in  std_logic_vector(7 downto 0)
  );
  end component;

  --! @brief   Declaration of the one-byte SRAM element with init function.
  --! @details This component is used for the RTL simulation.
  component sram8_inferred_init is
  generic (
     abits     : integer := 12;
     byte_idx  : integer := 0;
     init_file : string
  );
  port (
    clk     : in  std_ulogic;
    address : in  std_logic_vector(abits-1 downto 0);
    rdata   : out std_logic_vector(7 downto 0);
    we      : in  std_logic;
    wdata   : in  std_logic_vector(7 downto 0)
  );
  end component;


begin


  --! inferred memory model compatible with fpga
  inf0 : if memtech = inferred or is_fpga(memtech) /= 0 generate
    address <= waddr when we = '1' else raddr;

    rx : for n in 0 to 3 generate
      wr_ena(n) <= we and wstrb(n);

      x0 : sram8_inferred_init generic map 
      (
          abits => abits,
          byte_idx => n,
          init_file => init_file
      ) port map (
          clk, 
          address => address,
          rdata => rdata(8*(n+1)-1 downto 8*n),
          we => wr_ena(n), 
          wdata => wdata(8*(n+1)-1 downto 8*n)
      );
    end generate; -- cycle
  end generate; -- tech=inferred

end; 


