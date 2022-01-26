--------------------------------------------------------------------------------
-- Title         : Floating-Point Adder Control Path
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : fpAdderControl.vhd

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpAdderControl IS
	PORT ( 
		i_GReset, i_GClock			: IN	STD_LOGIC;
		i_sign, i_notLess9, i_zero, i_coutFz	: IN	STD_LOGIC;
		o_loadREx, o_loadREy, o_loadRFx, o_loadRFy	: OUT	STD_LOGIC;
		o_loadRFz, o_loadREz, o_loadExpDiff, o_cin	: OUT 	STD_LOGIC;
		o_on22, o_on21, o_flag0, o_flag1	: OUT	STD_LOGIC;
		o_clearRFy, o_clearRFx, o_shiftRFy, o_shiftRFx: OUT	STD_LOGIC;
		o_countD, o_countU, o_shiftRFz, o_done	: OUT	STD_LOGIC;
		o_state					: OUT	STD_LOGIC_VECTOR(0 to 9));
END fpAdderControl;

ARCHITECTURE rtl of fpAdderControl IS

COMPONENT enARdFF_2
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END COMPONENT;

COMPONENT enASdFF
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END COMPONENT;

SIGNAL int_state, int_d : STD_LOGIC_VECTOR(0 to 9);

BEGIN

int_d(0) <= '0';
int_d(1) <= int_state(0);
int_d(2) <= int_state(1) AND i_sign;
int_d(3) <= int_state(1) AND NOT(i_sign) AND i_notLess9;
int_d(4) <= (int_state(1) AND NOT(i_sign) AND NOT(i_notLess9) AND NOT(i_zero)) OR (int_state(4) AND NOT(i_zero));
int_d(5) <= int_state(2) AND i_notLess9;
int_d(6) <= (int_state(2) AND NOT(i_notLess9) AND NOT(i_zero)) OR (int_state(6) AND NOT(i_zero));
int_d(7) <= int_state(3) OR (int_state(4) AND i_zero) OR (int_state(2) AND NOT(i_notLess9) AND i_zero) OR (int_state(1) AND NOT(i_sign) AND NOT(i_notLess9) AND i_zero) OR int_state(5) OR (int_state(6) AND i_zero);
int_d(8) <= int_state(7) AND i_coutFz;
int_d(9) <= int_state(8) OR int_state(9) OR (int_state(7) AND NOT(i_coutFz));

s0: enASdFF
	PORT MAP ( 	i_resetBar => i_GReset,
			i_d => int_d(0),
			i_enable => '1',
			i_clock => i_GClock,
			o_q => int_state(0));

s1: enARdFF_2
	PORT MAP ( 	i_resetBar => i_GReset,
			i_d => int_d(1),
			i_enable => '1',
			i_clock => i_GClock,
			o_q => int_state(1));

s2: enARdFF_2
	PORT MAP ( 	i_resetBar => i_GReset,
			i_d => int_d(2) ,
			i_enable => '1',
			i_clock => i_GClock,
			o_q => int_state(2));

s3: enARdFF_2
	PORT MAP ( 	i_resetBar => i_GReset,
			i_d => int_d(3),
			i_enable => '1',
			i_clock => i_GClock,
			o_q => int_state(3));

s4: enARdFF_2
	PORT MAP ( 	i_resetBar => i_GReset,
			i_d => int_d(4),
			i_enable => '1',
			i_clock => i_GClock,
			o_q => int_state(4));

s5: enARdFF_2
	PORT MAP ( 	i_resetBar => i_GReset,
			i_d => int_d(5),
			i_enable => '1',
			i_clock => i_GClock,
			o_q => int_state(5));

s6: enARdFF_2
	PORT MAP ( 	i_resetBar => i_GReset,
			i_d => int_d(6),
			i_enable => '1',
			i_clock => i_GClock,
			o_q => int_state(6));

s7: enARdFF_2
	PORT MAP ( 	i_resetBar => i_GReset,
			i_d => int_d(7),
			i_enable => '1',
			i_clock => i_GClock,
			o_q => int_state(7));

s8: enARdFF_2
	PORT MAP ( 	i_resetBar => i_GReset,
			i_d => int_d(8),
			i_enable => '1',
			i_clock => i_GClock,
			o_q => int_state(8));

s9: enARdFF_2
	PORT MAP ( 	i_resetBar => i_GReset,
			i_d => int_d(9),
			i_enable => '1',
			i_clock => i_GClock,
			o_q => int_state(9));

	--Output drivers
	o_state <= int_state;

	o_loadREx <= int_state(0);
	o_loadREy <= int_state(0);
	o_loadRFx <= int_state(0);
	o_loadRFy <= int_state(0);

	o_on22 <= int_state(1);
	o_flag0 <= int_state(1);

	o_on21 <= int_state(2);
	o_flag1 <= int_state(2);

	o_clearRFx <= int_state(3);

	o_shiftRFx <= int_state(4);

	o_clearRFy <= int_state(5);

	o_shiftRFy <= int_state(6);

	o_loadRFz <= int_state(7);
	o_loadREz <= int_state(7);

	o_shiftRFz <= int_state(8);
	o_countU <= int_state(8);

	o_cin <= int_state(1) OR int_state(2);
	o_loadExpDiff <= int_state(1) OR int_state(2);
	o_countD <= int_state(4) OR int_state(6);
	o_done <= int_state(9);
END rtl;
		
