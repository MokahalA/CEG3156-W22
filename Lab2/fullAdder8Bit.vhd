--------------------------------------------------------------------------------
-- Title         : 8-Bit Full Adder/ Branch Adder
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : fullAdder8Bit.vhd

Library IEEE;
use ieee.std_logic_1164.all;

entity fullAdder8Bit is
	port(
		M : in std_logic_vector (7 downto 0);
		N : in std_logic_vector (7 downto 0);
		Cin : in std_logic;
		Cout : out std_logic;
		Sum : out std_logic_vector (7 downto 0)
	);
end fullAdder8Bit;

architecture arch_fullAdder8Bit of fullAdder8Bit is
	signal s0, s1, s2, s3, s4, s5, s6, s7 : std_logic;
	component fullAdder1Bit
		port(
			A :  IN  STD_LOGIC;
			B :  IN  STD_LOGIC;
			Ci :  IN  STD_LOGIC;
			S :  OUT  STD_LOGIC;
			Co :  OUT  STD_LOGIC
		);
	end component;
	
begin

l0: fullAdder1Bit port map (M(0), N(0), Cin, Sum(0), s0);
l1: fullAdder1Bit port map (M(1), N(1), s0, Sum(1), s1);
l2: fullAdder1Bit port map (M(2), N(2), s1, Sum(2), s2);
l3: fullAdder1Bit port map (M(3), N(3), s2, Sum(3), s3);
l4: fullAdder1Bit port map (M(4), N(4), s3, Sum(4), s4);
l5: fullAdder1Bit port map (M(5), N(5), s4, Sum(5), s5);
l6: fullAdder1Bit port map (M(6), N(6), s5, Sum(6), s6);
l7: fullAdder1Bit port map (M(7), N(7), s5, Sum(7), Cout);

end arch_fullAdder8Bit;