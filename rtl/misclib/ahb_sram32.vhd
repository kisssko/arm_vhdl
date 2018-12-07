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

library techmap;
use techmap.gencomp.all;
use techmap.types_mem.all;

library commonlib;
use commonlib.types_common.all;

--! AMBA system bus specific library.
library ambalib;
use ambalib.types_amba.all;


entity ahb_sram32 is
  generic (
    memtech  : integer := inferred;
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
end; 
 
architecture arch_ahb_sram32 of ahb_sram32 is

  type registers is record
    addr : std_logic_vector(abits-3 downto 0);
    wstrb : std_logic_vector(3 downto 0);
    hit : std_logic;
    data : std_logic_vector(31 downto 0);
    pend : std_logic;
    ahb_read : std_logic;
    ahb_write : std_logic;
  end record; 

  type ram_in_type is record
    raddr : std_logic_vector(abits-3 downto 0);
    waddr : std_logic_vector(abits-3 downto 0);
    we    : std_logic;
    wstrb : std_logic_vector(3 downto 0);
    wdata : std_logic_vector(31 downto 0);
  end record;

signal r, rin : registers;
signal rami : ram_in_type;
signal wb_rdata : std_logic_vector(31 downto 0);

begin

  comblogic : process(i, r, wb_rdata)
    variable v : registers;
    variable vrami : ram_in_type;
    variable ahb_access : std_logic;
    variable tx_byte : std_logic;
    variable tx_half : std_logic;
    variable tx_word : std_logic;
    variable byte_at_00 : std_logic;
    variable byte_at_01 : std_logic;
    variable byte_at_10 : std_logic;
    variable byte_at_11 : std_logic;
    variable half_at_00 : std_logic;
    variable half_at_10 : std_logic;
    variable word_at_00 : std_logic;
    variable byte_sel : std_logic_vector(3 downto 0);
  begin

    v := r;

   ahb_access   := i.htrans(1) and i.hsel;-- and i.hreadymux;
   v.ahb_write    := ahb_access and  i.hwrite;
   v.ahb_read     := ahb_access and (not i.hwrite);

   -- Stored write data in pending state if new transfer is read
   --   buf_data_en indicate new write (data phase)
   --   ahb_read    indicate new read  (address phase)
   --   buf_pend    is registered version of buf_pend_nxt
   v.pend := (r.pend or r.ahb_write) and v.ahb_read;

   vrami.we := (r.pend or r.ahb_write) and (not v.ahb_read);
   vrami.wstrb := (vrami.we and r.wstrb(3)) & (vrami.we and r.wstrb(2)) &
                  (vrami.we and r.wstrb(1)) & (vrami.we and r.wstrb(0));

   vrami.raddr := i.haddr(abits-1 downto 2);
   vrami.waddr := r.addr;

   ----------------------------------------------------------
   -- Byte lane decoder and next state logic
   ----------------------------------------------------------

   tx_byte    := (not i.hsize(1)) and (not i.hsize(0));
   tx_half    := (not i.hsize(1)) and  i.hsize(0);
   tx_word    := i.hsize(1);

   byte_at_00 := tx_byte and (not i.haddr(1)) and (not i.haddr(0));
   byte_at_01 := tx_byte and (not i.haddr(1)) and i.haddr(0);
   byte_at_10 := tx_byte and i.haddr(1) and (not i.haddr(0));
   byte_at_11 := tx_byte and i.haddr(1) and i.haddr(0);
   half_at_00 := tx_half and (not i.haddr(1));
   half_at_10 := tx_half and i.haddr(1);
   word_at_00 := tx_word;

   byte_sel(0) := word_at_00 or half_at_00 or byte_at_00;
   byte_sel(1) := word_at_00 or half_at_00 or byte_at_01;
   byte_sel(2) := word_at_00 or half_at_10 or byte_at_10;
   byte_sel(3) := word_at_00 or half_at_10 or byte_at_11;

   -- Address phase byte lane strobe
   v.wstrb := (byte_sel(3) and v.ahb_write) &
           (byte_sel(2) and v.ahb_write) &
           (byte_sel(1) and v.ahb_write) &
           (byte_sel(0) and v.ahb_write);

   v.addr := i.haddr(abits-1 downto 2);
   if r.ahb_write = '1' then
       if r.wstrb(3) = '1' then
           v.data(31 downto 24) := i.hwdata(31 downto 24);
       end if;
       if r.wstrb(2) = '1' then
           v.data(23 downto 16) := i.hwdata(23 downto 16);
       end if;
       if r.wstrb(1) = '1' then
           v.data(15 downto 8) := i.hwdata(15 downto 8);
       end if;
       if r.wstrb(0) = '1' then
           v.data(7 downto 0) := i.hwdata(7 downto 0);
       end if;
   end if;

   if r.pend = '1' then
       vrami.wdata := r.data ;
   else 
       vrami.wdata := i.hwdata;
   end if;


   v.hit := '0';
   if i.haddr(abits-1 downto 2) = r.addr and v.ahb_read = '1' then
       v.hit := '1';
   end if;


   if r.hit = '1' and r.wstrb(3) = '1' then
       o.hrdata(31 downto 24) <= r.data(31 downto 24);
   else
       o.hrdata(31 downto 24) <= wb_rdata(31 downto 24);
   end if;

   if r.hit = '1' and r.wstrb(2) = '1' then
       o.hrdata(23 downto 16) <= r.data(23 downto 16);
   else
       o.hrdata(23 downto 16) <= wb_rdata(23 downto 16);
   end if;

   if r.hit = '1' and r.wstrb(1) = '1' then
       o.hrdata(15 downto 8) <= r.data(15 downto 8);
   else
       o.hrdata(15 downto 8) <= wb_rdata(15 downto 8);
   end if;

   if r.hit = '1' and r.wstrb(0) = '1' then
       o.hrdata(7 downto 0) <= r.data(7 downto 0);
   else
       o.hrdata(7 downto 0) <= wb_rdata(7 downto 0);
   end if;

  
    rami <= vrami;
    rin <= v;
  end process;


  o.hready <= r.ahb_read or r.ahb_write;
  o.hresp  <= '1';
  o.hruser <= (others => '0');
  o.exresp <= '0';
  
  tech0 : srambytes_tech generic map (
    memtech   => memtech,
    abits     => abits-2,
    init_file => init_file
  ) port map (
    clk     => clk,
    raddr   => rami.raddr,
    rdata   => wb_rdata,
    waddr   => rami.waddr,
    we      => rami.we,
    wstrb   => rami.wstrb,
    wdata   => rami.wdata
  );

  -- registers:
  regs : process(clk, nrst)
  begin
     if nrst = '0' then
         r.addr <= (others => '0');
         r.wstrb <= (others => '0');
         r.hit <= '0';
         r.data <= (others => '0');
         r.pend <= '0';
         r.ahb_read <= '0';
         r.ahb_write <= '0';
     elsif rising_edge(clk) then 
        r <= rin;
     end if; 
  end process;

end;
