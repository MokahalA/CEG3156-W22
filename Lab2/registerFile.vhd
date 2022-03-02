-------------------------------------------------------------------------------
-- Title		: Register File
-- file			: registerFile.vhd
-- Project		: Single-cycle processor
-------------------------------------------------------------------------------
-----
-- ToDo: check how outputs are obtained, and what to do with input data.  
-----

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------
-- ENTITY
-------------------------------------------------------------------------------
ENTITY registerFile IS
	PORT(
		i_clk				:IN STD_LOGIC;
		i_Greset			:IN STD_LOGIC;
		i_enable			:IN STD_LOGIC;
		i_regWrite			:IN STD_LOGIC; -- control signal
		i_readOne			:IN STD_LOGIC_VECTOR(4 downto 0);
		i_readTwo			:IN STD_LOGIC_VECTOR(4 downto 0);
		i_writeReg			:IN STD_LOGIC_VECTOR(4 downto 0);
		i_writeData			:IN STD_LOGIC_VECTOR(7 downto 0);
		
		o_ReadOne			:OUT STD_LOGIC_VECTOR(7 downto 0);
		o_ReadTwo			:OUT STD_LOGIC_VECTOR(7 downto 0)
	);

END ENTITY registerFile;
-------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------
ARCHITECTURE rtl OF registerFile IS

	signal int_readOne, int_readTwo, int_writeReg, int_writeData	:STD_LOGIC_VECTOR(7 downto 0);
	
	-- Components

	COMPONENT fiveBitRegister
		PORT ( 
			i_GReset, i_clock : IN STD_LOGIC;
			i_enable : IN STD_LOGIC;
			i_A : IN STD_LOGIC_VECTOR(7 downto 0);
			o_q : OUT STD_LOGIC_VECTOR(7 downto 0)
			);
	END COMPONENT;
	
BEGIN

	readOne: fiveBitRegister
		PORT MAP (
			i_GReset => i_Greset,
			i_clock => i_clk,
			i_enable => i_enable,
			i_A => i_readOne,
			o_q => int_readOne
		);
		
	readTwo: fiveBitRegister
		PORT MAP (
			i_GReset => i_Greset,
			i_clock => i_clk,
			i_enable => i_enable,
			i_A => i_readTwo,
			o_q => int_readTwo
		);
		
	writeReg: fiveBitRegister
		PORT MAP (
			i_GReset => i_Greset,
			i_clock => i_clk,
			i_enable => i_enable,
			i_A => i_writeReg,
			o_q => int_writeReg
		);
	
	writeData: eightBitRegister
		PORT MAP (
			i_GReset => i_Greset,
			i_clock => i_clk,
			i_enable => i_enable,
			i_A => i_writeData,
			o_q => int_writeData
		);

	-- Output Driver
	
	o_readOne		<= int_answerOne; -- I will modify this later!!
	o_readTwo		<= int_answerTwo;

END ARCHITECTURE rtl;
-------------------------------------------------------------------------------