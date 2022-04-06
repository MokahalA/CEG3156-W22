--------------------------------------------------------------------------------
-- Title         : Hazard Detection Unit
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : hazardDetectionUnit.vhd

library ieee;
use ieee.std_logic_1164.all;

entity hazardDetectionUnit is
  port (
	IDEX_memRead: in std_logic;
	IDEX_rt, IFID_rs, IFID_rt: in std_logic_vector(4 downto 0);
	o_PCWrite, o_IFID_Write, o_ControlMux: out std_logic
  ) ;
end hazardDetectionUnit ;

architecture arch of hazardDetectionUnit is

    -- 2 Conditions
    signal c1, c2, stall: std_logic;


begin

    c1 <= (IDEX_rt(4) xnor IFID_rs(4)) and (IDEX_rt(3) xnor IFID_rs(3)) and (IDEX_rt(2) xnor IFID_rs(2)) and (IDEX_rt(1) xnor IFID_rs(1)) and (IDEX_rt(0) xnor IFID_rs(0));
    c2 <= (IDEX_rt(4) xnor IFID_rt(4)) and (IDEX_rt(3) xnor IFID_rt(3)) and (IDEX_rt(2) xnor IFID_rt(2)) and (IDEX_rt(1) xnor IFID_rt(1)) and (IDEX_rt(0) xnor IFID_rt(0));

    stall <= IDEX_memRead and (c1 or c2);

    --  Output Driver
    o_PCWrite     <= not(stall);
    o_IFID_Write  <= not(stall);
    o_ControlMux  <= stall;


end architecture ; -- arch