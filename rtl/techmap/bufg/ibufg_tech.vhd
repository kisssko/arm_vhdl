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

entity ibufg_tech is
  generic
  (
    tech : integer := 0
  );
  port (
    O    : out std_ulogic;
    I    : in std_ulogic
    );
end;

architecture rtl of ibufg_tech is

  component ibufg_xilinx is
  port (
    O    : out std_ulogic;
    I    : in std_ulogic
    );
  end component;
  signal w_o : std_logic;
begin


   inf : if tech = inferred generate
      w_o <= I;
   end generate;

   xlnx : if tech = virtex6 or tech = kintex7 generate
      x0 : ibufg_xilinx port map (
        O  => w_o,
        I  => I
      );
   end generate;

   O <= w_o;

end;  
