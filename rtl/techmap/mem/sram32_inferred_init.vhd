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
use ieee.numeric_std.ALL;
USE ieee.numeric_bit.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

library std;
use std.textio.all;

library commonlib;
use commonlib.types_common.all;

entity sram32_inferred_init is
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
end;

architecture arch_sram32_inferred_init of sram32_inferred_init is


constant SRAM_LENGTH : integer := 2**abits;
constant FILE_IMAGE_LINES_TOTAL : integer := SRAM_LENGTH;
type ram_type is array (0 to SRAM_LENGTH-1) of std_logic_vector(31 downto 0);

impure function init_ram(file_name : in string) return ram_type is
    file ram_file : text open read_mode is file_name;
    variable ram_line : line;
    variable temp_bv : std_logic_vector(31 downto 0);
    variable temp_mem : ram_type;
begin
    for i in 0 to (FILE_IMAGE_LINES_TOTAL-1) loop
        readline(ram_file, ram_line);
        hread(ram_line, temp_bv);
        temp_mem(i) := temp_bv(31 downto 0);
    end loop;
    return temp_mem;
end function;

impure function init_ram_bin(file_name : in string) return ram_type is
    TYPE t_char_file IS FILE OF character;
    file ram_file : t_char_file open read_mode is file_name;
    variable ram_line : line;
    variable temp_bv : std_logic_vector(7 downto 0);
    variable temp_mem : ram_type;
    variable v_char : character;
    variable adr_cnt : integer := 0;
begin
    while not endfile(ram_file) loop
        read(ram_file, v_char);
        for i in 0 to 7 loop --
          temp_bv(i) := to_unsigned(character'POS(v_char),8)(i);
        end loop;
        case conv_std_logic_vector(adr_cnt,32)(1 downto 0) is
        when "00" =>  temp_mem(adr_cnt/4)(7 downto 0) := temp_bv;
        when "01" =>  temp_mem(adr_cnt/4)(15 downto 8) := temp_bv;
        when "10" =>  temp_mem(adr_cnt/4)(23 downto 16) := temp_bv;
        when "11" =>  temp_mem(adr_cnt/4)(31 downto 24) := temp_bv;
        when others => 
        end case;
        adr_cnt := adr_cnt + 1;
    end loop;
    return temp_mem;
end function;

--! @warning SIMULATION INITIALIZATION
signal ram : ram_type := init_ram_bin(init_file);
signal adr : std_logic_vector(abits-1 downto 0);

begin

  reg : process (clk, address, wdata) begin
    if rising_edge(clk) then 
      if we = '1' then
        ram(conv_integer(address)) <= wdata;
      end if;
      adr <= address;
    end if;
  end process;

  rdata <= ram(conv_integer(adr));
end;
