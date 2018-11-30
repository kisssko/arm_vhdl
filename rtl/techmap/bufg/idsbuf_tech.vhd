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

entity idsbuf_tech is
  generic (
    generic_tech : integer := 0
  );
  port (
    clk_p : in std_logic;
    clk_n : in std_logic;
    o_clk  : out std_logic
  );
end; 
 
architecture rtl of idsbuf_tech is

  component idsbuf_xilinx is
  port (
    clk_p : in std_logic;
    clk_n : in std_logic;
    o_clk  : out std_logic
  );
  end component; 


begin

  infer : if generic_tech = inferred generate 
      o_clk <= clk_p;
  end generate;

  xil0 : if generic_tech = virtex6 or generic_tech = kintex7 generate 
      x1 : idsbuf_xilinx port map (
         clk_p => clk_p,
         clk_n => clk_n,
         o_clk  => o_clk
      );
  end generate;


end;
