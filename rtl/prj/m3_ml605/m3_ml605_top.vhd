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
  i_rst_ts : in std_logic;  -- Reset Timer: active HIGH
  io_gpio   : inout std_logic_vector(7 downto 0);
  --! UART1 signals:
  i_uart1_rd   : in std_logic;
  o_uart1_td   : out std_logic;
  --! UART2 (TAP) signals:
  i_uart2_rd   : in std_logic;
  o_uart2_td   : out std_logic;
  --! SPI Flash
  i_flash_si : in std_logic;
  o_flash_so : out std_logic;
  o_flash_sck : out std_logic;
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
  component riscv_soc is port ( 
    i_rst         : in std_logic;
    i_sclk        : in std_logic;
    i_rst_ts      : in std_logic;  -- Reset Timer: active HIGH
    i_user        : in std_logic_vector(7 downto 0);
    o_user        : out std_logic_vector(7 downto 0);
    o_user_dir    : out std_logic_vector(7 downto 0);
    i_uart1_ctsn  : in std_logic;
    i_uart1_rd    : in std_logic;
    o_uart1_td    : out std_logic;
    o_uart1_rtsn  : out std_logic;
    i_uart2_ctsn  : in std_logic;
    i_uart2_rd    : in std_logic;
    o_uart2_td    : out std_logic;
    o_uart2_rtsn  : out std_logic;
    i_flash_si    : in std_logic;
    o_flash_so    : out std_logic;
    o_flash_sck   : out std_logic;
    o_flash_csn   : out std_logic;
    o_flash_wpn   : out std_logic;
    o_flash_holdn : out std_logic;
    o_flash_reset : out std_logic;
    i_jtag_tck : in std_logic;
    i_jtag_ntrst : in std_logic;
    i_jtag_tms : in std_logic;
    i_jtag_tdi : in std_logic;
    o_jtag_tdo : out std_logic;
    o_jtag_vref : out std_logic;   
    i_otp_spi_ck : in std_logic;
    i_otp_spi_si : in std_logic;
    o_otp_spi_so : out std_logic;
    o_rf_re: out std_logic;
    o_rf_we: out std_logic;
    o_rf_addr: out std_logic_vector(7 downto 0);
    o_rf_wdata: out std_logic_vector(31 downto 0);
    i_rf_rdata: in std_logic_vector(31 downto 0); 
    i_rf_irq: in std_logic
  );
  end component;

  component rf_tech is
  generic (
    tech    : integer range 0 to NTECH := 0
  );
  port
  (
    FPGA_RST : in std_logic;
    FPGA_CLKP : in std_logic;
    FPGA_CLKN : in std_logic;

    CLK_OUT  : out std_logic;
    GREAT_CLR : out std_logic;
    IRQ_REQUEST: out std_logic;
    LOAD : out std_logic;
    RE: in std_logic;
    WE: in std_logic;
    A : in std_logic_vector(7 downto 0);
    D : inout std_logic_vector(31 downto 0)
  );
  end component;

  signal w_sys_rst : std_logic;
  signal w_sys_clk : std_logic;

  signal ob_gpio_direction : std_logic_vector(7 downto 0);
  signal ob_gpio_opins    : std_logic_vector(7 downto 0);
  signal ib_gpio_ipins     : std_logic_vector(7 downto 0);
  signal ib_rst_ts     : std_logic;
  signal ib_uart1_rd    : std_logic;
  signal ob_uart1_td    : std_logic;
  signal ib_uart2_rd    : std_logic;
  signal ob_uart2_td    : std_logic;
  signal ib_flash_si    : std_logic;
  signal ob_flash_so    : std_logic;
  signal ob_flash_sck   : std_logic;
  --! JTAG signals:
  signal ib_jtag_tck    : std_logic;
  signal ib_jtag_ntrst  : std_logic;
  signal ib_jtag_tms    : std_logic;
  signal ib_jtag_tdi    : std_logic;
  signal ob_jtag_tdo    : std_logic;
  --! To analog core signals:
  signal w_rf_re :  std_logic;
  signal w_rf_we :  std_logic;
  signal wb_rf_addr :  std_logic_vector(7 downto 0);
  signal wb_rf_wdata :  std_logic_vector(31 downto 0);   
  signal wb_rf_rdata :  std_logic_vector(31 downto 0);
  signal wb_rf_data :  std_logic_vector(31 downto 0);   
  signal w_rf_irq :  std_logic;

