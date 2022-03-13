-------------------------------------------------------------------------------
-- Title		: 8bit Add&Subtract Unit
-- file			: eightAddSubUnit.vhd
-- Project		: Single-cycle processor
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------
-- ENTITY
-------------------------------------------------------------------------------
ENTITY eightAddSubUnit IS
	PORT(
		i_Xi, i_Yi		:IN std_logic_vector(7 downto 0);
		i_sub			:IN std_logic;
		o_Cout			:OUT std_logic;
		o_Sum			:OUT std_logic_vector(7 downto 0));

END ENTITY eightAddSubUnit;
-------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------
ARCHITECTURE rtl OF eightAddSubUnit IS

SIGNAL int_Sum	    : std_logic_vector(7 downto 0);
SIGNAL int_Yi 	    :std_logic_vector(7 downto 0);
SIGNAL int_Cout     :std_logic;
SIGNAL int_ZeroFlag :std_logic;

COMPONENT eightBitFA
		PORT( 
		i_Ai, i_Bi		: IN	std_logic_vector(7 downto 0);
		i_Cin			: IN	std_logic;
		o_Cout			: OUT	std_logic;
		o_Sum			: OUT	std_logic_vector(7 downto 0);
        o_ZeroFlag      : OUT   std_logic;
        );
	END COMPONENT eightBitFA;
	
BEGIN
    
    --  Concurrent Signal Assignment
	
	int_Yi(0) <= i_Yi(0) xor i_sub;
	int_Yi(1) <= i_Yi(1) xor i_sub;
	int_Yi(2) <= i_Yi(2) xor i_sub;	
	int_Yi(3) <= i_Yi(3) xor i_sub;
    int_Yi(4) <= i_Yi(4) xor i_sub;
	int_Yi(5) <= i_Yi(5) xor i_sub;
	int_Yi(6) <= i_Yi(6) xor i_sub;	
	int_Yi(7) <= i_Yi(7) xor i_sub;

	add_sub: eightBitFA
		port map (
			i_Ai => i_Xi,
			i_Bi => int_Yi,
			i_Cin => i_sub,
			o_Cout => int_Cout,
			o_Sum => int_Sum);
			
	int_ZeroFlag <= NOT(int_Sum(0) OR int_Sum(1) OR int_Sum(2) OR int_Sum(3) OR int_Sum(4) OR int_Sum(5) OR int_Sum(6) OR int_Sum(7));

	--  Output Driver
	o_Sum <= int_Sum;
	o_Cout <= int_Cout;
    o_ZeroFlag <= int_ZeroFlag;

END ARCHITECTURE rtl;
-------------------------------------------------------------------------------