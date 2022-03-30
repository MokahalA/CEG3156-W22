-------------------------------------------------------------------------------
-- Title         : 8-bit OR gate
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : eightBitOR.vhd

library ieee;
use ieee.std_logic_1164.all;

entity eightBitOr is
	port (
			valA, valB : in std_logic_vector (7 downto 0);
			valO: out std_logic_vector(7 downto 0)
		);
end eightBitOr;

architecture rtl of eightBitOr is

begin
valO <= valB OR valA;
end architecture rtl;