--------------------------------------------------------------------------------
-- Title         : 1-Bit Full Adder
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : fullAdder1Bit.vhd


LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fullAdder1Bit IS 
	PORT
	(
		A :  IN  STD_LOGIC;
		B :  IN  STD_LOGIC;
		Ci :  IN  STD_LOGIC;
		S :  OUT  STD_LOGIC;
		Co :  OUT  STD_LOGIC
	);
END fullAdder1Bit;

ARCHITECTURE bdf_type OF fullAdder1Bit IS 

SIGNAL	int_wire4 :  STD_LOGIC;
SIGNAL	int_wire1 :  STD_LOGIC;
SIGNAL	int_wire2 :  STD_LOGIC;


BEGIN 

    int_wire4 <= A XOR B;


    S <= int_wire4 XOR Ci;


    Co <= int_wire1 OR int_wire2;


    int_wire2 <= Ci AND int_wire4;


    int_wire1 <= A AND B;


END bdf_type;