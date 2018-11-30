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

--! Standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--! Data transformation and math functions library
library commonlib;
use commonlib.types_common.all;
library techmap;
use techmap.types_pll.all;
use techmap.types_buf.all;
library ambalib;
use ambalib.types_amba.all;
library armlib;
use armlib.types_armm3.all;

 --! Top-level implementaion library
library work;
--! Target dependable configuration: RTL, FPGA or ASIC.
use work.config_target.all;
--! Target independable configuration.
use work.config_common.all;

entity m3_soc is port 
( 
  --! Input reset. Active High. Usually assigned to button "Center".
  i_rst     : in std_logic;
  i_sclk_p  : in std_logic;
  i_sclk_n  : in std_logic;
  --! GPIOs
  i_user     : in std_logic_vector(7 downto 0);
  o_user     : out std_logic_vector(7 downto 0);
  o_user_dir : out std_logic_vector(7 downto 0);
  --! UART1 signals:
  i_uart1_rd   : in std_logic;
  o_uart1_td   : out std_logic;
  --! JTAG signals:
  i_jtag_tck : in std_logic;
  i_jtag_ntrst : in std_logic;
  i_jtag_tms : in std_logic;
  i_jtag_tdi : in std_logic;
  o_jtag_tdo : out std_logic;
  o_jtag_vref : out std_logic
);

end m3_soc;

architecture arch_m3_soc of m3_soc is

  signal w_ext_clk : std_logic;
  signal w_pll_clk : std_logic;
  signal w_pll_lock : std_logic;
  signal w_rstn : std_logic;

  signal wb_ahbmo  : ahb_master_out_vector;
  signal wb_ahbmi  : ahb_master_in_vector;
  signal wb_ahbso  : ahb_slave_out_vector;
  signal wb_ahbsi  : ahb_slave_in_vector;
  signal wb_apbo   : apb_out_vector;
  signal wb_apbi   : apb_in_vector;

  signal wb_jtagi : jtag_in_type;
  signal wb_jtago : jtag_out_type;

begin

  wb_ahbmo(CFG_HMST_RADIO) <= ahb_master_out_none;
  wb_ahbmo(CFG_HMST_EXTERNAL) <= ahb_master_out_none;
  
  wb_ahbso(CFG_HSLV_RADIO) <= ahb_slave_out_none;
  wb_ahbso(CFG_HSLV_EXTERNAL) <= ahb_slave_out_none;

  wb_apbo(0) <= apb_out_none;
  wb_apbo(1) <= apb_out_none;
  wb_apbo(2) <= apb_out_none;
  wb_apbo(3) <= apb_out_none;
  wb_apbo(4) <= apb_out_none;
  wb_apbo(5) <= apb_out_none;
  wb_apbo(6) <= apb_out_none;
  wb_apbo(7) <= apb_out_none;
  wb_apbo(8) <= apb_out_none;
  wb_apbo(9) <= apb_out_none;
  wb_apbo(10) <= apb_out_none;
  wb_apbo(11) <= apb_out_none;
  wb_apbo(12) <= apb_out_none;
  wb_apbo(13) <= apb_out_none;
  wb_apbo(14) <= apb_out_none;
  wb_apbo(15) <= apb_out_none;

  x1 : idsbuf_tech generic map (
     generic_tech => CFG_PADTECH
  ) port map (
     clk_p    => i_sclk_p,
     clk_n    => i_sclk_n,
     o_clk    => w_ext_clk
  );

  pll0 : SysPLL_tech generic map (
    tech => CFG_FABTECH
  ) port map (
    i_reset     => i_rst,
    i_clk_tcxo	=> w_ext_clk,
    o_clk_bus   => w_pll_clk,
    o_locked    => w_pll_lock
  );
  w_rstn <= (not i_rst) and w_pll_lock;


  ctrl0 : interconnect port map (
    i_rstn => w_rstn,
    i_clk => w_pll_clk,
    i_ahbmo => wb_ahbmo,
    o_ahbmi => wb_ahbmi,
    i_ahbso => wb_ahbso,
    o_ahbsi => wb_ahbsi,
    i_apbo => wb_apbo,
    o_apbi => wb_apbi
  );


  wb_jtagi.tck <= i_jtag_tck;
  wb_jtagi.ntrst <= i_jtag_ntrst;
  wb_jtagi.tms <= i_jtag_tms;
  wb_jtagi.tdi <= i_jtag_tdi;

  cpu0 : cortexm3 port map (
    i_rstn => w_rstn,
    i_clk => w_pll_clk,
    i_hicache => wb_ahbmi(CFG_HMST_ICACHE),
    o_hicache => wb_ahbmo(CFG_HMST_ICACHE),
    i_hdcache => wb_ahbmi(CFG_HMST_DCACHE),
    o_hdcache => wb_ahbmo(CFG_HMST_DCACHE),
    i_hsys    => wb_ahbmi(CFG_HMST_SYSTEM),
    o_hsys    => wb_ahbmo(CFG_HMST_SYSTEM),
    i_jtag    => wb_jtagi,
    o_jtag    => wb_jtago,
    i_irq => (others => '0'),
    i_nmi => '0'
  );
  
  o_jtag_tdo <= wb_jtago.tdo;
  o_jtag_vref <= '1';

  flash0 : hrom  generic map (
    aw => 15
  ) port map (
    i_rstn => w_rstn,
    i_clk  => w_pll_clk,
    i_ahbsi => wb_ahbsi(CFG_HSLV_FLASH),
    o_ahbso => wb_ahbso(CFG_HSLV_FLASH)
  );


  sram0 : hsram  generic map (
    aw => 15
  ) port map (
    i_rstn => w_rstn,
    i_clk  => w_pll_clk,
    i_ahbsi => wb_ahbsi(CFG_HSLV_SRAM0),
    o_ahbso => wb_ahbso(CFG_HSLV_SRAM0)
  );

  sram1 : hsram  generic map (
    aw => 15
  ) port map (
    i_rstn => w_rstn,
    i_clk  => w_pll_clk,
    i_ahbsi => wb_ahbsi(CFG_HSLV_SRAM1),
    o_ahbso => wb_ahbso(CFG_HSLV_SRAM1)
  );

  sram2 : hsram  generic map (
    aw => 15
  ) port map (
    i_rstn => w_rstn,
    i_clk  => w_pll_clk,
    i_ahbsi => wb_ahbsi(CFG_HSLV_SRAM2),
    o_ahbso => wb_ahbso(CFG_HSLV_SRAM2)
  );

  sram3 : hsram  generic map (
    aw => 15
  ) port map (
    i_rstn => w_rstn,
    i_clk  => w_pll_clk,
    i_ahbsi => wb_ahbsi(CFG_HSLV_SRAM3),
    o_ahbso => wb_ahbso(CFG_HSLV_SRAM3)
  );

end arch_m3_soc;
