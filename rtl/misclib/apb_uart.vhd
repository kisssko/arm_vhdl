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
--! AMBA system bus specific library.
library ambalib;
use ambalib.types_amba.all;
library misclib;
use misclib.types_misc.all;

entity apb_uart is
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
end; 
 
architecture arch_apb_uart of apb_uart is

  type fifo_type is array (0 to fifosz-1) of std_logic_vector(7 downto 0);
  type state_type is (idle, startbit, data, parity, stopbit);

  type bank_type is record
        tx_state  : state_type;
        tx_fifo   : fifo_type;
        tx_wr_cnt : std_logic_vector(log2(fifosz)-1 downto 0);
        tx_rd_cnt : std_logic_vector(log2(fifosz)-1 downto 0);
        tx_byte_cnt : std_logic_vector(log2(fifosz)-1 downto 0);
        tx_shift  : std_logic_vector(10 downto 0); --! stopbit=1,parity=xor,data[7:0],startbit=0
        tx_data_cnt : integer range 0 to 11;
        tx_scaler_cnt : integer;
        tx_level : std_logic;
        tx_irq_thresh : std_logic_vector(log2(fifosz)-1 downto 0);
        tx_less_thresh : std_logic_vector(1 downto 0);
        tx_was_data : std_logic;

        rx_state  : state_type;
        rx_fifo   : fifo_type;
        rx_wr_cnt : std_logic_vector(log2(fifosz)-1 downto 0);
        rx_rd_cnt : std_logic_vector(log2(fifosz)-1 downto 0);
        rx_byte_cnt : std_logic_vector(log2(fifosz)-1 downto 0);
        rx_shift  : std_logic_vector(7 downto 0);
        rx_data_cnt : integer range 0 to 7;
        rx_scaler_cnt : integer;
        rx_level : std_logic;
        rx_irq_thresh : std_logic_vector(log2(fifosz)-1 downto 0);
        rx_more_thresh : std_logic_vector(1 downto 0);

        scaler : integer;
        err_parity : std_logic;
        err_stopbit : std_logic;
        parity_bit : std_logic;
        tx_irq_ena : std_logic;
        rx_irq_ena : std_logic;
        tx_irq_pending : std_logic;
        rx_irq_pending : std_logic;
  end record;

  type registers is record
    read_enable : std_logic;
    write_enable : std_logic;
    addr : std_logic_vector(9 downto 0);
    bank0 : bank_type;
    tx_write_cnt1 : integer;
    tx_write_cnt2 : integer;
  end record;

signal r, rin : registers;

