--------------------------------------------------------------------------------
-- Title         : Left Shift by 2 Unit
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : shiftLeft2.vhd

LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity shiftleft2 is
port(
	x : in std_logic_vector(7 downto 0);
	y : out std_logic_vector(7 downto 0));
end shiftleft2;

architecture arch_shiftleft2 of shiftleft2 is
begin
	y <= x(5 downto 0) & "00";
end arch_shiftleft2;