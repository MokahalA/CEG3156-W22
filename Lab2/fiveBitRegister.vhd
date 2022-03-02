--------------------------------------------------------------------------------
-- Title         : 5-Bit Register
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : fiveBitRegister.vhd

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fiveBitRegister IS
	PORT ( 
		i_GReset, i_clock : IN STD_LOGIC;
		i_enable : IN STD_LOGIC;
		i_A : IN STD_LOGIC_VECTOR(4 downto 0);
		o_q : OUT STD_LOGIC_VECTOR(4 downto 0));
END fiveBitRegister;

ARCHITECTURE rtl OF fiveBitRegister IS

COMPONENT enardFF
	PORT (
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END COMPONENT;

SIGNAL int_q : STD_LOGIC_VECTOR(4 downto 0);

BEGIN

bit4: enardFF
	PORT MAP (	i_resetBar => i_GReset,
			i_clock => i_clock,
			i_d => i_A(4),
			i_enable => i_enable,
			o_q => int_q(4));

bit3: enardFF
	PORT MAP (	i_resetBar => i_GReset,
			i_clock => i_clock,
			i_d => i_A(3),
			i_enable => i_enable,
			o_q => int_q(3));

bit2: enardFF
	PORT MAP (	i_resetBar => i_GReset,
			i_clock => i_clock,
			i_d => i_A(2),
			i_enable => i_enable,
			o_q => int_q(2));

bit1: enardFF
	PORT MAP (	i_resetBar => i_GReset,
			i_clock => i_clock,
			i_d => i_A(1),
			i_enable => i_enable,
			o_q => int_q(1));

bit0: enardFF
	PORT MAP (	i_resetBar => i_GReset,
			i_clock => i_clock,
			i_d => i_A(0),
			i_enable => i_enable,
			o_q => int_q(0));

	--Output driver
	o_q <= int_q;

END rtl;