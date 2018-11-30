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


entity iobuf_tech is
  generic
  (
    generic_tech : integer := 0
  );
  port (
    o  : out std_logic;
    io : inout std_logic;
    i  : in std_logic;
    t  : in std_logic
  );
end; 
 
architecture rtl of iobuf_tech is

component iobuf_inferred is
  port (
    o  : out std_logic;
    io : inout std_logic;
    i  : in std_logic;
    t  : in std_logic
  );
end component; 

component iobuf_virtex6 is
  port (
    o  : out std_logic;
    io : inout std_logic;
    i  : in std_logic;
    t  : in std_logic
  );
end component; 

component iobuf_mikron180 is
  port (
    o  : out std_logic;
    io : inout std_logic;
    i  : in std_logic;
    t  : in std_logic
  );
end component; 

begin

  inf0 : if generic_tech = inferred generate 
    bufinf : iobuf_inferred port map
    (
      o => o,
      io => io,
      i => i,
      t => t
    );
  end generate;

  xv6 : if generic_tech = virtex6 or generic_tech = kintex7  or generic_tech = zynq7000 generate 
    bufv6 : iobuf_virtex6 port map
    (
      o => o,
      io => io,
      i => i,
      t => t
    );
  end generate;

  m180 : if generic_tech = mikron180 generate 
    bufm : iobuf_mikron180 port map
    (
      o => o,
      io => io,
      i => i,
      t => t
    );
  end generate;

end;
