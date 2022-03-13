-------------------------------------------------------------------------------
-- Title		: 8Bit Full Adder
-- file			: eightBitFA.vhd
-- Project		: Single-cycle processor
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-------------------------------------------------------------------------------
ENTITY eightBitFA IS
	PORT(
		i_Ai, i_Bi		: IN	std_logic_vector(3 downto 0);
		i_Cin			: IN	std_logic;
		o_Cout			: OUT	std_logic;
		o_Sum			: OUT	std_logic_vector(3 downto 0));

END ENTITY eightBitFA;
-------------------------------------------------------------------------------
ARCHITECTURE rtl OF eightBitFA IS
	SIGNAL int_Sum, int_Cout : STD_LOGIC_VECTOR(3 downto 0);
	
	COMPONENT oneBitFA
		PORT( 
			i_x		:IN std_logic;
			i_y		:IN std_logic;
			i_cin	:IN	std_logic;
			o_sum	:OUT std_logic;
			o_cout	:OUT std_logic);
	END COMPONENT oneBitFA;
	
BEGIN
	
	--  Concurrent Signal Assignment
	
	add0: oneBitFA
		port map (
			i_x => i_Ai(0),
			i_y => i_Bi(0),
			i_cin => i_Cin,
			o_sum => int_Sum(0),
			o_cout => int_Cout(0));
	
	add1: oneBitFA
		port map (
			i_x => i_Ai(1),
			i_y => i_Bi(1),
			i_cin => int_Cout(0),
			o_sum => int_Sum(1),
			o_cout => int_Cout(1));
			
	add2: oneBitFA
		port map (
			i_x => i_Ai(2),
			i_y => i_Bi(2),
			i_cin => int_Cout(1),
			o_sum => int_Sum(2),
			o_cout => int_Cout(2));
			
	add3: oneBitFA
		port map (
			i_x => i_Ai(3),
			i_y => i_Bi(3),
			i_cin => int_Cout(2),
			o_sum => int_Sum(3),
			o_cout => int_Cout(3));

    add4: oneBitFA
		port map (
			i_x => i_Ai(4),
			i_y => i_Bi(4),
			i_cin => int_Cout(3),
			o_sum => int_Sum(4),
			o_cout => int_Cout(4));

    add5: oneBitFA
		port map (
			i_x => i_Ai(5),
			i_y => i_Bi(5),
			i_cin => int_Cout(4),
			o_sum => int_Sum(5),
			o_cout => int_Cout(5));
    
    add6: oneBitFA
		port map (
			i_x => i_Ai(6),
			i_y => i_Bi(6),
			i_cin => int_Cout(5),
			o_sum => int_Sum(6),
			o_cout => int_Cout(6));
    
    add7: oneBitFA
		port map (
			i_x => i_Ai(7),
			i_y => i_Bi(7),
			i_cin => int_Cout(6),
			o_sum => int_Sum(7),
			o_cout => int_Cout(7));
	
	
	--  Output Driver
	o_Sum <= int_Sum;
	o_Cout <= int_Cout(7);

end architecture rtl;
-------------------------------------------------------------------------------