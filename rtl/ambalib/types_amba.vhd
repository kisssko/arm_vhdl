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

package types_amba is

constant CFG_HMST_ICACHE   : integer := 0;
constant CFG_HMST_DCACHE   : integer := 1;
constant CFG_HMST_SYSTEM   : integer := 2;
constant CFG_HMST_RADIO    : integer := 3;
constant CFG_HMST_EXTERNAL : integer := 4;
constant CFG_HMST_TOTAL    : integer := 5;

constant CFG_HSLV_RADIO    : integer := 0;
constant CFG_HSLV_EXTERNAL : integer := 1;
constant CFG_HSLV_FLASH    : integer := 2;
constant CFG_HSLV_SRAM0    : integer := 3;
constant CFG_HSLV_SRAM1    : integer := 4;
constant CFG_HSLV_SRAM2    : integer := 5;
constant CFG_HSLV_SRAM3    : integer := 6;
constant CFG_HSLV_TOTAL    : integer := 7;

constant CFG_PSLV_TOTAL    : integer := 16;

type ahb_master_out_type is record
  HADDR : std_logic_vector(31 downto 0);   -- address
  HTRANS : std_logic_vector(1 downto 0);   -- transfer type
  HMASTER : std_logic_vector(3 downto 0);  -- master (-> Bus MTX)
  HSIZE : std_logic_vector(2 downto 0);    -- transfer size
  hmastlock : std_logic;                   -- lock
  HBURST : std_logic_vector(2 downto 0);   -- burst type
  HPROT : std_logic_vector(3 downto 0);    -- protection control
  HWDATA : std_logic_vector(31 downto 0);  -- write data
  HWRITE : std_logic;                      -- write not read
  HAUSER : std_logic;                      -- HAUSER
  HWUSER : std_logic_vector(3 downto 0);   -- HWUSER
  MEMATTR : std_logic_vector(1 downto 0);  -- memory attributes (-> logic -> Bus MTX)
  EXREQ : std_logic;                       -- exclusive request
end record;

constant ahb_master_out_none : ahb_master_out_type := (
  (others => '0'), -- haddr
  (others => '0'), -- htrans
  (others => '0'), -- hmaster
  (others => '0'), -- hsize
  '0', -- hmastlock
  (others => '0'), -- hburst
  (others => '0'), -- hprot
  (others => '0'), -- hwdata
  '0', -- hwrite
  '0', -- hauser
  (others => '0'), -- hwuser
  (others => '0'), -- memattr
  '0' -- exreq
);

type ahb_master_out_vector is array (0 to CFG_HMST_TOTAL-1) 
       of ahb_master_out_type;


type ahb_master_in_type is record
  hrdata : std_logic_vector(31 downto 0);  -- read data
  hready : std_logic;                      -- transfer completed
  hresp : std_logic_vector(1 downto 0);    -- response status
  hruser : std_logic_vector(2 downto 0);
  exresp : std_logic;                      -- exclusive response
end record;

constant ahb_master_in_none : ahb_master_in_type := (
  (others => '0'), -- hrdata
  '0', -- hready
  (others => '0'), -- hresp
  (others => '0'), -- hruser
  '0' -- exresp
);

type ahb_master_in_vector is array (0 to CFG_HMST_TOTAL-1) 
       of ahb_master_in_type;


type ahb_slave_in_type is record
  hsel : std_logic;                        -- select
  hreadymux : std_logic;                   -- ready
  haddr : std_logic_vector(31 downto 0);   -- address
  htrans : std_logic_vector(1 downto 0);   -- transfer type
  hmaster : std_logic_vector(3 downto 0);  -- master (-> Bus MTX)
  hsize : std_logic_vector(2 downto 0);    -- transfer size
  hmastlock : std_logic;                   -- lock
  hburst : std_logic_vector(2 downto 0);   -- burst type
  hprot : std_logic_vector(3 downto 0);    -- protection control
  hwdata : std_logic_vector(31 downto 0);  -- write data
  hwrite : std_logic;                      -- write not read
  hauser : std_logic;                      -- HAUSER
  hwuser : std_logic_vector(3 downto 0);   -- HWUSER
  memattr : std_logic_vector(1 downto 0);  -- memory attributes (-> logic -> Bus MTX)
  exreq : std_logic;                       -- exclusive request
end record;

constant ahb_slave_in_none : ahb_slave_in_type := (
  '0', -- hsel
  '0', -- hreadymux
  (others => '0'), -- haddr
  (others => '0'), -- htrans
  (others => '0'), -- hmaster
  (others => '0'), -- hsize
  '0', -- hmastlock
  (others => '0'), -- hburst
  (others => '0'), -- hprot
  (others => '0'), -- hwdata
  '0', -- hwrite
  '0', -- hauser
  (others => '0'), -- hwuser
  (others => '0'), -- memattr
  '0' -- exreq
);

type ahb_slave_in_vector is array (0 to CFG_HSLV_TOTAL-1) 
       of ahb_slave_in_type;


type ahb_slave_out_type is record
  hrdata : std_logic_vector(31 downto 0);  -- read data
  hready : std_logic;                      -- transfer completed
  hresp : std_logic;                       -- response status
  hruser : std_logic_vector(2 downto 0);
  exresp : std_logic;                      -- exclusive response
end record;

constant ahb_slave_out_none : ahb_slave_out_type := (
  (others => '0'), -- hrdata
  '0', -- hready
  '0', -- hresp
  (others => '0'), -- hruser
  '0' -- exresp
);

type ahb_slave_out_vector is array (0 to CFG_HSLV_TOTAL-1) 
       of ahb_slave_out_type;



type apb_in_type is record
  PADDR : std_logic_vector(11 downto 0);  -- APB Address
  PENABLE : std_logic;                    -- APB Enable
  PWRITE : std_logic;                     -- APB Write
  PSTRB : std_logic_vector(3 downto 0);   -- APB Byte Strobe
  PPROT : std_logic_vector(2 downto 0);   -- APB Prot
  PWDATA : std_logic_vector(31 downto 0); -- APB write data
  PSEL : std_logic;                       -- APB Select
end record;

constant apb_in_none : apb_in_type := (
  (others => '0'), -- paddr
  '0', -- penable
  '0', -- pwrite
  (others => '0'), -- pstrb
  (others => '0'), -- pprot
  (others => '0'), -- pwdata
  '0' -- psel
);

type apb_in_vector is array (0 to CFG_PSLV_TOTAL-1) 
       of apb_in_type;


type apb_out_type is record
  prdata : std_logic_vector(31 downto 0);  -- read data
  pready : std_logic;                      -- transfer completed
  slverr : std_logic;                      -- slave error
end record;

constant apb_out_none : apb_out_type := (
  (others => '0'), '0', '0'
);

type apb_out_vector is array (0 to CFG_PSLV_TOTAL-1) 
       of apb_out_type;


end; -- package declaration

package body types_amba is
end; -- package body

