-------------------------------------------------------------------------------
-- Title		: ALU Control Unit
-- file			: aluContolUnit.vhd
-- Project		: Single-cycle processor
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------
-- ENTITY
-------------------------------------------------------------------------------
ENTITY aluControlUnit IS
	PORT(
		i_ALUop         :IN std_logic_vector(1 downto 0);
		i_Function  	:IN std_logic_vector(4 downto 0);
		o_Operation		:OUT std_logic_vector(2 downto 0)
        );

END ENTITY aluControlUnit;
-------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------
ARCHITECTURE rtl OF aluContolUnit IS

SIGNAL int_Operation        : std_logic_vector(2 downto 0);
SIGNAL int_AND, int_OR 	    :std_logic;

	
BEGIN
    
    --  Concurrent Signal Assignment
	
	int_AND <= i_ALUop(1) AND i_Function(1);
    int_OR <= i_Function(3) and i_Function(0);

    int_Operation(2) <= i_ALUop(0) OR int_AND;
    int_Operation(1) <= NOT(i_ALUop(1)) OR NOT(i_Function(2));
    int_Operation(0) <= i_ALUop(1) AND int_OR;

	--  Output Driver
	o_Operation <= int_Operation;

END ARCHITECTURE rtl;
-------------------------------------------------------------------------------