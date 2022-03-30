--------------------------------------------------------------------------------
-- Title         : 8-Bit AND gate
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : eightBitAND.vhd

library ieee;
use ieee.std_logic_1164.all;

entity eightBitAND is
	port (
			valA, valB : in std_logic_vector (7 downto 0);
			valO: out std_logic_vector(7 downto 0)
		);
end eightBitAND;

architecture rtl of eightBitAND is
begin
valO <= valB AND valA;
end architecture rtl;