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

entity interconnect is port (
    i_rstn   : in std_logic;
    i_clk    : in std_logic;
    i_ahbmo  : in  ahb_master_out_vector;
    o_ahbmi  : out ahb_master_in_vector;
    i_ahbso  : in  ahb_slave_out_vector;
    o_ahbsi  : out ahb_slave_in_vector;
    i_apbo   : in apb_out_vector;
    o_apbi   : out apb_in_vector
);
end;
architecture rtl of interconnect is
	COMPONENT p_beid_interconnect_f0
	PORT(
		MTXHCLK : IN std_logic;
		MTXHRESETn : IN std_logic;
		AHB2APBHCLK : IN std_logic;
		MTXREMAP : IN std_logic_vector(3 downto 0);
		HADDRI : IN std_logic_vector(31 downto 0);
		HTRANSI : IN std_logic_vector(1 downto 0);
		HSIZEI : IN std_logic_vector(2 downto 0);
		HBURSTI : IN std_logic_vector(2 downto 0);
		HPROTI : IN std_logic_vector(3 downto 0);
		MEMATTRI : IN std_logic_vector(1 downto 0);
		HADDRD : IN std_logic_vector(31 downto 0);
		HTRANSD : IN std_logic_vector(1 downto 0);
		HMASTERD : IN std_logic_vector(1 downto 0);
		HSIZED : IN std_logic_vector(2 downto 0);
		HBURSTD : IN std_logic_vector(2 downto 0);
		HPROTD : IN std_logic_vector(3 downto 0);
		MEMATTRD : IN std_logic_vector(1 downto 0);
		HWDATAD : IN std_logic_vector(31 downto 0);
		HWRITED : IN std_logic;
		EXREQD : IN std_logic;
		HAUSERINITCM3DI : IN std_logic;
		HWUSERINITCM3DI : IN std_logic_vector(3 downto 0);
		HADDRS : IN std_logic_vector(31 downto 0);
		HTRANSS : IN std_logic_vector(1 downto 0);
		HMASTERS : IN std_logic_vector(1 downto 0);
		HWRITES : IN std_logic;
		HSIZES : IN std_logic_vector(2 downto 0);
		HMASTLOCKS : IN std_logic;
		HWDATAS : IN std_logic_vector(31 downto 0);
		HBURSTS : IN std_logic_vector(2 downto 0);
		HPROTS : IN std_logic_vector(3 downto 0);
		MEMATTRS : IN std_logic_vector(1 downto 0);
		EXREQS : IN std_logic;
		HAUSERINITCM3S : IN std_logic;
		HWUSERINITCM3S : IN std_logic_vector(3 downto 0);
		INITEXP0HSEL : IN std_logic;
		INITEXP0HADDR : IN std_logic_vector(31 downto 0);
		INITEXP0HTRANS : IN std_logic_vector(1 downto 0);
		INITEXP0HMASTER : IN std_logic_vector(3 downto 0);
		INITEXP0HWRITE : IN std_logic;
		INITEXP0HSIZE : IN std_logic_vector(2 downto 0);
		INITEXP0HMASTLOCK : IN std_logic;
		INITEXP0HWDATA : IN std_logic_vector(31 downto 0);
		INITEXP0HBURST : IN std_logic_vector(2 downto 0);
		INITEXP0HPROT : IN std_logic_vector(3 downto 0);
		INITEXP0MEMATTR : IN std_logic_vector(1 downto 0);
		INITEXP0EXREQ : IN std_logic;
		INITEXP0HAUSER : IN std_logic;
		INITEXP0HWUSER : IN std_logic_vector(3 downto 0);
		INITEXP1HSEL : IN std_logic;
		INITEXP1HADDR : IN std_logic_vector(31 downto 0);
		INITEXP1HTRANS : IN std_logic_vector(1 downto 0);
		INITEXP1HMASTER : IN std_logic_vector(3 downto 0);
		INITEXP1HWRITE : IN std_logic;
		INITEXP1HSIZE : IN std_logic_vector(2 downto 0);
		INITEXP1HMASTLOCK : IN std_logic;
		INITEXP1HWDATA : IN std_logic_vector(31 downto 0);
		INITEXP1HBURST : IN std_logic_vector(2 downto 0);
		INITEXP1HPROT : IN std_logic_vector(3 downto 0);
		INITEXP1MEMATTR : IN std_logic_vector(1 downto 0);
		INITEXP1EXREQ : IN std_logic;
		INITEXP1HAUSER : IN std_logic;
		INITEXP1HWUSER : IN std_logic_vector(3 downto 0);
		TARGEXP0HREADYOUT : IN std_logic;
		TARGEXP0HRDATA : IN std_logic_vector(31 downto 0);
		TARGEXP0HRESP : IN std_logic;
		TARGEXP0EXRESP : IN std_logic;
		TARGEXP0HRUSER : IN std_logic_vector(2 downto 0);
		TARGEXP1HREADYOUT : IN std_logic;
		TARGEXP1HRDATA : IN std_logic_vector(31 downto 0);
		TARGEXP1HRESP : IN std_logic;
		TARGEXP1EXRESP : IN std_logic;
		TARGEXP1HRUSER : IN std_logic_vector(2 downto 0);
		TARGFLASH0HREADYOUT : IN std_logic;
		TARGFLASH0HRDATA : IN std_logic_vector(31 downto 0);
		TARGFLASH0HRESP : IN std_logic;
		TARGFLASH0EXRESP : IN std_logic;
		TARGFLASH0HRUSER : IN std_logic_vector(2 downto 0);
		TARGSRAM0HREADYOUT : IN std_logic;
		TARGSRAM0HRDATA : IN std_logic_vector(31 downto 0);
		TARGSRAM0HRESP : IN std_logic;
		TARGSRAM0EXRESP : IN std_logic;
		TARGSRAM0HRUSER : IN std_logic_vector(2 downto 0);
		TARGSRAM1HREADYOUT : IN std_logic;
		TARGSRAM1HRDATA : IN std_logic_vector(31 downto 0);
		TARGSRAM1HRESP : IN std_logic;
		TARGSRAM1EXRESP : IN std_logic;
		TARGSRAM1HRUSER : IN std_logic_vector(2 downto 0);
		TARGSRAM2HREADYOUT : IN std_logic;
		TARGSRAM2HRDATA : IN std_logic_vector(31 downto 0);
		TARGSRAM2HRESP : IN std_logic;
		TARGSRAM2EXRESP : IN std_logic;
		TARGSRAM2HRUSER : IN std_logic_vector(2 downto 0);
		TARGSRAM3HREADYOUT : IN std_logic;
		TARGSRAM3HRDATA : IN std_logic_vector(31 downto 0);
		TARGSRAM3HRESP : IN std_logic;
		TARGSRAM3EXRESP : IN std_logic;
		TARGSRAM3HRUSER : IN std_logic_vector(2 downto 0);
		SCANENABLE : IN std_logic;
		SCANINHCLK : IN std_logic;
		APBTARGEXP0PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP0PREADY : IN std_logic;
		APBTARGEXP0PSLVERR : IN std_logic;
		APBTARGEXP1PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP1PREADY : IN std_logic;
		APBTARGEXP1PSLVERR : IN std_logic;
		APBTARGEXP2PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP2PREADY : IN std_logic;
		APBTARGEXP2PSLVERR : IN std_logic;
		APBTARGEXP3PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP3PREADY : IN std_logic;
		APBTARGEXP3PSLVERR : IN std_logic;
		APBTARGEXP4PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP4PREADY : IN std_logic;
		APBTARGEXP4PSLVERR : IN std_logic;
		APBTARGEXP5PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP5PREADY : IN std_logic;
		APBTARGEXP5PSLVERR : IN std_logic;
		APBTARGEXP6PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP6PREADY : IN std_logic;
		APBTARGEXP6PSLVERR : IN std_logic;
		APBTARGEXP7PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP7PREADY : IN std_logic;
		APBTARGEXP7PSLVERR : IN std_logic;
		APBTARGEXP8PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP8PREADY : IN std_logic;
		APBTARGEXP8PSLVERR : IN std_logic;
		APBTARGEXP9PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP9PREADY : IN std_logic;
		APBTARGEXP9PSLVERR : IN std_logic;
		APBTARGEXP10PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP10PREADY : IN std_logic;
		APBTARGEXP10PSLVERR : IN std_logic;
		APBTARGEXP11PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP11PREADY : IN std_logic;
		APBTARGEXP11PSLVERR : IN std_logic;
		APBTARGEXP12PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP12PREADY : IN std_logic;
		APBTARGEXP12PSLVERR : IN std_logic;
		APBTARGEXP13PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP13PREADY : IN std_logic;
		APBTARGEXP13PSLVERR : IN std_logic;
		APBTARGEXP14PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP14PREADY : IN std_logic;
		APBTARGEXP14PSLVERR : IN std_logic;
		APBTARGEXP15PRDATA : IN std_logic_vector(31 downto 0);
		APBTARGEXP15PREADY : IN std_logic;
		APBTARGEXP15PSLVERR : IN std_logic;          
		APBQACTIVE : OUT std_logic;
		HRDATAI : OUT std_logic_vector(31 downto 0);
		HREADYI : OUT std_logic;
		HRESPI : OUT std_logic_vector(1 downto 0);
		HRDATAD : OUT std_logic_vector(31 downto 0);
		HREADYD : OUT std_logic;
		HRESPD : OUT std_logic_vector(1 downto 0);
		EXRESPD : OUT std_logic;
		HRUSERINITCM3DI : OUT std_logic_vector(2 downto 0);
		HRUSERINITCM3S : OUT std_logic_vector(2 downto 0);
		HREADYS : OUT std_logic;
		HRDATAS : OUT std_logic_vector(31 downto 0);
		HRESPS : OUT std_logic_vector(1 downto 0);
		EXRESPS : OUT std_logic;
		INITEXP0HREADY : OUT std_logic;
		INITEXP0HRDATA : OUT std_logic_vector(31 downto 0);
		INITEXP0HRESP : OUT std_logic;
		INITEXP0EXRESP : OUT std_logic;
		INITEXP0HRUSER : OUT std_logic_vector(2 downto 0);
		INITEXP1HREADY : OUT std_logic;
		INITEXP1HRDATA : OUT std_logic_vector(31 downto 0);
		INITEXP1HRESP : OUT std_logic;
		INITEXP1EXRESP : OUT std_logic;
		INITEXP1HRUSER : OUT std_logic_vector(2 downto 0);
		TARGEXP0HSEL : OUT std_logic;
		TARGEXP0HADDR : OUT std_logic_vector(31 downto 0);
		TARGEXP0HTRANS : OUT std_logic_vector(1 downto 0);
		TARGEXP0HMASTER : OUT std_logic_vector(3 downto 0);
		TARGEXP0HWRITE : OUT std_logic;
		TARGEXP0HSIZE : OUT std_logic_vector(2 downto 0);
		TARGEXP0HMASTLOCK : OUT std_logic;
		TARGEXP0HWDATA : OUT std_logic_vector(31 downto 0);
		TARGEXP0HBURST : OUT std_logic_vector(2 downto 0);
		TARGEXP0HPROT : OUT std_logic_vector(3 downto 0);
		TARGEXP0MEMATTR : OUT std_logic_vector(1 downto 0);
		TARGEXP0EXREQ : OUT std_logic;
		TARGEXP0HREADYMUX : OUT std_logic;
		TARGEXP0HAUSER : OUT std_logic;
		TARGEXP0HWUSER : OUT std_logic_vector(3 downto 0);
		TARGEXP1HSEL : OUT std_logic;
		TARGEXP1HADDR : OUT std_logic_vector(31 downto 0);
		TARGEXP1HTRANS : OUT std_logic_vector(1 downto 0);
		TARGEXP1HMASTER : OUT std_logic_vector(3 downto 0);
		TARGEXP1HWRITE : OUT std_logic;
		TARGEXP1HSIZE : OUT std_logic_vector(2 downto 0);
		TARGEXP1HMASTLOCK : OUT std_logic;
		TARGEXP1HWDATA : OUT std_logic_vector(31 downto 0);
		TARGEXP1HBURST : OUT std_logic_vector(2 downto 0);
		TARGEXP1HPROT : OUT std_logic_vector(3 downto 0);
		TARGEXP1MEMATTR : OUT std_logic_vector(1 downto 0);
		TARGEXP1EXREQ : OUT std_logic;
		TARGEXP1HREADYMUX : OUT std_logic;
		TARGEXP1HAUSER : OUT std_logic;
		TARGEXP1HWUSER : OUT std_logic_vector(3 downto 0);
		TARGFLASH0HSEL : OUT std_logic;
		TARGFLASH0HADDR : OUT std_logic_vector(31 downto 0);
		TARGFLASH0HTRANS : OUT std_logic_vector(1 downto 0);
		TARGFLASH0HMASTER : OUT std_logic_vector(3 downto 0);
		TARGFLASH0HWRITE : OUT std_logic;
		TARGFLASH0HSIZE : OUT std_logic_vector(2 downto 0);
		TARGFLASH0HMASTLOCK : OUT std_logic;
		TARGFLASH0HWDATA : OUT std_logic_vector(31 downto 0);
		TARGFLASH0HBURST : OUT std_logic_vector(2 downto 0);
		TARGFLASH0HPROT : OUT std_logic_vector(3 downto 0);
		TARGFLASH0MEMATTR : OUT std_logic_vector(1 downto 0);
		TARGFLASH0EXREQ : OUT std_logic;
		TARGFLASH0HREADYMUX : OUT std_logic;
		TARGFLASH0HAUSER : OUT std_logic;
		TARGFLASH0HWUSER : OUT std_logic_vector(3 downto 0);
		TARGSRAM0HSEL : OUT std_logic;
		TARGSRAM0HADDR : OUT std_logic_vector(31 downto 0);
		TARGSRAM0HTRANS : OUT std_logic_vector(1 downto 0);
		TARGSRAM0HMASTER : OUT std_logic_vector(3 downto 0);
		TARGSRAM0HWRITE : OUT std_logic;
		TARGSRAM0HSIZE : OUT std_logic_vector(2 downto 0);
		TARGSRAM0HMASTLOCK : OUT std_logic;
		TARGSRAM0HWDATA : OUT std_logic_vector(31 downto 0);
		TARGSRAM0HBURST : OUT std_logic_vector(2 downto 0);
		TARGSRAM0HPROT : OUT std_logic_vector(3 downto 0);
		TARGSRAM0MEMATTR : OUT std_logic_vector(1 downto 0);
		TARGSRAM0EXREQ : OUT std_logic;
		TARGSRAM0HREADYMUX : OUT std_logic;
		TARGSRAM0HAUSER : OUT std_logic;
		TARGSRAM0HWUSER : OUT std_logic_vector(3 downto 0);
		TARGSRAM1HSEL : OUT std_logic;
		TARGSRAM1HADDR : OUT std_logic_vector(31 downto 0);
		TARGSRAM1HTRANS : OUT std_logic_vector(1 downto 0);
		TARGSRAM1HMASTER : OUT std_logic_vector(3 downto 0);
		TARGSRAM1HWRITE : OUT std_logic;
		TARGSRAM1HSIZE : OUT std_logic_vector(2 downto 0);
		TARGSRAM1HMASTLOCK : OUT std_logic;
		TARGSRAM1HWDATA : OUT std_logic_vector(31 downto 0);
		TARGSRAM1HBURST : OUT std_logic_vector(2 downto 0);
		TARGSRAM1HPROT : OUT std_logic_vector(3 downto 0);
		TARGSRAM1MEMATTR : OUT std_logic_vector(1 downto 0);
		TARGSRAM1EXREQ : OUT std_logic;
		TARGSRAM1HREADYMUX : OUT std_logic;
		TARGSRAM1HAUSER : OUT std_logic;
		TARGSRAM1HWUSER : OUT std_logic_vector(3 downto 0);
		TARGSRAM2HSEL : OUT std_logic;
		TARGSRAM2HADDR : OUT std_logic_vector(31 downto 0);
		TARGSRAM2HTRANS : OUT std_logic_vector(1 downto 0);
		TARGSRAM2HMASTER : OUT std_logic_vector(3 downto 0);
		TARGSRAM2HWRITE : OUT std_logic;
		TARGSRAM2HSIZE : OUT std_logic_vector(2 downto 0);
		TARGSRAM2HMASTLOCK : OUT std_logic;
		TARGSRAM2HWDATA : OUT std_logic_vector(31 downto 0);
		TARGSRAM2HBURST : OUT std_logic_vector(2 downto 0);
		TARGSRAM2HPROT : OUT std_logic_vector(3 downto 0);
		TARGSRAM2MEMATTR : OUT std_logic_vector(1 downto 0);
		TARGSRAM2EXREQ : OUT std_logic;
		TARGSRAM2HREADYMUX : OUT std_logic;
		TARGSRAM2HAUSER : OUT std_logic;
		TARGSRAM2HWUSER : OUT std_logic_vector(3 downto 0);
		TARGSRAM3HSEL : OUT std_logic;
		TARGSRAM3HADDR : OUT std_logic_vector(31 downto 0);
		TARGSRAM3HTRANS : OUT std_logic_vector(1 downto 0);
		TARGSRAM3HMASTER : OUT std_logic_vector(3 downto 0);
		TARGSRAM3HWRITE : OUT std_logic;
		TARGSRAM3HSIZE : OUT std_logic_vector(2 downto 0);
		TARGSRAM3HMASTLOCK : OUT std_logic;
		TARGSRAM3HWDATA : OUT std_logic_vector(31 downto 0);
		TARGSRAM3HBURST : OUT std_logic_vector(2 downto 0);
		TARGSRAM3HPROT : OUT std_logic_vector(3 downto 0);
		TARGSRAM3MEMATTR : OUT std_logic_vector(1 downto 0);
		TARGSRAM3EXREQ : OUT std_logic;
		TARGSRAM3HREADYMUX : OUT std_logic;
		TARGSRAM3HAUSER : OUT std_logic;
		TARGSRAM3HWUSER : OUT std_logic_vector(3 downto 0);
		SCANOUTHCLK : OUT std_logic;
		APBTARGEXP0PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP0PENABLE : OUT std_logic;
		APBTARGEXP0PWRITE : OUT std_logic;
		APBTARGEXP0PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP0PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP0PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP0PSEL : OUT std_logic;
		APBTARGEXP1PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP1PENABLE : OUT std_logic;
		APBTARGEXP1PWRITE : OUT std_logic;
		APBTARGEXP1PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP1PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP1PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP1PSEL : OUT std_logic;
		APBTARGEXP2PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP2PENABLE : OUT std_logic;
		APBTARGEXP2PWRITE : OUT std_logic;
		APBTARGEXP2PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP2PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP2PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP2PSEL : OUT std_logic;
		APBTARGEXP3PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP3PENABLE : OUT std_logic;
		APBTARGEXP3PWRITE : OUT std_logic;
		APBTARGEXP3PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP3PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP3PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP3PSEL : OUT std_logic;
		APBTARGEXP4PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP4PENABLE : OUT std_logic;
		APBTARGEXP4PWRITE : OUT std_logic;
		APBTARGEXP4PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP4PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP4PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP4PSEL : OUT std_logic;
		APBTARGEXP5PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP5PENABLE : OUT std_logic;
		APBTARGEXP5PWRITE : OUT std_logic;
		APBTARGEXP5PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP5PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP5PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP5PSEL : OUT std_logic;
		APBTARGEXP6PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP6PENABLE : OUT std_logic;
		APBTARGEXP6PWRITE : OUT std_logic;
		APBTARGEXP6PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP6PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP6PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP6PSEL : OUT std_logic;
		APBTARGEXP7PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP7PENABLE : OUT std_logic;
		APBTARGEXP7PWRITE : OUT std_logic;
		APBTARGEXP7PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP7PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP7PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP7PSEL : OUT std_logic;
		APBTARGEXP8PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP8PENABLE : OUT std_logic;
		APBTARGEXP8PWRITE : OUT std_logic;
		APBTARGEXP8PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP8PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP8PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP8PSEL : OUT std_logic;
		APBTARGEXP9PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP9PENABLE : OUT std_logic;
		APBTARGEXP9PWRITE : OUT std_logic;
		APBTARGEXP9PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP9PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP9PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP9PSEL : OUT std_logic;
		APBTARGEXP10PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP10PENABLE : OUT std_logic;
		APBTARGEXP10PWRITE : OUT std_logic;
		APBTARGEXP10PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP10PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP10PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP10PSEL : OUT std_logic;
		APBTARGEXP11PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP11PENABLE : OUT std_logic;
		APBTARGEXP11PWRITE : OUT std_logic;
		APBTARGEXP11PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP11PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP11PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP11PSEL : OUT std_logic;
		APBTARGEXP12PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP12PENABLE : OUT std_logic;
		APBTARGEXP12PWRITE : OUT std_logic;
		APBTARGEXP12PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP12PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP12PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP12PSEL : OUT std_logic;
		APBTARGEXP13PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP13PENABLE : OUT std_logic;
		APBTARGEXP13PWRITE : OUT std_logic;
		APBTARGEXP13PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP13PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP13PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP13PSEL : OUT std_logic;
		APBTARGEXP14PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP14PENABLE : OUT std_logic;
		APBTARGEXP14PWRITE : OUT std_logic;
		APBTARGEXP14PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP14PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP14PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP14PSEL : OUT std_logic;
		APBTARGEXP15PADDR : OUT std_logic_vector(11 downto 0);
		APBTARGEXP15PENABLE : OUT std_logic;
		APBTARGEXP15PWRITE : OUT std_logic;
		APBTARGEXP15PSTRB : OUT std_logic_vector(3 downto 0);
		APBTARGEXP15PPROT : OUT std_logic_vector(2 downto 0);
		APBTARGEXP15PWDATA : OUT std_logic_vector(31 downto 0);
		APBTARGEXP15PSEL : OUT std_logic
		);
	END COMPONENT;
