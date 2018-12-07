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

--! Technology definition library.
library techmap;
--! Technology constants definition.
use techmap.gencomp.all;
--! "Virtual" PLL declaration.
use techmap.types_pll.all;
--! "Virtual" buffers declaration.
use techmap.types_buf.all;

 --! Top-level implementaion library
library work;
--! Target dependable configuration: RTL, FPGA or ASIC.
use work.config_target.all;
--! Target independable configuration.
use work.config_common.all;

entity m3_ml605_top is port 
( 
  i_rst     : in std_logic;
  i_sclk_p  : in std_logic;
  i_sclk_n  : in std_logic;
  io_gpio   : inout std_logic_vector(7 downto 0);
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
end m3_ml605_top;

architecture arch_m3_ml605_top of m3_ml605_top is
  component m3_soc is port ( 
    i_rstn     : in std_logic;
    i_sclk     : in std_logic;
    i_user     : in std_logic_vector(7 downto 0);
    o_user     : out std_logic_vector(7 downto 0);
    o_user_dir : out std_logic_vector(7 downto 0);
    i_uart1_rd   : in std_logic;
    o_uart1_td   : out std_logic;
    i_jtag_tck : in std_logic;
    i_jtag_ntrst : in std_logic;
    i_jtag_tms : in std_logic;
    i_jtag_tdi : in std_logic;
    o_jtag_tdo : out std_logic;
    o_jtag_vref : out std_logic
  );
  end component;

  signal w_ext_clk : std_logic;
  signal w_pll_clk : std_logic;
  signal w_pll_lock : std_logic;

  signal ob_gpio_direction : std_logic_vector(7 downto 0);
  signal ob_gpio_opins    : std_logic_vector(7 downto 0);
  signal ib_gpio_ipins     : std_logic_vector(7 downto 0);
  signal ib_uart1_rd    : std_logic;
  signal ob_uart1_td    : std_logic;
  --! JTAG signals:
  signal ib_jtag_tck    : std_logic;
  signal ib_jtag_ntrst  : std_logic;
  signal ib_jtag_tms    : std_logic;
  signal ib_jtag_tdi    : std_logic;
  signal ob_jtag_tdo    : std_logic;

begin

  gpiox : for i in 0 to 7 generate
    iob   : iobuf_tech generic map(CFG_PADTECH) 
            port map (ib_gpio_ipins(i), io_gpio(i), ob_gpio_opins(i), ob_gpio_direction(i));
  end generate;

  ird1 : ibuf_tech generic map(CFG_PADTECH) port map (ib_uart1_rd, i_uart1_rd);
  otd1 : obuf_tech generic map(CFG_PADTECH) port map (o_uart1_td, ob_uart1_td);

  --! JTAG signals:
  ijtck0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_jtag_tck, i_jtag_tck);
  ijtrst0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_jtag_ntrst, i_jtag_ntrst);
  ijtms0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_jtag_tms, i_jtag_tms);
  ijtdi0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_jtag_tdi, i_jtag_tdi);
  ojtdo0 : obuf_tech generic map(CFG_PADTECH) port map (o_jtag_tdo, ob_jtag_tdo);


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
 
  soc0 : m3_soc port map ( 
    i_rstn => w_pll_lock,
    i_sclk => w_pll_clk,
    i_user => ib_gpio_ipins,
    o_user => ob_gpio_opins,
    o_user_dir => ob_gpio_direction,
    i_uart1_rd => ib_uart1_rd,
    o_uart1_td => ob_uart1_td,
    i_jtag_tck => ib_jtag_tck,
    i_jtag_ntrst => ib_jtag_ntrst,
    i_jtag_tms => ib_jtag_tms,
    i_jtag_tdi => ib_jtag_tdi,
    o_jtag_tdo => ob_jtag_tdo,
    o_jtag_vref => o_jtag_vref
  );

end arch_m3_ml605_top;
