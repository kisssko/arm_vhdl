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
library std;
use std.textio.all;
library commonlib;
use commonlib.types_util.all;

entity ml605_tb is
end ml605_tb;

architecture behavior of ml605_tb is

     -- input/output signals:
  signal i_rst : std_logic := '1';
  signal io_gpio : std_logic_vector(7 downto 0);
  signal i_uart1_rd : std_logic := '1';
  signal o_uart1_td : std_logic;
  signal i_uart2_rd : std_logic := '1';
  signal o_uart2_td : std_logic;
  signal i_flash_si : std_logic;
  signal o_flash_so : std_logic;
  signal o_flash_sck : std_logic;
  
  constant UART_BIN_SIZE : integer := 24;

  signal uart2_wr_str : std_logic;
  signal uart2_instr : string(1 to 256);
  signal uart2_busy : std_logic;
  signal uart2_bin_data : std_logic_vector(8*UART_BIN_SIZE-1 downto 0);
  signal uart2_bin_bytes_sz : integer;

  signal uart_wr_str : std_logic;
  signal uart_instr : string(1 to 256);
  signal uart_busy : std_logic;
  signal uart_bin_data : std_logic_vector(63 downto 0);
  signal uart_bin_bytes_sz : integer;

  signal jtag_test_ena : std_logic;
  signal jtag_test_burst : std_logic_vector(7 downto 0);
  signal jtag_test_addr : std_logic_vector(31 downto 0);
  signal jtag_test_we : std_logic;
  signal jtag_test_wdata : std_logic_vector(31 downto 0);
  signal jtag_tdi : std_logic;
  signal jtag_tdo : std_logic;
  signal jtag_tms : std_logic;
  signal jtag_tck : std_logic;
  signal jtag_ntrst : std_logic;

  signal clk_cur: std_logic := '1';
  signal clk_cur_n: std_logic := '0';
  signal check_clk_bus : std_logic := '0';
  signal iClkCnt : integer := 0;
  signal iErrCnt : integer := 0;
  signal iErrCheckedCnt : integer := 0;


  signal w_nrst : std_logic;
  
  component ml605_top is port 
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
  end component;
 
  component jtag_sim is 
  generic (
    clock_rate : integer := 10;
    irlen : integer := 4
  ); 
  port (
    rst : in std_logic;
    clk : in std_logic;
    i_test_ena : in std_logic;
    i_test_burst : in std_logic_vector(7 downto 0);
    i_test_addr : in std_logic_vector(31 downto 0);
    i_test_we : in std_logic;
    i_test_wdata : in std_logic_vector(31 downto 0);
    i_tdi  : in std_logic;
    o_tck : out std_logic;
    o_ntrst : out std_logic;
    o_tms : out std_logic;
    o_tdo : out std_logic
  );
  end component;


  component sim_uart_rx is
  generic (
    p_inst_num : integer := 0
    --p_uart_clk_half_period : time := 0.618 ns
  );
  port (
    rx : in std_logic;
    rst_n : in std_logic
  );
  end component;

  component uart_sim is 
  generic (
    clock_rate : integer := 10;
    binary_bytes_max : integer := 8;
    use_binary : boolean := false
  ); 
  port (
    rst : in std_logic;
    clk : in std_logic;
    wr_str : in std_logic;
    instr : in string;
    bin_data : in std_logic_vector(8*binary_bytes_max-1 downto 0);
    bin_bytes_sz : in integer;
    td  : in std_logic;
    rtsn : in std_logic;
    rd  : out std_logic;
    ctsn : out std_logic;
    busy : out std_logic
  );
  end component;

  component M25AA1024 is port (
     SI : in std_logic;
     SO : out std_logic;
     SCK : in std_logic;
     CS_N : in std_logic;
     WP_N : in std_logic;
     HOLD_N : in std_logic;
     RESET : in std_logic
  );
  end component;

