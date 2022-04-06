--------------------------------------------------------------------------------
-- Title         : 4-Bit Register
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : fourBitRegister.vhd

library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fourBitRegister IS
	PORT(
		i_resetBar, i_en	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(3 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(3 downto 0)
	);
END fourBitRegister;

ARCHITECTURE rtl OF fourBitRegister IS
	SIGNAL q_value, q_notvalue : STD_LOGIC_VECTOR(3 downto 0);

	COMPONENT enardFF
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

	BEGIN
	
	b0: enardFF PORT MAP (i_resetBar, i_Value(0), i_en, i_clock, q_value(0), q_notvalue(0));
	b1: enardFF PORT MAP (i_resetBar, i_Value(1), i_en, i_clock, q_value(1), q_notvalue(1));
	b2: enardFF PORT MAP (i_resetBar, i_Value(2), i_en, i_clock, q_value(2), q_notvalue(2));
	b3: enardFF PORT MAP (i_resetBar, i_Value(3), i_en, i_clock, q_value(3), q_notvalue(3));

	-- Output Driver
	o_Value		<= q_value;

END rtl;