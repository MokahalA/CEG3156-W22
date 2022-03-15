LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- This mux is used for ALUsrc, MemToReg, Jump, and BNE/Branch

ENTITY mux2to1_8bit IS

PORT (A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		s : IN STD_LOGIC;
		R : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end mux2to1_8bit;

ARCHITECTURE Behavior OF mux2to1_8bit IS

BEGIN

	process(s)
	BEGIN
		if(s = '0') then
			R <= A;
		else
			R <= B;
		end if;
	end process;
end Behavior;