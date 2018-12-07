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
library work;
use work.types_armm3.all;

entity cortexm3 is port (
    i_rstn    : in std_logic;
    i_clk     : in std_logic;
    i_hicache : in  ahb_master_in_type;
    o_hicache : out ahb_master_out_type;
    i_hdcache : in  ahb_master_in_type;
    o_hdcache : out ahb_master_out_type;
    i_hsys    : in  ahb_master_in_type;
    o_hsys    : out ahb_master_out_type;
    i_jtag    : in jtag_in_type;
    o_jtag    : out jtag_out_type;
    i_irq     : in std_logic_vector(239 downto 0);
    i_nmi     : in std_logic
);
end;
architecture rtl of cortexm3 is
	COMPONENT CORTEXM3INTEGRATIONDS
	PORT(
		ISOLATEn : IN std_logic;
		RETAINn : IN std_logic;
		nTRST : IN std_logic;
		SWCLKTCK : IN std_logic;
		SWDITMS : IN std_logic;
		TDI : IN std_logic;
		PORESETn : IN std_logic;
		SYSRESETn : IN std_logic;
		RSTBYPASS : IN std_logic;
		CGBYPASS : IN std_logic;
		FCLK : IN std_logic;
		HCLK : IN std_logic;
		TRACECLKIN : IN std_logic;
		STCLK : IN std_logic;
		STCALIB : IN std_logic_vector(25 downto 0);
		AUXFAULT : IN std_logic_vector(31 downto 0);
		BIGEND : IN std_logic;
		INTISR : IN std_logic_vector(239 downto 0);
		INTNMI : IN std_logic;
		HREADYI : IN std_logic;
		HRDATAI : IN std_logic_vector(31 downto 0);
		HRESPI : IN std_logic_vector(1 downto 0);
		IFLUSH : IN std_logic;
		HREADYD : IN std_logic;
		HRDATAD : IN std_logic_vector(31 downto 0);
		HRESPD : IN std_logic_vector(1 downto 0);
		EXRESPD : IN std_logic;
		SE : IN std_logic;
		HREADYS : IN std_logic;
		HRDATAS : IN std_logic_vector(31 downto 0);
		HRESPS : IN std_logic_vector(1 downto 0);
		EXRESPS : IN std_logic;
		EDBGRQ : IN std_logic;
		DBGRESTART : IN std_logic;
		RXEV : IN std_logic;
		SLEEPHOLDREQn : IN std_logic;
		WICENREQ : IN std_logic;
		FIXMASTERTYPE : IN std_logic;
		TSVALUEB : IN std_logic_vector(47 downto 0);
		MPUDISABLE : IN std_logic;
		DBGEN : IN std_logic;
		NIDEN : IN std_logic;
		CDBGPWRUPACK : IN std_logic;
		DNOTITRANS : IN std_logic;          
		TDO : OUT std_logic;
		nTDOEN : OUT std_logic;
		SWDOEN : OUT std_logic;
		SWDO : OUT std_logic;
		SWV : OUT std_logic;
		JTAGNSW : OUT std_logic;
		TRACECLK : OUT std_logic;
		TRACEDATA : OUT std_logic_vector(3 downto 0);
		HTRANSI : OUT std_logic_vector(1 downto 0);
		HSIZEI : OUT std_logic_vector(2 downto 0);
		HADDRI : OUT std_logic_vector(31 downto 0);
		HBURSTI : OUT std_logic_vector(2 downto 0);
		HPROTI : OUT std_logic_vector(3 downto 0);
		MEMATTRI : OUT std_logic_vector(1 downto 0);
		HTRANSD : OUT std_logic_vector(1 downto 0);
		HSIZED : OUT std_logic_vector(2 downto 0);
		HADDRD : OUT std_logic_vector(31 downto 0);
		HBURSTD : OUT std_logic_vector(2 downto 0);
		HPROTD : OUT std_logic_vector(3 downto 0);
		MEMATTRD : OUT std_logic_vector(1 downto 0);
		HMASTERD : OUT std_logic_vector(1 downto 0);
		EXREQD : OUT std_logic;
		HWRITED : OUT std_logic;
		HWDATAD : OUT std_logic_vector(31 downto 0);
		HTRANSS : OUT std_logic_vector(1 downto 0);
		HSIZES : OUT std_logic_vector(2 downto 0);
		HADDRS : OUT std_logic_vector(31 downto 0);
		HBURSTS : OUT std_logic_vector(2 downto 0);
		HPROTS : OUT std_logic_vector(3 downto 0);
		MEMATTRS : OUT std_logic_vector(1 downto 0);
		HMASTERS : OUT std_logic_vector(1 downto 0);
		EXREQS : OUT std_logic;
		HWRITES : OUT std_logic;
		HWDATAS : OUT std_logic_vector(31 downto 0);
		HMASTLOCKS : OUT std_logic;
		BRCHSTAT : OUT std_logic_vector(3 downto 0);
		HALTED : OUT std_logic;
		LOCKUP : OUT std_logic;
		SLEEPING : OUT std_logic;
		SLEEPDEEP : OUT std_logic;
		ETMINTNUM : OUT std_logic_vector(8 downto 0);
		ETMINTSTAT : OUT std_logic_vector(2 downto 0);
		SYSRESETREQ : OUT std_logic;
		TXEV : OUT std_logic;
		TRCENA : OUT std_logic;
		CURRPRI : OUT std_logic_vector(7 downto 0);
		DBGRESTARTED : OUT std_logic;
		SLEEPHOLDACKn : OUT std_logic;
		GATEHCLK : OUT std_logic;
		HTMDHADDR : OUT std_logic_vector(31 downto 0);
		HTMDHTRANS : OUT std_logic_vector(1 downto 0);
		HTMDHSIZE : OUT std_logic_vector(2 downto 0);
		HTMDHBURST : OUT std_logic_vector(2 downto 0);
		HTMDHPROT : OUT std_logic_vector(3 downto 0);
		HTMDHWDATA : OUT std_logic_vector(31 downto 0);
		HTMDHWRITE : OUT std_logic;
		HTMDHRDATA : OUT std_logic_vector(31 downto 0);
		HTMDHREADY : OUT std_logic;
		HTMDHRESP : OUT std_logic_vector(1 downto 0);
		WICENACK : OUT std_logic;
		WAKEUP : OUT std_logic;
		CDBGPWRUPREQ : OUT std_logic
		);
	END COMPONENT;

	COMPONENT m3ds_tscnt_48 PORT (
	  	clk : in std_logic;
	  	resetn : in std_logic;
	  	enablecnt_i : in std_logic;
	  	tsvalueb_o : out std_logic_vector(47 downto 0)
	  	);
	END COMPONENT;

  signal w_dbg_powerup : std_logic;
  signal wb_stcalib : std_logic_vector(25 downto 0);
  signal w_trcena : std_logic;  -- trace enable
  signal w_enablecnt : std_logic; -- enable timestamp counter
  signal w_cpuhalted : std_logic; -- CPU is halted
  signal wb_timestamp_cnt : std_logic_vector(47 downto 0);
