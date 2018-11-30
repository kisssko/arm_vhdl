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
use IEEE.STD_LOGIC_TEXTIO.ALL;
use std.textio.all;
library commonlib;
use commonlib.types_common.all;
--! AMBA system bus specific library.
library ambalib;
--! AXI4 configuration constants.
use ambalib.types_amba4.all;

entity BootRom_inferred is
  generic (
    abits : integer := 12;
    dbits : integer := 32;
    hex_filename : string
  );
  port (
    clk     : in  std_ulogic;
    address : in std_logic_vector(abits-1 downto 0);
    data    : out std_logic_vector(dbits-1 downto 0)
  );
end;

architecture rtl of BootRom_inferred is

constant WORDS_SIZE : integer := 2**abits;
type rom_type is array (0 to WORDS_SIZE-1) of std_logic_vector(dbits-1 downto 0);

impure function init_rom(file_name : in string) return rom_type is
    file rom_file : text open read_mode is file_name;
    variable rom_line : line;
    variable temp_bv : std_logic_vector(dbits-1 downto 0);
    variable temp_mem : rom_type;
begin
    for i in 0 to (WORDS_SIZE-1) loop
        readline(rom_file, rom_line);
        hread(rom_line, temp_bv);
        temp_mem(i) := temp_bv(dbits-1 downto 0);
    end loop;
    return temp_mem;
end function;

constant rom : rom_type := init_rom(hex_filename);

begin

  reg : process (clk) 
    variable t_adr : integer  range 0 to WORDS_SIZE-1;
  begin
    if rising_edge(clk) then 
        t_adr := conv_integer(address);
        data <= rom(t_adr);
    end if;
  end process;

end;