begin

	inst0: p_beid_interconnect_f0 PORT MAP(
		MTXHCLK => i_clk,
		MTXHRESETn => i_rstn,
		AHB2APBHCLK => i_clk,
		MTXREMAP => "0000",
		APBQACTIVE => open,

		HADDRI => i_ahbmo(CFG_HMST_ICACHE).haddr,
		HTRANSI => i_ahbmo(CFG_HMST_ICACHE).htrans,
		HSIZEI => i_ahbmo(CFG_HMST_ICACHE).hsize,
		HBURSTI => i_ahbmo(CFG_HMST_ICACHE).hburst,
		HPROTI => i_ahbmo(CFG_HMST_ICACHE).hprot,
		MEMATTRI => i_ahbmo(CFG_HMST_ICACHE).memattr,
		HRDATAI => o_ahbmi(CFG_HMST_ICACHE).hrdata,
		HREADYI => o_ahbmi(CFG_HMST_ICACHE).hready,
		HRESPI => o_ahbmi(CFG_HMST_ICACHE).hresp,

		HADDRD => i_ahbmo(CFG_HMST_DCACHE).haddr,
		HTRANSD => i_ahbmo(CFG_HMST_DCACHE).htrans,
		HMASTERD => i_ahbmo(CFG_HMST_DCACHE).hmaster(1 downto 0),
		HSIZED => i_ahbmo(CFG_HMST_DCACHE).hsize,
		HBURSTD => i_ahbmo(CFG_HMST_DCACHE).hburst,
		HPROTD => i_ahbmo(CFG_HMST_DCACHE).hprot,
		MEMATTRD => i_ahbmo(CFG_HMST_DCACHE).memattr,
		HWDATAD => i_ahbmo(CFG_HMST_DCACHE).hwdata,
		HWRITED => i_ahbmo(CFG_HMST_DCACHE).hwrite,
		EXREQD => i_ahbmo(CFG_HMST_DCACHE).exreq,
		HRDATAD => o_ahbmi(CFG_HMST_DCACHE).hrdata,
		HREADYD => o_ahbmi(CFG_HMST_DCACHE).hready,
		HRESPD => o_ahbmi(CFG_HMST_DCACHE).hresp,
		EXRESPD => o_ahbmi(CFG_HMST_DCACHE).exresp,
		HAUSERINITCM3DI => i_ahbmo(CFG_HMST_DCACHE).hauser,
		HWUSERINITCM3DI => i_ahbmo(CFG_HMST_DCACHE).hwuser,
		HRUSERINITCM3DI => o_ahbmi(CFG_HMST_DCACHE).hruser,

		HADDRS => i_ahbmo(CFG_HMST_SYSTEM).haddr,
		HTRANSS => i_ahbmo(CFG_HMST_SYSTEM).htrans,
		HMASTERS => i_ahbmo(CFG_HMST_SYSTEM).hmaster(1 downto 0),
		HWRITES => i_ahbmo(CFG_HMST_SYSTEM).hwrite,
		HSIZES => i_ahbmo(CFG_HMST_SYSTEM).hsize,
		HMASTLOCKS => i_ahbmo(CFG_HMST_SYSTEM).hmastlock,
		HWDATAS => i_ahbmo(CFG_HMST_SYSTEM).hwdata,
		HBURSTS => i_ahbmo(CFG_HMST_SYSTEM).hburst,
		HPROTS => i_ahbmo(CFG_HMST_SYSTEM).hprot,
		MEMATTRS => i_ahbmo(CFG_HMST_SYSTEM).memattr,
		EXREQS => i_ahbmo(CFG_HMST_SYSTEM).exreq,
		HAUSERINITCM3S => i_ahbmo(CFG_HMST_SYSTEM).hauser,
		HWUSERINITCM3S => i_ahbmo(CFG_HMST_SYSTEM).hwuser,
		HRUSERINITCM3S => o_ahbmi(CFG_HMST_SYSTEM).hruser,
		HREADYS => o_ahbmi(CFG_HMST_SYSTEM).hready,
		HRDATAS => o_ahbmi(CFG_HMST_SYSTEM).hrdata,
		HRESPS => o_ahbmi(CFG_HMST_SYSTEM).hresp,
		EXRESPS => o_ahbmi(CFG_HMST_SYSTEM).exresp,

		INITEXP0HSEL => '0',   -- from apb master
		INITEXP0HADDR => i_ahbmo(CFG_HMST_RADIO).haddr,
		INITEXP0HTRANS => i_ahbmo(CFG_HMST_RADIO).htrans,
		INITEXP0HMASTER => i_ahbmo(CFG_HMST_RADIO).hmaster,
		INITEXP0HWRITE => i_ahbmo(CFG_HMST_RADIO).hwrite,
		INITEXP0HSIZE => i_ahbmo(CFG_HMST_RADIO).hsize,
		INITEXP0HMASTLOCK => i_ahbmo(CFG_HMST_RADIO).hmastlock,
		INITEXP0HWDATA => i_ahbmo(CFG_HMST_RADIO).hwdata,
		INITEXP0HBURST => i_ahbmo(CFG_HMST_RADIO).hburst,
		INITEXP0HPROT => i_ahbmo(CFG_HMST_RADIO).hprot,
		INITEXP0MEMATTR => i_ahbmo(CFG_HMST_RADIO).memattr,
		INITEXP0EXREQ => i_ahbmo(CFG_HMST_RADIO).exreq,
		INITEXP0HREADY => o_ahbmi(CFG_HMST_RADIO).hready,
		INITEXP0HRDATA => o_ahbmi(CFG_HMST_RADIO).hrdata,
		INITEXP0HRESP => o_ahbmi(CFG_HMST_RADIO).hresp(0),
		INITEXP0EXRESP => o_ahbmi(CFG_HMST_RADIO).exresp,
		INITEXP0HAUSER => i_ahbmo(CFG_HMST_RADIO).hauser,
		INITEXP0HWUSER => i_ahbmo(CFG_HMST_RADIO).hwuser,
		INITEXP0HRUSER => o_ahbmi(CFG_HMST_RADIO).hruser,

		INITEXP1HSEL => '0',
		INITEXP1HADDR => i_ahbmo(CFG_HMST_EXTERNAL).haddr,
		INITEXP1HTRANS => i_ahbmo(CFG_HMST_EXTERNAL).htrans,
		INITEXP1HMASTER => i_ahbmo(CFG_HMST_EXTERNAL).hmaster,
		INITEXP1HWRITE => i_ahbmo(CFG_HMST_EXTERNAL).hwrite,
		INITEXP1HSIZE => i_ahbmo(CFG_HMST_EXTERNAL).hsize,
		INITEXP1HMASTLOCK => i_ahbmo(CFG_HMST_EXTERNAL).hmastlock,
		INITEXP1HWDATA => i_ahbmo(CFG_HMST_EXTERNAL).hwdata,
		INITEXP1HBURST => i_ahbmo(CFG_HMST_EXTERNAL).hburst,
		INITEXP1HPROT => i_ahbmo(CFG_HMST_EXTERNAL).hprot,
		INITEXP1MEMATTR => i_ahbmo(CFG_HMST_EXTERNAL).memattr,
		INITEXP1EXREQ => i_ahbmo(CFG_HMST_EXTERNAL).exreq,
		INITEXP1HREADY => o_ahbmi(CFG_HMST_EXTERNAL).hready,
		INITEXP1HRDATA => o_ahbmi(CFG_HMST_EXTERNAL).hrdata,
		INITEXP1HRESP => o_ahbmi(CFG_HMST_EXTERNAL).hresp(0),
		INITEXP1EXRESP => o_ahbmi(CFG_HMST_EXTERNAL).exresp,
		INITEXP1HAUSER => i_ahbmo(CFG_HMST_EXTERNAL).hauser,
		INITEXP1HWUSER => i_ahbmo(CFG_HMST_EXTERNAL).hwuser,
		INITEXP1HRUSER => o_ahbmi(CFG_HMST_EXTERNAL).hruser,

		TARGEXP0HSEL => o_ahbsi(CFG_HSLV_RADIO).hsel,
		TARGEXP0HADDR => o_ahbsi(CFG_HSLV_RADIO).haddr,
		TARGEXP0HTRANS => o_ahbsi(CFG_HSLV_RADIO).htrans,
		TARGEXP0HMASTER => o_ahbsi(CFG_HSLV_RADIO).hmaster,
		TARGEXP0HWRITE => o_ahbsi(CFG_HSLV_RADIO).hwrite,
		TARGEXP0HSIZE => o_ahbsi(CFG_HSLV_RADIO).hsize,
		TARGEXP0HMASTLOCK => o_ahbsi(CFG_HSLV_RADIO).hmastlock,
		TARGEXP0HWDATA => o_ahbsi(CFG_HSLV_RADIO).hwdata,
		TARGEXP0HBURST => o_ahbsi(CFG_HSLV_RADIO).hburst,
		TARGEXP0HPROT => o_ahbsi(CFG_HSLV_RADIO).hprot,
		TARGEXP0MEMATTR => o_ahbsi(CFG_HSLV_RADIO).memattr,
		TARGEXP0EXREQ => o_ahbsi(CFG_HSLV_RADIO).exreq,
		TARGEXP0HREADYMUX => o_ahbsi(CFG_HSLV_RADIO).hreadymux,
		TARGEXP0HREADYOUT => i_ahbso(CFG_HSLV_RADIO).hready,
		TARGEXP0HRDATA => i_ahbso(CFG_HSLV_RADIO).hrdata,
		TARGEXP0HRESP => i_ahbso(CFG_HSLV_RADIO).hresp,
		TARGEXP0EXRESP => i_ahbso(CFG_HSLV_RADIO).exresp,
		TARGEXP0HAUSER => o_ahbsi(CFG_HSLV_RADIO).hauser,
		TARGEXP0HWUSER => o_ahbsi(CFG_HSLV_RADIO).hwuser,
		TARGEXP0HRUSER => i_ahbso(CFG_HSLV_RADIO).hruser,

		TARGEXP1HSEL => o_ahbsi(CFG_HSLV_EXTERNAL).hsel,
		TARGEXP1HADDR => o_ahbsi(CFG_HSLV_EXTERNAL).haddr,
		TARGEXP1HTRANS => o_ahbsi(CFG_HSLV_EXTERNAL).htrans,
		TARGEXP1HMASTER => o_ahbsi(CFG_HSLV_EXTERNAL).hmaster,
		TARGEXP1HWRITE => o_ahbsi(CFG_HSLV_EXTERNAL).hwrite,
		TARGEXP1HSIZE => o_ahbsi(CFG_HSLV_EXTERNAL).hsize,
		TARGEXP1HMASTLOCK => o_ahbsi(CFG_HSLV_EXTERNAL).hmastlock,
		TARGEXP1HWDATA => o_ahbsi(CFG_HSLV_EXTERNAL).hwdata,
		TARGEXP1HBURST => o_ahbsi(CFG_HSLV_EXTERNAL).hburst,
		TARGEXP1HPROT => o_ahbsi(CFG_HSLV_EXTERNAL).hprot,
		TARGEXP1MEMATTR => o_ahbsi(CFG_HSLV_EXTERNAL).memattr,
		TARGEXP1EXREQ => o_ahbsi(CFG_HSLV_EXTERNAL).exreq,
		TARGEXP1HREADYMUX => o_ahbsi(CFG_HSLV_EXTERNAL).hreadymux,
		TARGEXP1HREADYOUT => i_ahbso(CFG_HSLV_EXTERNAL).hready,
		TARGEXP1HRDATA => i_ahbso(CFG_HSLV_EXTERNAL).hrdata,
		TARGEXP1HRESP => i_ahbso(CFG_HSLV_EXTERNAL).hresp,
		TARGEXP1EXRESP => i_ahbso(CFG_HSLV_EXTERNAL).exresp,
		TARGEXP1HAUSER => o_ahbsi(CFG_HSLV_EXTERNAL).hauser,
		TARGEXP1HWUSER => o_ahbsi(CFG_HSLV_EXTERNAL).hwuser,
		TARGEXP1HRUSER => i_ahbso(CFG_HSLV_EXTERNAL).hruser,

		TARGFLASH0HSEL => o_ahbsi(CFG_HSLV_FLASH).hsel,
		TARGFLASH0HADDR => o_ahbsi(CFG_HSLV_FLASH).haddr,
		TARGFLASH0HTRANS => o_ahbsi(CFG_HSLV_FLASH).htrans,
		TARGFLASH0HMASTER => o_ahbsi(CFG_HSLV_FLASH).hmaster,
		TARGFLASH0HWRITE => o_ahbsi(CFG_HSLV_FLASH).hwrite,
		TARGFLASH0HSIZE => o_ahbsi(CFG_HSLV_FLASH).hsize,
		TARGFLASH0HMASTLOCK => o_ahbsi(CFG_HSLV_FLASH).hmastlock,
		TARGFLASH0HWDATA => o_ahbsi(CFG_HSLV_FLASH).hwdata,
		TARGFLASH0HBURST => o_ahbsi(CFG_HSLV_FLASH).hburst,
		TARGFLASH0HPROT => o_ahbsi(CFG_HSLV_FLASH).hprot,
		TARGFLASH0MEMATTR => o_ahbsi(CFG_HSLV_FLASH).memattr,
		TARGFLASH0EXREQ => o_ahbsi(CFG_HSLV_FLASH).exreq,
		TARGFLASH0HREADYMUX => o_ahbsi(CFG_HSLV_FLASH).hreadymux,
		TARGFLASH0HREADYOUT => i_ahbso(CFG_HSLV_FLASH).hready,
		TARGFLASH0HRDATA => i_ahbso(CFG_HSLV_FLASH).hrdata,
		TARGFLASH0HRESP => i_ahbso(CFG_HSLV_FLASH).hresp,
		TARGFLASH0EXRESP => i_ahbso(CFG_HSLV_FLASH).exresp,
		TARGFLASH0HAUSER => o_ahbsi(CFG_HSLV_FLASH).hauser,
		TARGFLASH0HWUSER => o_ahbsi(CFG_HSLV_FLASH).hwuser,
		TARGFLASH0HRUSER => i_ahbso(CFG_HSLV_FLASH).hruser,

		TARGSRAM0HSEL => o_ahbsi(CFG_HSLV_SRAM0).hsel,
		TARGSRAM0HADDR => o_ahbsi(CFG_HSLV_SRAM0).haddr,
		TARGSRAM0HTRANS => o_ahbsi(CFG_HSLV_SRAM0).htrans,
		TARGSRAM0HMASTER => o_ahbsi(CFG_HSLV_SRAM0).hmaster,
		TARGSRAM0HWRITE => o_ahbsi(CFG_HSLV_SRAM0).hwrite,
		TARGSRAM0HSIZE => o_ahbsi(CFG_HSLV_SRAM0).hsize,
		TARGSRAM0HMASTLOCK => o_ahbsi(CFG_HSLV_SRAM0).hmastlock,
		TARGSRAM0HWDATA => o_ahbsi(CFG_HSLV_SRAM0).hwdata,
		TARGSRAM0HBURST => o_ahbsi(CFG_HSLV_SRAM0).hburst,
		TARGSRAM0HPROT => o_ahbsi(CFG_HSLV_SRAM0).hprot,
		TARGSRAM0MEMATTR => o_ahbsi(CFG_HSLV_SRAM0).memattr,
		TARGSRAM0EXREQ => o_ahbsi(CFG_HSLV_SRAM0).exreq,
		TARGSRAM0HREADYMUX => o_ahbsi(CFG_HSLV_SRAM0).hreadymux,
		TARGSRAM0HREADYOUT => i_ahbso(CFG_HSLV_SRAM0).hready,
		TARGSRAM0HRDATA => i_ahbso(CFG_HSLV_SRAM0).hrdata,
		TARGSRAM0HRESP => i_ahbso(CFG_HSLV_SRAM0).hresp,
		TARGSRAM0EXRESP => i_ahbso(CFG_HSLV_SRAM0).exresp,
		TARGSRAM0HAUSER => o_ahbsi(CFG_HSLV_SRAM0).hauser,
		TARGSRAM0HWUSER => o_ahbsi(CFG_HSLV_SRAM0).hwuser,
		TARGSRAM0HRUSER => i_ahbso(CFG_HSLV_SRAM0).hruser,

		TARGSRAM1HSEL => o_ahbsi(CFG_HSLV_SRAM1).hsel,
		TARGSRAM1HADDR => o_ahbsi(CFG_HSLV_SRAM1).haddr,
		TARGSRAM1HTRANS => o_ahbsi(CFG_HSLV_SRAM1).htrans,
		TARGSRAM1HMASTER => o_ahbsi(CFG_HSLV_SRAM1).hmaster,
		TARGSRAM1HWRITE => o_ahbsi(CFG_HSLV_SRAM1).hwrite,
		TARGSRAM1HSIZE => o_ahbsi(CFG_HSLV_SRAM1).hsize,
		TARGSRAM1HMASTLOCK => o_ahbsi(CFG_HSLV_SRAM1).hmastlock,
		TARGSRAM1HWDATA => o_ahbsi(CFG_HSLV_SRAM1).hwdata,
		TARGSRAM1HBURST => o_ahbsi(CFG_HSLV_SRAM1).hburst,
		TARGSRAM1HPROT => o_ahbsi(CFG_HSLV_SRAM1).hprot,
		TARGSRAM1MEMATTR => o_ahbsi(CFG_HSLV_SRAM1).memattr,
		TARGSRAM1EXREQ => o_ahbsi(CFG_HSLV_SRAM1).exreq,
		TARGSRAM1HREADYMUX => o_ahbsi(CFG_HSLV_SRAM1).hreadymux,
		TARGSRAM1HREADYOUT => i_ahbso(CFG_HSLV_SRAM1).hready,
		TARGSRAM1HRDATA => i_ahbso(CFG_HSLV_SRAM1).hrdata,
		TARGSRAM1HRESP => i_ahbso(CFG_HSLV_SRAM1).hresp,
		TARGSRAM1EXRESP => i_ahbso(CFG_HSLV_SRAM1).exresp,
		TARGSRAM1HAUSER => o_ahbsi(CFG_HSLV_SRAM1).hauser,
		TARGSRAM1HWUSER => o_ahbsi(CFG_HSLV_SRAM1).hwuser,
		TARGSRAM1HRUSER => i_ahbso(CFG_HSLV_SRAM1).hruser,

		TARGSRAM2HSEL => o_ahbsi(CFG_HSLV_SRAM2).hsel,
		TARGSRAM2HADDR => o_ahbsi(CFG_HSLV_SRAM2).haddr,
		TARGSRAM2HTRANS => o_ahbsi(CFG_HSLV_SRAM2).htrans,
		TARGSRAM2HMASTER => o_ahbsi(CFG_HSLV_SRAM2).hmaster,
		TARGSRAM2HWRITE => o_ahbsi(CFG_HSLV_SRAM2).hwrite,
		TARGSRAM2HSIZE => o_ahbsi(CFG_HSLV_SRAM2).hsize,
		TARGSRAM2HMASTLOCK => o_ahbsi(CFG_HSLV_SRAM2).hmastlock,
		TARGSRAM2HWDATA => o_ahbsi(CFG_HSLV_SRAM2).hwdata,
		TARGSRAM2HBURST => o_ahbsi(CFG_HSLV_SRAM2).hburst,
		TARGSRAM2HPROT => o_ahbsi(CFG_HSLV_SRAM2).hprot,
		TARGSRAM2MEMATTR => o_ahbsi(CFG_HSLV_SRAM2).memattr,
		TARGSRAM2EXREQ => o_ahbsi(CFG_HSLV_SRAM2).exreq,
		TARGSRAM2HREADYMUX => o_ahbsi(CFG_HSLV_SRAM2).hreadymux,
		TARGSRAM2HREADYOUT => i_ahbso(CFG_HSLV_SRAM2).hready,
		TARGSRAM2HRDATA => i_ahbso(CFG_HSLV_SRAM2).hrdata,
		TARGSRAM2HRESP => i_ahbso(CFG_HSLV_SRAM2).hresp,
		TARGSRAM2EXRESP => i_ahbso(CFG_HSLV_SRAM2).exresp,
		TARGSRAM2HAUSER => o_ahbsi(CFG_HSLV_SRAM2).hauser,
		TARGSRAM2HWUSER => o_ahbsi(CFG_HSLV_SRAM2).hwuser,
		TARGSRAM2HRUSER => i_ahbso(CFG_HSLV_SRAM2).hruser,

		TARGSRAM3HSEL => o_ahbsi(CFG_HSLV_SRAM3).hsel,
		TARGSRAM3HADDR => o_ahbsi(CFG_HSLV_SRAM3).haddr,
		TARGSRAM3HTRANS => o_ahbsi(CFG_HSLV_SRAM3).htrans,
		TARGSRAM3HMASTER => o_ahbsi(CFG_HSLV_SRAM3).hmaster,
		TARGSRAM3HWRITE => o_ahbsi(CFG_HSLV_SRAM3).hwrite,
		TARGSRAM3HSIZE => o_ahbsi(CFG_HSLV_SRAM3).hsize,
		TARGSRAM3HMASTLOCK => o_ahbsi(CFG_HSLV_SRAM3).hmastlock,
		TARGSRAM3HWDATA => o_ahbsi(CFG_HSLV_SRAM3).hwdata,
		TARGSRAM3HBURST => o_ahbsi(CFG_HSLV_SRAM3).hburst,
		TARGSRAM3HPROT => o_ahbsi(CFG_HSLV_SRAM3).hprot,
		TARGSRAM3MEMATTR => o_ahbsi(CFG_HSLV_SRAM3).memattr,
		TARGSRAM3EXREQ => o_ahbsi(CFG_HSLV_SRAM3).exreq,
		TARGSRAM3HREADYMUX => o_ahbsi(CFG_HSLV_SRAM3).hreadymux,
		TARGSRAM3HREADYOUT => i_ahbso(CFG_HSLV_SRAM3).hready,
		TARGSRAM3HRDATA => i_ahbso(CFG_HSLV_SRAM3).hrdata,
		TARGSRAM3HRESP => i_ahbso(CFG_HSLV_SRAM3).hresp,
		TARGSRAM3EXRESP => i_ahbso(CFG_HSLV_SRAM3).exresp,
		TARGSRAM3HAUSER => o_ahbsi(CFG_HSLV_SRAM3).hauser,
		TARGSRAM3HWUSER => o_ahbsi(CFG_HSLV_SRAM3).hwuser,
		TARGSRAM3HRUSER => i_ahbso(CFG_HSLV_SRAM3).hruser,

		SCANENABLE => '0',
		SCANINHCLK => '0',
		SCANOUTHCLK => open,

		APBTARGEXP0PADDR => o_apbi(0).paddr,
		APBTARGEXP0PENABLE => o_apbi(0).penable,
		APBTARGEXP0PWRITE => o_apbi(0).pwrite,
		APBTARGEXP0PSTRB => o_apbi(0).pstrb,
		APBTARGEXP0PPROT => o_apbi(0).pprot,
		APBTARGEXP0PWDATA => o_apbi(0).pwdata,
		APBTARGEXP0PSEL => o_apbi(0).psel,
		APBTARGEXP0PRDATA => i_apbo(0).prdata,
		APBTARGEXP0PREADY => i_apbo(0).pready,
		APBTARGEXP0PSLVERR => i_apbo(0).slverr,

		APBTARGEXP1PADDR => o_apbi(1).paddr,
		APBTARGEXP1PENABLE => o_apbi(1).penable,
		APBTARGEXP1PWRITE => o_apbi(1).pwrite,
		APBTARGEXP1PSTRB => o_apbi(1).pstrb,
		APBTARGEXP1PPROT => o_apbi(1).pprot,
		APBTARGEXP1PWDATA => o_apbi(1).pwdata,
		APBTARGEXP1PSEL => o_apbi(1).psel,
		APBTARGEXP1PRDATA => i_apbo(1).prdata,
		APBTARGEXP1PREADY => i_apbo(1).pready,
		APBTARGEXP1PSLVERR => i_apbo(1).slverr,
		
		APBTARGEXP2PADDR => o_apbi(2).paddr,
		APBTARGEXP2PENABLE => o_apbi(2).penable,
		APBTARGEXP2PWRITE => o_apbi(2).pwrite,
		APBTARGEXP2PSTRB => o_apbi(2).pstrb,
		APBTARGEXP2PPROT => o_apbi(2).pprot,
		APBTARGEXP2PWDATA => o_apbi(2).pwdata,
		APBTARGEXP2PSEL => o_apbi(2).psel,
		APBTARGEXP2PRDATA => i_apbo(2).prdata,
		APBTARGEXP2PREADY => i_apbo(2).pready,
		APBTARGEXP2PSLVERR => i_apbo(2).slverr,
		
		APBTARGEXP3PADDR   => o_apbi(3).paddr,
		APBTARGEXP3PENABLE => o_apbi(3).penable,
		APBTARGEXP3PWRITE  => o_apbi(3).pwrite,
		APBTARGEXP3PSTRB   => o_apbi(3).pstrb,
		APBTARGEXP3PPROT   => o_apbi(3).pprot,
		APBTARGEXP3PWDATA  => o_apbi(3).pwdata,
		APBTARGEXP3PSEL    => o_apbi(3).psel,
		APBTARGEXP3PRDATA  => i_apbo(3).prdata,
		APBTARGEXP3PREADY  => i_apbo(3).pready,
		APBTARGEXP3PSLVERR => i_apbo(3).slverr,
		
		APBTARGEXP4PADDR =>   o_apbi(4).paddr,
		APBTARGEXP4PENABLE => o_apbi(4).penable,
		APBTARGEXP4PWRITE =>  o_apbi(4).pwrite,
		APBTARGEXP4PSTRB =>   o_apbi(4).pstrb,
		APBTARGEXP4PPROT =>   o_apbi(4).pprot,
		APBTARGEXP4PWDATA =>  o_apbi(4).pwdata,
		APBTARGEXP4PSEL =>    o_apbi(4).psel,
		APBTARGEXP4PRDATA =>  i_apbo(4).prdata,
		APBTARGEXP4PREADY =>  i_apbo(4).pready,
		APBTARGEXP4PSLVERR => i_apbo(4).slverr,

		APBTARGEXP5PADDR =>   o_apbi(5).paddr,
		APBTARGEXP5PENABLE => o_apbi(5).penable,
		APBTARGEXP5PWRITE =>  o_apbi(5).pwrite,
		APBTARGEXP5PSTRB =>   o_apbi(5).pstrb,
		APBTARGEXP5PPROT =>   o_apbi(5).pprot,
		APBTARGEXP5PWDATA =>  o_apbi(5).pwdata,
		APBTARGEXP5PSEL =>    o_apbi(5).psel,
		APBTARGEXP5PRDATA =>  i_apbo(5).prdata,
		APBTARGEXP5PREADY =>  i_apbo(5).pready,
		APBTARGEXP5PSLVERR => i_apbo(5).slverr,
		
		APBTARGEXP6PADDR =>   o_apbi(6).paddr,
		APBTARGEXP6PENABLE => o_apbi(6).penable,
		APBTARGEXP6PWRITE =>  o_apbi(6).pwrite,
		APBTARGEXP6PSTRB =>   o_apbi(6).pstrb,
		APBTARGEXP6PPROT =>   o_apbi(6).pprot,
		APBTARGEXP6PWDATA =>  o_apbi(6).pwdata,
		APBTARGEXP6PSEL =>    o_apbi(6).psel,
		APBTARGEXP6PRDATA =>  i_apbo(6).prdata,
		APBTARGEXP6PREADY =>  i_apbo(6).pready,
		APBTARGEXP6PSLVERR => i_apbo(6).slverr,

		APBTARGEXP7PADDR =>   o_apbi(7).paddr,
		APBTARGEXP7PENABLE => o_apbi(7).penable,
		APBTARGEXP7PWRITE =>  o_apbi(7).pwrite,
		APBTARGEXP7PSTRB =>   o_apbi(7).pstrb,
		APBTARGEXP7PPROT =>   o_apbi(7).pprot,
		APBTARGEXP7PWDATA =>  o_apbi(7).pwdata,
		APBTARGEXP7PSEL =>    o_apbi(7).psel,
		APBTARGEXP7PRDATA =>  i_apbo(7).prdata,
		APBTARGEXP7PREADY =>  i_apbo(7).pready,
		APBTARGEXP7PSLVERR => i_apbo(7).slverr,

		APBTARGEXP8PADDR =>   o_apbi(8).paddr,
		APBTARGEXP8PENABLE => o_apbi(8).penable,
		APBTARGEXP8PWRITE =>  o_apbi(8).pwrite,
		APBTARGEXP8PSTRB =>   o_apbi(8).pstrb,
		APBTARGEXP8PPROT =>   o_apbi(8).pprot,
		APBTARGEXP8PWDATA =>  o_apbi(8).pwdata,
		APBTARGEXP8PSEL =>    o_apbi(8).psel,
		APBTARGEXP8PRDATA =>  i_apbo(8).prdata,
		APBTARGEXP8PREADY =>  i_apbo(8).pready,
		APBTARGEXP8PSLVERR => i_apbo(8).slverr,

		APBTARGEXP9PADDR =>   o_apbi(9).paddr,
		APBTARGEXP9PENABLE => o_apbi(9).penable,
		APBTARGEXP9PWRITE =>  o_apbi(9).pwrite,
		APBTARGEXP9PSTRB =>   o_apbi(9).pstrb,
		APBTARGEXP9PPROT =>   o_apbi(9).pprot,
		APBTARGEXP9PWDATA =>  o_apbi(9).pwdata,
		APBTARGEXP9PSEL =>    o_apbi(9).psel,
		APBTARGEXP9PRDATA =>  i_apbo(9).prdata,
		APBTARGEXP9PREADY =>  i_apbo(9).pready,
		APBTARGEXP9PSLVERR => i_apbo(9).slverr,

		APBTARGEXP10PADDR =>   o_apbi(10).paddr,
		APBTARGEXP10PENABLE => o_apbi(10).penable,
		APBTARGEXP10PWRITE =>  o_apbi(10).pwrite,
		APBTARGEXP10PSTRB =>   o_apbi(10).pstrb,
		APBTARGEXP10PPROT =>   o_apbi(10).pprot,
		APBTARGEXP10PWDATA =>  o_apbi(10).pwdata,
		APBTARGEXP10PSEL =>    o_apbi(10).psel,
		APBTARGEXP10PRDATA =>  i_apbo(10).prdata,
		APBTARGEXP10PREADY =>  i_apbo(10).pready,
		APBTARGEXP10PSLVERR => i_apbo(10).slverr,

		APBTARGEXP11PADDR =>   o_apbi(11).paddr,
		APBTARGEXP11PENABLE => o_apbi(11).penable,
		APBTARGEXP11PWRITE =>  o_apbi(11).pwrite,
		APBTARGEXP11PSTRB =>   o_apbi(11).pstrb,
		APBTARGEXP11PPROT =>   o_apbi(11).pprot,
		APBTARGEXP11PWDATA =>  o_apbi(11).pwdata,
		APBTARGEXP11PSEL =>    o_apbi(11).psel,
		APBTARGEXP11PRDATA =>  i_apbo(11).prdata,
		APBTARGEXP11PREADY =>  i_apbo(11).pready,
		APBTARGEXP11PSLVERR => i_apbo(11).slverr,

		APBTARGEXP12PADDR =>   o_apbi(12).paddr,
		APBTARGEXP12PENABLE => o_apbi(12).penable,
		APBTARGEXP12PWRITE =>  o_apbi(12).pwrite,
		APBTARGEXP12PSTRB =>   o_apbi(12).pstrb,
		APBTARGEXP12PPROT =>   o_apbi(12).pprot,
		APBTARGEXP12PWDATA =>  o_apbi(12).pwdata,
		APBTARGEXP12PSEL =>    o_apbi(12).psel,
		APBTARGEXP12PRDATA =>  i_apbo(12).prdata,
		APBTARGEXP12PREADY =>  i_apbo(12).pready,
		APBTARGEXP12PSLVERR => i_apbo(12).slverr,

		APBTARGEXP13PADDR =>   o_apbi(13).paddr,
		APBTARGEXP13PENABLE => o_apbi(13).penable,
		APBTARGEXP13PWRITE =>  o_apbi(13).pwrite,
		APBTARGEXP13PSTRB =>   o_apbi(13).pstrb,
		APBTARGEXP13PPROT =>   o_apbi(13).pprot,
		APBTARGEXP13PWDATA =>  o_apbi(13).pwdata,
		APBTARGEXP13PSEL =>    o_apbi(13).psel,
		APBTARGEXP13PRDATA =>  i_apbo(13).prdata,
		APBTARGEXP13PREADY =>  i_apbo(13).pready,
		APBTARGEXP13PSLVERR => i_apbo(13).slverr,

		APBTARGEXP14PADDR =>   o_apbi(14).paddr,
		APBTARGEXP14PENABLE => o_apbi(14).penable,
		APBTARGEXP14PWRITE =>  o_apbi(14).pwrite,
		APBTARGEXP14PSTRB =>   o_apbi(14).pstrb,
		APBTARGEXP14PPROT =>   o_apbi(14).pprot,
		APBTARGEXP14PWDATA =>  o_apbi(14).pwdata,
		APBTARGEXP14PSEL =>    o_apbi(14).psel,
		APBTARGEXP14PRDATA =>  i_apbo(14).prdata,
		APBTARGEXP14PREADY =>  i_apbo(14).pready,
		APBTARGEXP14PSLVERR => i_apbo(14).slverr,

		APBTARGEXP15PADDR =>   o_apbi(15).paddr,
		APBTARGEXP15PENABLE => o_apbi(15).penable,
		APBTARGEXP15PWRITE =>  o_apbi(15).pwrite,
		APBTARGEXP15PSTRB =>   o_apbi(15).pstrb,
		APBTARGEXP15PPROT =>   o_apbi(15).pprot,
		APBTARGEXP15PWDATA =>  o_apbi(15).pwdata,
		APBTARGEXP15PSEL =>    o_apbi(15).psel,
		APBTARGEXP15PRDATA =>  i_apbo(15).prdata,
		APBTARGEXP15PREADY =>  i_apbo(15).pready,
		APBTARGEXP15PSLVERR => i_apbo(15).slverr
	);

end;