begin

  -- SysTick Calibration for 25 MHz FCLK (STCLK is an enable, must be synchronous to FCLK or tied)
  wb_stcalib(25)   <= '1';              -- No alternative clock source
  wb_stcalib(24)   <= '0';              -- Exact multiple of 10ms from FCLK
  wb_stcalib(23 downto 0) <= X"03D08F"; -- calibration value for 25 MHz source

	inst0: CORTEXM3INTEGRATIONDS PORT MAP(
		ISOLATEn => '1',  -- isolate core power domain
		RETAINn => '1',   -- retain core state during power-down
                -- Debug
		nTRST => i_jtag.ntrst,
		SWCLKTCK => i_jtag.tck,
		SWDITMS => i_jtag.tms,
		TDI => i_jtag.tdi,
		TDO => o_jtag.tdo,
		nTDOEN => o_jtag.ntdoen,
		SWDOEN => o_jtag.swdoen,
		SWDO => o_jtag.swdo,
		SWV => open,  -- SingleWire Viewer Data
		JTAGNSW => o_jtag.jtagnsw,

		CDBGPWRUPREQ => w_dbg_powerup, -- Debug power up request
		CDBGPWRUPACK => w_dbg_powerup,  -- Debug power up acknowledge

		PORESETn => i_rstn,
		SYSRESETn => i_rstn,
		RSTBYPASS => '0',
		CGBYPASS => '0',
		FCLK => i_clk,  -- Free running clock
		HCLK => i_clk,  -- system clock
		TRACECLKIN => i_clk, -- TPIU trace port clock
		STCLK => '1',  -- system tick clock: 1=No alternative clock source
		STCALIB => wb_stcalib,
		AUXFAULT => X"00000000", -- Auxillary FSR pulse inputs
		BIGEND => '0', -- Peripherals in this system do not support BIGEND
		INTISR => (others => '0'),
		INTNMI => '0',
		IFLUSH => '0',  -- reserved input
		SE => '0',  -- DFT
		EDBGRQ => '0',   -- debug request
		DBGRESTART => '0',   -- external debug restart request: not need in a single CPU
		RXEV => '0',
		SLEEPHOLDREQn => '1',
		FIXMASTERTYPE => '0',
		TSVALUEB => wb_timestamp_cnt,   -- timestamp for debug
		MPUDISABLE => '0',              -- Tie high to emulate processor with no MPU
		DBGEN => '1',                   -- enable for halting Debug
		NIDEN => '1',                   -- Must be high to access non-invasive debug
		DNOTITRANS => '1',              -- Must be HIGH is code mux is used
		TRCENA => w_trcena,
		TRACECLK => open,               -- TRACECLK output
		TRACEDATA => open,              -- Trace Data

                -- AHB I-Code bus
		HREADYI => i_hicache.hready,
		HRDATAI => i_hicache.hrdata,
		HRESPI => i_hicache.hresp,
		HTRANSI => o_hicache.htrans,
		HSIZEI => o_hicache.hsize,
		HADDRI => o_hicache.haddr,
		HBURSTI => o_hicache.hburst,
		HPROTI => o_hicache.hprot,
		MEMATTRI => o_hicache.memattr,

                -- AHB D-Code bus
		HREADYD => i_hdcache.hready,
		HRDATAD => i_hdcache.hrdata,
		HRESPD => i_hdcache.hresp,
		EXRESPD => i_hdcache.exresp,
		HTRANSD => o_hdcache.htrans,
		HSIZED => o_hdcache.hsize,
		HADDRD => o_hdcache.haddr,
		HBURSTD => o_hdcache.hburst,
		HPROTD => o_hdcache.hprot,
		MEMATTRD => o_hdcache.memattr,
		HMASTERD => o_hdcache.hmaster(1 downto 0),
		EXREQD => o_hdcache.exreq,
		HWRITED => o_hdcache.hwrite,
		HWDATAD => o_hdcache.hwdata,

		HREADYS => i_hsys.hready,
		HRDATAS => i_hsys.hrdata,
		HRESPS => i_hsys.hresp,
		EXRESPS => i_hsys.exresp,
		HTRANSS => o_hsys.htrans,
		HSIZES => o_hsys.hsize,
		HADDRS => o_hsys.haddr,
		HBURSTS => o_hsys.hburst,
		HPROTS => o_hsys.hprot,
		MEMATTRS => o_hsys.memattr,
		HMASTERS => o_hsys.hmaster(1 downto 0),
		EXREQS => o_hsys.exreq,
		HWRITES => o_hsys.hwrite,
		HWDATAS => o_hsys.hwdata,
		HMASTLOCKS => o_hsys.hmastlock,

		BRCHSTAT => open,              -- encoded state of the branch instruction
		HALTED => w_cpuhalted,
		LOCKUP => open,                -- Indicates that the core is locked up.
		SLEEPING => open,              -- Indicated that the processor is in sleep mode (sleep mode)
		SLEEPDEEP => open,             -- Indicates that the processor is in deep sleep mode
		ETMINTNUM => open,             -- Marks the interrupt number of the current execution context
		ETMINTSTAT => open,            -- Interrupt status. Marks interrupt status of current cycle: 0b000 - no status; 0b001 - interrupt entry ..
		SYSRESETREQ => open,           -- System Reset Request
		TXEV => open,                  -- Transmit Event
		CURRPRI => open,
		DBGRESTARTED => open,          -- Not used here in single core system
		SLEEPHOLDACKn => open,         -- Not used without power management
		GATEHCLK => open,
		HTMDHADDR => open,  -- HTM not used in typical systems
		HTMDHTRANS => open,
		HTMDHSIZE => open,
		HTMDHBURST => open,
		HTMDHPROT => open,
		HTMDHWDATA => open,
		HTMDHWRITE => open,
		HTMDHRDATA => open,
		HTMDHREADY => open,
		HTMDHRESP => open,

		WICENREQ => '0',  -- Active HIGH request for deep sleep to be WIC-based deep sleep. This should be driven from a PMU.
		WICENACK => open,
		WAKEUP => open    -- Active HIGH signal to the PMU that indicates a wake-up event has occurred and the system requires clocks and power
	);

  -- ETM timestamp counter
  w_enablecnt <= w_trcena and (not w_cpuhalted);

  ts0: m3ds_tscnt_48 port map (
    clk         => i_clk,
    resetn      => i_rstn,
    enablecnt_i => w_enablecnt,
    tsvalueb_o  => wb_timestamp_cnt
  );

end;

