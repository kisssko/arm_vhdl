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
library ambalib;
use ambalib.types_amba.all;

package types_misc is

component ahb_sram32 is
  generic (
    memtech  : integer := 0;
    haddr    : integer := 0;
    hmask    : integer := 16#fffff#;
    abits    : integer := 17;
    init_file : string := ""
  );
  port (
    clk  : in std_logic;
    nrst : in std_logic;
    i    : in  ahb_slave_in_type;
    o    : out ahb_slave_out_type
  );
end component;


component apb_uart is
  generic (
    paddr   : integer := 0;
    pmask   : integer := 16#fffff#;
    pirq    : integer := 0;
    fifosz  : integer := 16
  );
  port (
    clk    : in  std_logic;
    nrst   : in  std_logic;
    i_rx : in std_logic;
    o_tx : out std_logic;
    i_apb  : in  apb_in_type;
    o_apb  : out apb_out_type;
    o_rxirq : out std_logic;
    o_txirq : out std_logic
  );
end component;

end;
