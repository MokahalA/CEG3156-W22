-------------------------------------------------------------------------------
-- Title		: 1Bit Full Adder
-- file			: oneBitFA.vhd
-- Project		: Single-cycle processor
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-------------------------------------------------------------------------------
ENTITY oneBitFA IS
	PORT(
		i_x		:IN std_logic;
		i_y		:IN std_logic;
		i_cin	:IN	std_logic;
		o_sum	:OUT std_logic;
		o_cout	:OUT std_logic);

END ENTITY oneBitFA;
-------------------------------------------------------------------------------
ARCHITECTURE rtl OF oneBitFA IS
	SIGNAL int_xXORy, int_xANDy, int_cinANDz	: std_logic;			-- z=xXORy
	SIGNAL int_sum, int_cout	:std_logic;
BEGIN
	
	--  Concurrent Signal Assignment
	
	int_xXORy <= i_x xor i_y;
	int_xANDy <= i_x and i_y;
	int_cinANDz <= i_cin and int_xXORy;
	
	int_sum <= i_cin xor int_xXORy;
	int_cout <= int_cinANDz or int_xANDy;
	
	
	--  Output Driver
	o_sum <= int_sum;
	o_cout <= int_cout;

END ARCHITECTURE rtl;
-------------------------------------------------------------------------------