begin

  clk_cur <= not clk_cur after 2.5 ns;
  clk_cur_n <= not clk_cur;


  procSignal : process (clk_cur, iClkCnt)

  begin
   -- if rising_edge(i_sclk_p) then
    if rising_edge( clk_cur) then
      iClkCnt <= iClkCnt + 1;
      --! @note to make sync. reset  of the logic that are clocked by
      --!       htif_clk which is clock/512 by default.
      if iClkCnt = 15 then
        i_rst <= '0';
      end if;
    end if;
  end process procSignal;

  io_gpio <= X"B1";
  w_nrst <= not i_rst;

  --udbggen0 : process (i_sclk_n, iClkCnt)
  udbggen0 : process (clk_cur, iClkCnt)
  begin
    --if rising_edge(i_sclk_n) then
    if falling_edge(clk_cur) then
        uart2_wr_str <= '0';
        if iClkCnt = 250000 then
           uart2_wr_str <= '1';
           -- read 8 bytes at address: 0x00000000.80090000 => 20 00 00 10.00 00 00 00
           uart2_bin_data(8*UART_BIN_SIZE-1 downto 8*(UART_BIN_SIZE-9)) <= X"81_0000098000000000";
           uart2_bin_bytes_sz <= 9;
        elsif iClkCnt = 26000 then
           uart2_wr_str <= '1';
           -- write 8 bytes at address: 0x00000000.0x00200020 => 20 00 00 10.00 00 00 00 <= 1 (SPI page buffer u64[4])
           uart2_bin_data(8*UART_BIN_SIZE-1 downto 8*(UART_BIN_SIZE-17)) <= X"C1_2000200000000000_1100000022000000";
           uart2_bin_bytes_sz <= 17;
        elsif iClkCnt = 330000 then
           uart2_wr_str <= '1';
           -- read 8 bytes at address: 0x00000000.80090000 => 20 00 00 10.00 00 00 00
           uart2_bin_data(8*UART_BIN_SIZE-1 downto 8*(UART_BIN_SIZE-9)) <= X"81_0000098000000000";
           uart2_bin_bytes_sz <= 9;
        end if;
    end if;
  end process;


  uartdbg0 : uart_sim generic map (
    clock_rate => (40000000/115200),
    binary_bytes_max => UART_BIN_SIZE,
    use_binary => true
  ) port map (
    rst => i_rst,
    clk => clk_cur,
    wr_str => uart2_wr_str,
    instr => uart2_instr,
    bin_data => uart2_bin_data,
    bin_bytes_sz => uart2_bin_bytes_sz,
    td  => o_uart2_td,
    rtsn => '0',
    rd  => i_uart2_rd,
    ctsn => open,
    busy => uart2_busy
  );


  --udatagen0 : process (i_sclk_n, iClkCnt)
  udatagen0 : process (clk_cur, iClkCnt)
  begin
    --if rising_edge(i_sclk_n) then
    if falling_edge(clk_cur) then
        uart_wr_str <= '0';
        if iClkCnt = 82000 then
           --uart_wr_str <= '1';
           uart_instr(1 to 4) <= "ping";
           uart_instr(5) <= cr;
           uart_instr(6) <= lf;
        elsif iClkCnt = 108000 then
           --uart_wr_str <= '1';
           uart_instr(1 to 3) <= "pnp";
           uart_instr(4) <= cr;
           uart_instr(5) <= lf;
        end if;

        jtag_test_ena <= '0';
        if iClkCnt = 3000 then
           jtag_test_ena <= '1';
           jtag_test_burst <= (others => '0');
           jtag_test_addr <= X"10000000";
           jtag_test_we <= '0';
           jtag_test_wdata <= (others => '0');
        elsif iClkCnt = 5000 then
           jtag_test_ena <= '1';
           jtag_test_burst <= (others => '0');
           jtag_test_addr <= X"fffff004";
           jtag_test_we <= '1';
           jtag_test_wdata <= X"12345678";
        elsif iClkCnt = 7000 then
           jtag_test_ena <= '1';
           jtag_test_burst <= X"01";
           jtag_test_addr <= X"10000004";
           jtag_test_we <= '0';
           jtag_test_wdata <= (others => '0');
        elsif iClkCnt = 10000 then
           jtag_test_ena <= '1';
           jtag_test_burst <= X"02";
           jtag_test_addr <= X"FFFFF004";
           jtag_test_we <= '1';
           jtag_test_wdata <= X"DEADBEEF";
       end if;    
    end if;
  end process;


  UART_RX : sim_uart_rx generic map (
      p_inst_num => 0
  ) port map (
      rx => o_uart1_td,
      rst_n => w_nrst--o_uart1_rtsn
  );


  flash0 : M25AA1024 port map (
     SI => o_flash_so,
     SO => i_flash_si,
     SCK => o_flash_sck,
     CS_N => '0',
     WP_N => '1',
     HOLD_N => '1',
     RESET => '0'
  );

  jsim0 : jtag_sim  generic map (
    clock_rate => 4,
    irlen => 4
  ) port map (
    rst => i_rst,
    clk => clk_cur,
    i_test_ena => jtag_test_ena,
    i_test_burst => jtag_test_burst,
    i_test_addr => jtag_test_addr,
    i_test_we => jtag_test_we,
    i_test_wdata => jtag_test_wdata,
    i_tdi => jtag_tdi,
    o_tck => jtag_tck,
    o_ntrst => jtag_ntrst,
    o_tms => jtag_tms,
    o_tdo => jtag_tdo 
  );

  -- signal parsment and assignment
  tt : ml605_top port map
  (
    i_rst     => i_rst,
    i_sclk_p  => clk_cur,
    i_sclk_n  => clk_cur_n,
    i_rst_ts  => '0',
    io_gpio   => io_gpio,
    i_uart1_rd   => i_uart1_rd,
    o_uart1_td   => o_uart1_td,
    i_uart2_rd   => i_uart2_rd,
    o_uart2_td   => o_uart2_td,
    i_flash_si => i_flash_si,
    o_flash_so => o_flash_so,
    o_flash_sck => o_flash_sck,
    i_jtag_tck => jtag_tck,
    i_jtag_ntrst => jtag_ntrst,
    i_jtag_tms => jtag_tms,
    i_jtag_tdi => jtag_tdo,
    o_jtag_tdo => jtag_tdi,
    o_jtag_vref => open
 );

end;
