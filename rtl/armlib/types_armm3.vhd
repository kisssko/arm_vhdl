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
use ieee.numeric_std.all;
library commonlib;
use commonlib.types_common.all;
library ambalib;
use ambalib.types_amba.all;

package types_armm3 is

  type jtag_in_type is record
    tdi : std_logic;       -- Test Data In. This is a signal specified in JTAG IEEE 1149.1 standard.
    tms : std_logic;       -- Serial Wire Data Input (DI) and JTAG TAP Test Mode Select (TMS)
    tck : std_logic;       -- unused
    ntrst : std_logic;     -- Tie-off to HIGH internally
  end record;

  type jtag_out_type is record
    tdo : std_logic;       -- Test Data Out. This is a signal specified in JTAG IEEE 1149.1 standard.
    ntdoen : std_logic;    -- JTAG data output enable. Active low.
    swdo : std_logic;      -- SW output data
    swdoen : std_logic;    -- SW data output enable, Switch TMS to 'Z' state in SW mode
    jtagnsw : std_logic;   -- jtag/not Serial Wire Mode
  end record;

  component interconnect is port (
    i_rstn   : in std_logic;
    i_clk    : in std_logic;
    i_ahbmo  : in  ahb_master_out_vector;
    o_ahbmi  : out ahb_master_in_vector;
    i_ahbso  : in  ahb_slave_out_vector;
    o_ahbsi  : out ahb_slave_in_vector;
    i_apbo   : in apb_out_vector;
    o_apbi   : out apb_in_vector
  );
  end component;

  component cortexm3 is port (
    i_rstn    : in std_logic;
    i_clk     : in std_logic;
    i_hicache : in  ahb_master_in_type;
    o_hicache : out ahb_master_out_type;
    i_hdcache : in  ahb_master_in_type;
    o_hdcache : out ahb_master_out_type;
    i_hsys    : in  ahb_master_in_type;
    o_hsys    : out ahb_master_out_type;
    i_jtag    : in jtag_in_type;
    o_jtag    : out jtag_out_type;
    i_irq     : in std_logic_vector(239 downto 0);
    i_nmi     : in std_logic
  );
  end component;

  component hsram is generic (
    aw : integer := 16
  );
  port (
    i_rstn    : in std_logic;
    i_clk     : in std_logic;
    i_ahbsi : in  ahb_slave_in_type;
    o_ahbso : out ahb_slave_out_type
  );
  end component;

  component hrom is generic (
    aw : integer := 16;
    init_file : string := ""
  );
  port (
    i_rstn    : in std_logic;
    i_clk     : in std_logic;
    i_ahbsi : in  ahb_slave_in_type;
    o_ahbso : out ahb_slave_out_type
  );
  end component;


end; -- package declaration

