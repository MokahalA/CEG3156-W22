--------------------------------------------------------------------------------
-- Title         : 16-bit Floating-Point Adder (Top-level entity, include Datapath)
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : fpAdder.vhd

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpAdder IS
	PORT ( GClock, GReset           : IN    STD_LOGIC;
	       SignA, SignB 		: IN 	STD_LOGIC;
	       MantissaA, MantissaB     : IN    STD_LOGIC_VECTOR(7 downto 0);
	       ExponentA, ExponentB     : IN    STD_LOGIC_VECTOR(6 downto 0);
	       SignOut                  : OUT   STD_LOGIC;
	       MantissaOut              : OUT   STD_LOGIC_VECTOR(7 downto 0);
	       ExponentOut		: OUT	STD_LOGIC_VECTOR(6 downto 0);
	       Overflow			: OUT 	STD_LOGIC);
END fpAdder;

ARCHITECTURE rtl OF fpAdder IS

COMPONENT sevenBitRegister
	PORT (  i_GReset	: IN	STD_LOGIC;
		i_clock 	: IN	STD_LOGIC;
		i_E		: IN	STD_LOGIC_VECTOR(6 downto 0);
		i_load 		: IN	STD_LOGIC;
		o_E		: OUT	STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT;

COMPONENT eightBitComplementer
	PORT (	i_A		: IN	STD_LOGIC_VECTOR(7 downto 0);
		i_enable	: IN	STD_LOGIC;
		o_q		: OUT	STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT eightBitAdder
	PORT ( 		i_x		: IN STD_LOGIC_VECTOR(7 downto 0);
			i_y		: IN STD_LOGIC_VECTOR(7 downto 0);
			i_cin		: IN STD_LOGIC;
			o_sign		: OUT STD_LOGIC;
			o_s		: OUT STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT;

COMPONENT sevenBitDownCounter
	PORT(
		i_resetBar, i_load, i_countD	: IN	STD_LOGIC;
		i_A				: IN 	STD_LOGIC_VECTOR(6 downto 0);
		i_clock				: IN	STD_LOGIC;
		o_zero				: OUT	STD_LOGIC;
		o_q				: OUT	STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT;

COMPONENT sevenBitComparator
	PORT(
		i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(6 downto 0);
		o_GT, o_LT, o_EQ		: OUT	STD_LOGIC);
END COMPONENT;

COMPONENT sevenBit2x1MUX
	PORT (
		i_sel		: IN	STD_LOGIC;
		i_A		: IN	STD_LOGIC_VECTOR(6 downto 0);
		i_B		: IN	STD_LOGIC_VECTOR(6 downto 0);
		o_q		: OUT	STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT;

COMPONENT srlatch
	PORT(
		i_set, i_reset		: IN	STD_LOGIC;
		o_q, o_qBar		: OUT	STD_LOGIC);
END COMPONENT;

COMPONENT sevenBitUpCounter
	PORT(
		i_resetBar, i_load, i_countU	: IN	STD_LOGIC;
		i_A				: IN 	STD_LOGIC_VECTOR(6 downto 0);
		i_clock				: IN	STD_LOGIC;
		o_q				: OUT	STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT;

COMPONENT nineBitShiftRegister
	PORT ( 
		i_resetBar, i_clock 			: IN 	STD_LOGIC;	 
		i_load, i_clear, i_shift		: IN	STD_LOGIC;
		i_A					: IN	STD_LOGIC_VECTOR(8 downto 0);
		o_q					: OUT	STD_LOGIC_VECTOR(8 downto 0));
END COMPONENT;

COMPONENT nineBitAdder
	PORT ( 	i_resetBar, i_clock : IN STD_LOGIC;	
		i_x		: IN STD_LOGIC_VECTOR(8 downto 0);
		i_y		: IN STD_LOGIC_VECTOR(8 downto 0);
		i_cin		: IN STD_LOGIC;
		o_cout		: OUT STD_LOGIC;
		o_q		: OUT STD_LOGIC_VECTOR(8 downto 0));
END COMPONENT;

COMPONENT fpAdderControl
	PORT ( 
		i_GReset, i_GClock			: IN	STD_LOGIC;
		i_sign, i_notLess9, i_zero, i_coutFz	: IN	STD_LOGIC;
		o_loadREx, o_loadREy, o_loadRFx, o_loadRFy	: OUT	STD_LOGIC;
		o_loadRFz, o_loadREz, o_loadExpDiff, o_cin	: OUT 	STD_LOGIC;
		o_on22, o_on21, o_flag0, o_flag1	: OUT	STD_LOGIC;
		o_clearRFy, o_clearRFx, o_shiftRFy, o_shiftRFx: OUT	STD_LOGIC;
		o_countD, o_countU, o_shiftRFz, o_done	: OUT	STD_LOGIC;
		o_state					: OUT	STD_LOGIC_VECTOR(0 to 9));
END COMPONENT;

--S0
SIGNAL		int_loadREx, int_loadREy, int_loadRFx, int_loadRFy	: 	STD_LOGIC;

--S1
SIGNAL		int_on22, int_flag0				:	STD_LOGIC;

--S2
SIGNAL		int_on21, int_flag1				:	STD_LOGIC;

--S1 & S2
SIGNAL 		int_cin, int_loadExpDiff				:	STD_LOGIC;

--S3
SIGNAL int_clearRFx						:	STD_LOGIC;

--S4
SIGNAL int_shiftRFx						:	STD_LOGIC;

--S5
SIGNAL int_clearRFy						:	STD_LOGIC;

--S6					
SIGNAL int_shiftRFy						:	STD_LOGIC;

--S4 & S6
SIGNAL int_countD						:	STD_LOGIC;

--S7
SIGNAL int_loadRFz, int_loadREz					:	STD_LOGIC;

--S8
SIGNAL int_shiftRFz, int_countU, int_clearRFz					:	STD_LOGIC;

--S9
SIGNAL int_done							:	STD_LOGIC;

--Status/State
SIGNAL int_sign, int_notLess9, int_zero, int_coutFz		:	STD_LOGIC;
SIGNAL int_state						:	STD_LOGIC_VECTOR(0 to 9);				


--Datapath signals
SIGNAL int_Ex, int_Ey			 :	STD_LOGIC_VECTOR(6 downto 0);

SIGNAL int_ExComplementIn, int_EyComplementIn	:	STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_xComplement, int_yComplement  :	STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_Ediff			 :	STD_LOGIC_VECTOR(6 downto 0);
SIGNAL int_EtoComparator		 :	STD_LOGIC_VECTOR(6 downto 0);
SIGNAL int_GT, int_LT, int_EQ		 :	STD_LOGIC;
SIGNAL int_FLAG				 :	STD_LOGIC;
SIGNAL int_Ez, int_REz			 :	STD_LOGIC_VECTOR(6 downto 0);
SIGNAL int_FxShifted, int_FyShifted	 :	STD_LOGIC_VECTOR(8 downto 0);
SIGNAL int_mantissaSum			 : 	STD_LOGIC_VECTOR(8 downto 0);
SIGNAL int_RFz				 : 	STD_LOGIC_VECTOR(8 downto 0);

SIGNAL int_Fx, int_Fy			:	STD_LOGIC_VECTOR(8 downto 0);

BEGIN

int_notLess9 <= int_GT AND NOT(int_EQ) AND NOT(int_LT);

int_ExComplementIn <= '0' & int_Ex;
int_EyComplementIn <= '0' & int_Ey;

int_sign <= '0' WHEN (ExponentA > ExponentB) ELSE '1';

int_Fx <= '1' & MantissaA;
int_Fy <= '1' & MantissaB;

int_clearRFz <= '0';

controller: fpAdderControl
	PORT MAP (	i_GReset => GReset,
			i_GClock => GClock,
			i_sign => int_sign,
			i_notLess9 => int_notLess9,
			i_zero => int_zero,
			i_coutFz => int_coutFz,
			o_loadREx => int_loadREx,
			o_loadREy => int_loadREy,
			o_loadRFx => int_loadRFx,
			o_loadRFy => int_loadRFy,
			o_loadRFz => int_loadRFz,
			o_loadExpDiff => int_loadExpDiff,
			o_loadREz => int_loadREz,
			o_cin => int_cin,
			o_on22 => int_on22,
			o_on21 => int_on21,
			o_flag0 => int_flag0,
			o_flag1 => int_flag1,
			o_clearRFx => int_clearRFx,
			o_clearRFy => int_clearRFy,
			o_shiftRFy => int_shiftRFy,
			o_shiftRFx => int_shiftRFx,
			o_countD => int_countD,
			o_countU => int_countU,
			o_shiftRFz => int_shiftRFz,
			o_done => int_done,
			o_state => int_state);
Ex: sevenBitRegister
	PORT MAP (	i_GReset => GReset,
			i_clock => GClock,
			i_E => ExponentA,
			i_load => int_loadREx,
			o_E => int_Ex);

Ey: sevenBitRegister
	PORT MAP (	i_GReset => GReset,
			i_clock => GClock,
			i_E => ExponentB,
			i_load => int_loadREy,
			o_E => int_Ey);

complementerX: eightBitComplementer
	PORT MAP (	i_A => int_ExComplementIn,
			i_enable => int_on21,
			o_q => int_xComplement);

complementerY: eightBitComplementer
	PORT MAP (	i_A => int_EyComplementIn,
			i_enable => int_on22,
			o_q => int_yComplement);

expAdder: eightBitAdder
	PORT MAP (	i_x => int_xComplement,
			i_y => int_yComplement,
			i_cin => int_cin,
			o_sign => open,
			o_s => int_Ediff);

expCounter: sevenBitDownCounter
	PORT MAP (	i_resetBar => GReset,
			i_load => int_loadExpDiff,
			i_countD => int_countD,
			i_A => int_Ediff,
			i_clock => GClock,
			o_zero => int_zero,
			o_q => int_EtoComparator);

expComparator: sevenBitComparator
	PORT MAP (	i_Ai => int_EtoComparator,
			i_Bi => "0001000",
			o_GT => int_GT,
			o_LT => int_LT,
			o_EQ => int_EQ);

expSRLatch: srlatch
	PORT MAP (	i_set => int_flag1,
			i_reset => int_flag0,
			o_q => int_FLAG);

expSelect: sevenBit2x1MUX
	PORT MAP (	i_sel => int_FLAG,
			i_A => int_Ex,
			i_B => int_Ey,
			o_q => int_Ez);

expUpCounter: sevenBitUpCounter
	PORT MAP (	i_resetBar => GReset,
			i_load => int_loadREz,
			i_countU => int_countU,
			i_A => int_Ez,
			i_clock => GClock,
			o_q => int_REz);

Fx: nineBitShiftRegister
	PORT MAP (	i_resetBar => GReset,
			i_clock => GClock,
			i_load => int_loadRFx,
			i_shift => int_shiftRFx,
			i_clear => int_clearRFx,
			i_A => int_Fx,
			o_q => int_FxShifted);

Fy: nineBitShiftRegister
	PORT MAP (	i_resetBar => GReset,
			i_clock => GClock,
			i_load => int_loadRFy,
			i_shift => int_shiftRFy,
			i_clear => int_clearRFy,
			i_A => int_Fy,
			o_q => int_FyShifted);

mantissaAdder: nineBitAdder
	PORT MAP (	i_resetBar => GReset,
			i_clock => GClock,
			i_x => int_FxShifted,
			i_y => int_FyShifted,
			i_cin => '0',
			o_cout => int_coutFz,
			o_q => int_mantissaSum);

normalizer: nineBitShiftRegister
	PORT MAP (	i_resetBar => GReset,
			i_clock => GClock,
			i_load => int_loadRFz,
			i_shift => int_shiftRFz,
			i_clear => int_clearRFz,
			i_A => int_mantissaSum,
			o_q => int_RFz);

	--Output Drivers
	SignOut <= SignA WHEN (ExponentA > ExponentB) ELSE
		   SignB WHEN (ExponentB > ExponentA) ELSE
		   SignA WHEN (MantissaA > MantissaB) ELSE
		   SignB WHEN (MantissaB > MantissaA) ELSE
		   SignA;
	Overflow <= '1' WHEN (int_REz > "1111110") else '0';
	MantissaOut <= int_RFz(7 downto 0);
	ExponentOut <= int_REz;
	
			
END rtl;