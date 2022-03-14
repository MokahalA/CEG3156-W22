--------------------------------------------------------------------------------
-- Title         : 8 to 3 Multiplexer
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : mux8x3.vhd

library IEEE;
use IEEE.Std_Logic_1164.all;

entity mux8x3 is
port (a,b,c,d,e,f,g,h: in std_logic_vector(7 downto 0);
		selec: in std_logic_vector(2 downto 0);
		m: out std_logic_vector(7 downto 0)
		);
end mux8x3;
architecture circuit of mux8x3 is
begin
	m <= a when selec = "000" else
		 b when selec = "001" else
		 c when selec = "010" else
		 d when selec = "011" else
		 e when selec = "100" else
		 f when selec = "101" else
		 g when selec = "110" else
		 h;
end circuit;