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
library techmap;

entity hrom is generic (
    aw : integer := 16;
    init_file : string := ""
);
port (
    i_rstn    : in std_logic;
    i_clk     : in std_logic;
    i_ahbsi : in  ahb_slave_in_type;
    o_ahbso : out ahb_slave_out_type
);
end;
architecture rtl of hrom is
	COMPONENT cmsdk_ahb_to_sram IS GENERIC (
		AW : integer := 16
        );
	PORT(
		HCLK : IN std_logic;
		HRESETn : IN std_logic;
		HSEL : IN std_logic;
		HREADY : IN std_logic;
		HTRANS : IN std_logic_vector(1 downto 0);
		HSIZE : IN std_logic_vector(2 downto 0);
		HWRITE : IN std_logic;
		HADDR : IN std_logic_vector(AW-1 downto 0);
		HWDATA : IN std_logic_vector(31 downto 0);
		SRAMRDATA : IN std_logic_vector(31 downto 0);          
		HREADYOUT : OUT std_logic;
		HRESP : OUT std_logic;
		HRDATA : OUT std_logic_vector(31 downto 0);
		SRAMADDR : OUT std_logic_vector(AW-3 downto 0);
		SRAMWEN : OUT std_logic_vector(3 downto 0);
		SRAMWDATA : OUT std_logic_vector(31 downto 0);
		SRAMCS : OUT std_logic
		);
	END COMPONENT;
	
  component cmsdk_fpga_sram is generic (
    AW : integer := 16;
    MEMFILE : string := "image.hex"
  );
  port (
    CLK : in std_logic;
    ADDR : in std_logic_vector(AW-1 downto 0);
    WDATA : in std_logic_vector(31 downto 0);
    WREN : in std_logic_vector(3 downto 0);
    CS : in std_logic;
    RDATA : out std_logic_vector(31 downto 0)
  );
  end component;

  component sram32_inferred_init is
  generic (
    abits     : integer := 12;
    init_file : string
  );
  port (
    clk     : in  std_ulogic;
    address : in  std_logic_vector(abits-1 downto 0);
    rdata   : out std_logic_vector(31 downto 0);
    we      : in  std_logic;
    wdata   : in  std_logic_vector(31 downto 0)
  );
  end component;

  signal wb_rdata : std_logic_vector(31 downto 0);          
  signal wb_addr : std_logic_vector(aw-3 downto 0);
  signal wb_wstrb : std_logic_vector(3 downto 0);
  signal wb_wdata : std_logic_vector(31 downto 0);
  signal w_cs : std_logic;

begin

--  wb_rdata <= X"cafef00d";

	inst0 : cmsdk_ahb_to_sram generic map (
		AW => aw
        ) port map (
		HCLK => i_clk,
		HRESETn => i_rstn,
		HSEL => i_ahbsi.hsel,
		HREADY => i_ahbsi.hreadymux,
		HTRANS => i_ahbsi.htrans,
		HSIZE => i_ahbsi.hsize,
		HWRITE => i_ahbsi.hwrite,
		HADDR => i_ahbsi.haddr(aw-1 downto 0),
		HWDATA => i_ahbsi.hwdata,
		HREADYOUT => o_ahbso.hready,
		HRESP => o_ahbso.hresp,
		HRDATA => o_ahbso.hrdata,

		SRAMRDATA => wb_rdata,
		SRAMADDR => wb_addr,
		SRAMWEN => wb_wstrb,
		SRAMWDATA => wb_wdata,
		SRAMCS => w_cs
		);
		
  mem0 : sram32_inferred_init generic map (
    abits => aw-2,
    init_file => init_file
  ) port map (
    clk => i_clk,
    address => wb_addr,
    wdata => wb_wdata,
    we => '0',
    rdata => wb_rdata
  );
  
end;

