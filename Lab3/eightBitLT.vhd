--------------------------------------------------------------------------------
-- Title         : 8-Bit LT (Less Than) unit
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : eightBitLT.vhd

library ieee;
use ieee.std_logic_1164.all;

entity eightBitLT is
	port (
			valA, valB : in std_logic_vector (7 downto 0);
			valO: out std_logic_vector(7 downto 0)
		);
end eightBitLT;

architecture rtl of eightBitLT is
begin
process(valB,valA)
begin
	if (valB>valA) then 
        valO <= "11111111";
	else
        valO <= "00000000";
    end if;
end process;
end architecture;