begin

  comblogic : process(i_rx, i_apb, r)
    variable v : registers;
    variable rdata : std_logic_vector(31 downto 0);

    variable posedge_flag : std_logic;
    variable negedge_flag : std_logic;
    variable tx_fifo_empty : std_logic;
    variable tx_fifo_full : std_logic;
    variable rx_fifo_empty : std_logic;
    variable rx_fifo_full : std_logic;
    variable t_tx, t_rx : std_logic_vector(7 downto 0);
    variable par : std_logic;
  begin

    v := r;

    -- Check FIFOs counters with thresholds:
    v.bank0.tx_less_thresh := r.bank0.tx_less_thresh(0) & '0';
    if (r.bank0.tx_byte_cnt <= r.bank0.tx_irq_thresh) and r.bank0.tx_was_data = '1' then
      v.bank0.tx_was_data := '0';
      v.bank0.tx_less_thresh(0) := '1';
    end if;

    v.bank0.rx_more_thresh := r.bank0.rx_more_thresh(0) & '0';
    if r.bank0.rx_byte_cnt > r.bank0.rx_irq_thresh then
      v.bank0.rx_more_thresh(0) := '1';
    end if;
    
    if (r.bank0.tx_less_thresh(1) and not r.bank0.tx_less_thresh(0)) = '1' then
       v.bank0.tx_irq_pending := r.bank0.tx_irq_ena;
    end if;
    if (not r.bank0.rx_more_thresh(1) and r.bank0.rx_more_thresh(0)) = '1' then
       v.bank0.rx_irq_pending := r.bank0.rx_irq_ena;
    end if;
    
    -- system bus clock scaler to baudrate:
    posedge_flag := '0';
    negedge_flag := '0';
    if r.bank0.scaler /= 0 then
	     v.bank0.tx_scaler_cnt := r.bank0.tx_scaler_cnt + 1;
        if v.bank0.tx_scaler_cnt = r.bank0.scaler then
            v.bank0.tx_scaler_cnt := 0;
            v.bank0.tx_level := not r.bank0.tx_level;
            posedge_flag := not r.bank0.tx_level;
        end if;

        if r.bank0.rx_state = idle and i_rx = '1' then
            v.bank0.rx_scaler_cnt := 0;
            v.bank0.rx_level := '1';
        elsif r.bank0.rx_scaler_cnt = (r.bank0.scaler-1) then
            v.bank0.rx_scaler_cnt := 0;
            v.bank0.rx_level := not r.bank0.rx_level;
            negedge_flag := r.bank0.rx_level;
        else
            v.bank0.rx_scaler_cnt := r.bank0.rx_scaler_cnt + 1;
        end if;
    end if;

    -- Transmitter's FIFO:
    tx_fifo_full := '0';
    if (r.bank0.tx_wr_cnt + 1) = r.bank0.tx_rd_cnt then
        tx_fifo_full := '1';
    end if;
    tx_fifo_empty := '0';
    if r.bank0.tx_rd_cnt = r.bank0.tx_wr_cnt then
        tx_fifo_empty := '1';
        v.bank0.tx_byte_cnt := (others => '0');
    end if;

    -- Receiver's FIFO:
    rx_fifo_full := '0';
    if (r.bank0.rx_wr_cnt + 1) = r.bank0.rx_rd_cnt then
        rx_fifo_full := '1';
    end if;
    rx_fifo_empty := '0';
    if r.bank0.rx_rd_cnt = r.bank0.rx_wr_cnt then
        rx_fifo_empty := '1';
        v.bank0.rx_byte_cnt := (others => '0');
    end if;

    -- Transmitter's state machine:
    if posedge_flag = '1' then
        case r.bank0.tx_state is
        when idle =>
            if tx_fifo_empty = '0' then
                -- stopbit=1,parity=xor,data[7:0],startbit=0
                t_tx := r.bank0.tx_fifo(conv_integer(r.bank0.tx_rd_cnt));
                if r.bank0.parity_bit = '1' then
                    par := t_tx(7) xor t_tx(6) xor t_tx(5) xor t_tx(4)
                         xor t_tx(3) xor t_tx(2) xor t_tx(1) xor t_tx(0);
                    v.bank0.tx_shift := '1' & par & t_tx & '0';
                else
                    v.bank0.tx_shift := "11" & t_tx & '0';
                end if;
                
                v.bank0.tx_state := startbit;
                v.bank0.tx_rd_cnt := r.bank0.tx_rd_cnt + 1;
                v.bank0.tx_byte_cnt := r.bank0.tx_byte_cnt - 1;
                v.bank0.tx_data_cnt := 0;
            end if;
        when startbit =>
            v.bank0.tx_state := data;
        when data =>
            if r.bank0.tx_data_cnt = 8 then
                if r.bank0.parity_bit = '1' then
                    v.bank0.tx_state := parity;
                else
                    v.bank0.tx_state := stopbit;
                end if;
            end if;
        when parity =>
            v.bank0.tx_state := stopbit;
        when stopbit =>
            v.bank0.tx_state := idle;
        when others =>
        end case;
        
        if r.bank0.tx_state /= idle then
            v.bank0.tx_data_cnt := r.bank0.tx_data_cnt + 1;
            v.bank0.tx_shift := '1' & r.bank0.tx_shift(10 downto 1);
        end if;
    end if;

    --! Receiver's state machine:
    if negedge_flag = '1' then
        case r.bank0.rx_state is
        when idle =>
            if i_rx = '0' then
                v.bank0.rx_state := data;
                v.bank0.rx_shift := (others => '0');
                v.bank0.rx_data_cnt := 0;
            end if;
        when data =>
            v.bank0.rx_shift := i_rx & r.bank0.rx_shift(7 downto 1);
            if r.bank0.rx_data_cnt = 7 then
                if r.bank0.parity_bit = '1' then
                    v.bank0.rx_state := parity;
                else
                    v.bank0.rx_state := stopbit;
                end if;
            else
                v.bank0.rx_data_cnt := r.bank0.rx_data_cnt + 1;
            end if;
        when parity =>
            t_rx := r.bank0.rx_shift;
            par := t_rx(7) xor t_rx(6) xor t_rx(5) xor t_rx(4)
               xor t_rx(3) xor t_rx(2) xor t_rx(1) xor t_rx(0);
            if par = i_rx then
                v.bank0.err_parity := '0';
            else 
                v.bank0.err_parity := '1';
            end if;
            v.bank0.rx_state := stopbit;
        when stopbit =>
            if i_rx = '0' then
                v.bank0.err_stopbit := '1';
            else
                v.bank0.err_stopbit := '0';
            end if;
            if rx_fifo_full = '0' then
                v.bank0.rx_fifo(conv_integer(r.bank0.rx_wr_cnt)) := r.bank0.rx_shift;
                v.bank0.rx_wr_cnt := r.bank0.rx_wr_cnt + 1;
                v.bank0.rx_byte_cnt := r.bank0.rx_byte_cnt + 1;
            end if;
            v.bank0.rx_state := idle;
        when others =>
        end case;
    end if;


    if r.bank0.tx_state = idle then
        o_tx <= '1';
    else
        o_tx <= r.bank0.tx_shift(0);
    end if;

    v.read_enable  := i_apb.psel and (not i_apb.pwrite); -- assert for whole APB read transfer
    v.write_enable := i_apb.psel and (not i_apb.penable) and i_apb.pwrite; -- assert for 1st cycle of write transfer

    if v.read_enable = '1' or v.write_enable = '1' then
        v.addr := i_apb.paddr(11 downto 2);
    end if;

    rdata := (others => '0');
    
    case r.addr is
    when "0000000000" =>  -- [0x00]
       rdata(1 downto 0) := tx_fifo_empty & tx_fifo_full;
       rdata(5 downto 4) := rx_fifo_empty & rx_fifo_full;
       rdata(9 downto 8) := r.bank0.err_stopbit & r.bank0.err_parity;
       rdata(13) := r.bank0.rx_irq_ena;
       rdata(14) := r.bank0.tx_irq_ena;
       rdata(15) := r.bank0.parity_bit;
    when "0000000001" =>  -- [0x04]
       rdata := conv_std_logic_vector(r.bank0.scaler,32);
    when "0000000010" => -- [0x08] Reserved
    when "0000000011" => -- [0x0C] Reserved
    when "0000000100" => -- [0x10]
       if rx_fifo_empty = '0' then
           rdata(7 downto 0) := r.bank0.rx_fifo(conv_integer(r.bank0.rx_rd_cnt)); 
           v.bank0.rx_rd_cnt := r.bank0.rx_rd_cnt + 1;
           v.bank0.rx_byte_cnt := r.bank0.rx_byte_cnt - 1;
       end if;
    when "0000000101" => -- [0x14] Reserved

    -- Debug Tx via JTAG
    when "0000000110" => -- [0x18]
       rdata := conv_std_logic_vector(r.tx_write_cnt1, 32);
    when "0000000111" => -- [0x1C]
       rdata := conv_std_logic_vector(r.tx_write_cnt2, 32);
    when "0000001000" => -- [0x20]
       rdata(log2(fifosz)-1 downto 0) := r.bank0.tx_wr_cnt;
    when "0000001001" => -- [0x24]
       rdata(log2(fifosz)-1 downto 0) := r.bank0.tx_byte_cnt;
    when "0000001010" => -- [0x28]
       rdata(10 downto 0) := r.bank0.tx_shift; --! stopbit=1,parity=xor,data[7:0],startbit=0
    when "0000001011" => -- [0x2C]
       rdata(3 downto 0) := conv_std_logic_vector(r.bank0.tx_data_cnt, 4);
    when "0000001100" => -- [0x30]
       rdata := conv_std_logic_vector(r.bank0.tx_scaler_cnt, 32);
    when others =>
    end case;


    if r.write_enable = '1' then

       case r.addr is
       when "0000000000" => -- [0x00]
             v.bank0.parity_bit := i_apb.pwdata(15);
             v.bank0.tx_irq_ena := i_apb.pwdata(14);
             v.bank0.rx_irq_ena := i_apb.pwdata(13);
             v.bank0.tx_irq_pending := not i_apb.pwdata(11) and r.bank0.tx_irq_pending;
             v.bank0.rx_irq_pending := not i_apb.pwdata(10) and r.bank0.rx_irq_pending;
       when "0000000001" => -- [0x04]
             v.bank0.scaler := conv_integer(i_apb.pwdata);
             v.bank0.rx_scaler_cnt := 0;
             v.bank0.tx_scaler_cnt := 0;
       when "0000000010" => -- [0x08] Reserved
       when "0000000011" => -- [0x0C] Reserved
       when "0000000100" => -- [0x10]
             v.tx_write_cnt1 := r.tx_write_cnt1 + 1;
             if tx_fifo_full = '0' then
                 v.tx_write_cnt2 := r.tx_write_cnt1 + 2;

                 v.bank0.tx_fifo(conv_integer(r.bank0.tx_wr_cnt)) := i_apb.pwdata(7 downto 0);
                 v.bank0.tx_wr_cnt := r.bank0.tx_wr_cnt + 1;
                 v.bank0.tx_byte_cnt := r.bank0.tx_byte_cnt + 1;
                 if r.bank0.tx_byte_cnt = r.bank0.tx_irq_thresh then
                     v.bank0.tx_was_data := '1';
                 end if;
             end if;
       when others =>
       end case;
    end if;

    o_apb.pready <= r.read_enable or r.write_enable;
    o_apb.prdata <= rdata;
    o_apb.slverr <= '0';
    o_rxirq <= r.bank0.rx_irq_pending;
    o_txirq <= r.bank0.tx_irq_pending;
    rin <= v;
  end process;

  -- registers:
  regs : process(nrst, clk)
  begin
     if nrst = '0' then
        r.read_enable <= '0';
        r.write_enable <= '0';
        r.addr <= (others => '0');
        r.bank0.tx_state <= idle;
        r.bank0.tx_level <= '0';
        r.bank0.tx_scaler_cnt <= 0;
        r.bank0.tx_rd_cnt <= (others => '0');
        r.bank0.tx_wr_cnt <= (others => '0');
        r.bank0.tx_byte_cnt <= (others => '0');
        r.bank0.tx_irq_thresh <= (others => '0');
        r.bank0.tx_less_thresh <= (others => '0');
        r.bank0.tx_was_data <= '0';

        r.bank0.rx_state <= idle;
        r.bank0.rx_level <= '1';
        r.bank0.rx_scaler_cnt <= 0;
        r.bank0.rx_rd_cnt <= (others => '0');
        r.bank0.rx_wr_cnt <= (others => '0');
        r.bank0.rx_byte_cnt <= (others => '0');
        r.bank0.rx_irq_thresh <= (others => '0');
        r.bank0.rx_more_thresh <= (others => '0');

        r.bank0.scaler <= 0;
        r.bank0.err_parity <= '0';
        r.bank0.err_stopbit <= '0';
        r.bank0.parity_bit <= '0';
        r.bank0.tx_irq_ena <= '0';
        r.bank0.rx_irq_ena <= '0';
        r.bank0.tx_irq_pending <= '0';
        r.bank0.rx_irq_pending <= '0';
        r.tx_write_cnt1 <= 0;
        r.tx_write_cnt2 <= 0;
     elsif rising_edge(clk) then 
        r <= rin;
     end if; 
  end process;

end;