begin

  rf0 : rf_tech generic map (
    tech => CFG_FABTECH
  ) port map (
    FPGA_RST => i_rst,
    FPGA_CLKP => i_sclk_p,
    FPGA_CLKN => i_sclk_n,
    CLK_OUT => w_sys_clk,
    GREAT_CLR  => w_sys_rst,
    RE => w_rf_re,
    WE => w_rf_we,
    A => wb_rf_addr,
    D => wb_rf_data,
    IRQ_REQUEST => w_rf_irq
  );

  gpiox : for i in 0 to 7 generate
    iob   : iobuf_tech generic map(CFG_PADTECH) 
            port map (ib_gpio_ipins(i), io_gpio(i), ob_gpio_opins(i), ob_gpio_direction(i));
  end generate;

  its0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_rst_ts, i_rst_ts);

  ird1 : ibuf_tech generic map(CFG_PADTECH) port map (ib_uart1_rd, i_uart1_rd);
  otd1 : obuf_tech generic map(CFG_PADTECH) port map (o_uart1_td, ob_uart1_td);

  ird2 : ibuf_tech generic map(CFG_PADTECH) port map (ib_uart2_rd, i_uart2_rd);
  otd2 : obuf_tech generic map(CFG_PADTECH) port map (o_uart2_td, ob_uart2_td);

  isi0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_flash_si, i_flash_si);
  oso0 : obuf_tech generic map(CFG_PADTECH) port map (o_flash_so, ob_flash_so);
  osck0 : obuf_tech generic map(CFG_PADTECH) port map (o_flash_sck, ob_flash_sck);

  --! JTAG signals:
  ijtck0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_jtag_tck, i_jtag_tck);
  ijtrst0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_jtag_ntrst, i_jtag_ntrst);
  ijtms0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_jtag_tms, i_jtag_tms);
  ijtdi0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_jtag_tdi, i_jtag_tdi);
  ojtdo0 : obuf_tech generic map(CFG_PADTECH) port map (o_jtag_tdo, ob_jtag_tdo);

  wb_rf_rdata <= wb_rf_data;
  rdatx : for i in 0 to 31 generate
    zb : zbuf_tech generic map(CFG_PADTECH) 
            port map (wb_rf_data(i), wb_rf_wdata(i), w_rf_we);
  end generate;
  
  soc0 : riscv_soc port map ( 
    i_rst => w_sys_rst,
    i_sclk => w_sys_clk,
    i_user => ib_gpio_ipins,
    o_user => ob_gpio_opins,
    o_user_dir => ob_gpio_direction,
    i_rst_ts => ib_rst_ts,
    i_uart1_ctsn => '0',
    i_uart1_rd => ib_uart1_rd,
    o_uart1_td => ob_uart1_td,
    o_uart1_rtsn => open,
    i_uart2_ctsn => '0',
    i_uart2_rd => ib_uart2_rd,
    o_uart2_td => ob_uart2_td,
    o_uart2_rtsn => open,
    i_flash_si => ib_flash_si,
    o_flash_so => ob_flash_so,
    o_flash_sck => ob_flash_sck,
    o_flash_csn => open,
    o_flash_wpn => open,
    o_flash_holdn => open,
    o_flash_reset => open,
    i_jtag_tck => ib_jtag_tck,
    i_jtag_ntrst => ib_jtag_ntrst,
    i_jtag_tms => ib_jtag_tms,
    i_jtag_tdi => ib_jtag_tdi,
    o_jtag_tdo => ob_jtag_tdo,
    o_jtag_vref => o_jtag_vref,   
    i_otp_spi_ck => '0',
    i_otp_spi_si => '0',
    o_otp_spi_so => open,
    o_rf_re => w_rf_re,
    o_rf_we => w_rf_we,
    o_rf_addr => wb_rf_addr,
    o_rf_wdata => wb_rf_wdata,
    i_rf_rdata => wb_rf_rdata,
    i_rf_irq => w_rf_irq
  );

end arch_m3_ml605_top;
