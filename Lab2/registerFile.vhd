-------------------------------------------------------------------------------
-- Title		: Register File
-- file			: registerFile.vhd
-- Project		: Single-cycle processor
-------------------------------------------------------------------------------
-----
-- ToDo: ...  
-----

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------
-- ENTITY
-------------------------------------------------------------------------------
ENTITY registerFile IS
	PORT(
		i_GReset, i_clock : IN STD_LOGIC;
		i_enable : IN STD_LOGIC; -- RegWrite signal --

		i_readOne 		: IN STD_LOGIC_VECTOR(2 downto 0);
		i_readTwo 		: IN STD_LOGIC_VECTOR(2 downto 0);
		i_writeReg 		: IN STD_LOGIC_VECTOR(2 downto 0);
		i_writeData 	: IN STD_LOGIC_VECTOR(7 downto 0);

		o_readDataOne 	: OUT STD_LOGIC_VECTOR(7 downto 0);
		o_readDataTwo 	: OUT STD_LOGIC_VECTOR(7 downto 0)
	);

END ENTITY registerFile;
-------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------
ARCHITECTURE rtl OF registerFile IS

	signal int_readOne, int_readTwo, int_writeReg							:STD_LOGIC_VECTOR(7 downto 0);
	signal int_writeData, int_dataOne, int_dataTwo							:STD_LOGIC_VECTOR(7 downto 0);
	signal int_q0, int_q1, int_q2, int_q3, int_q4, int_q5, int_q6, int_q7	:STD_LOGIC_VECTOR(7 downto 0); -- registers outputs --

	int_writeData = i_writeData;
	
	-- Components
	COMPONENT threeToEightDecoder
		PORT(
			--i_GReset, i_clock   : IN STD_LOGIC; -- Are these needed?
			i_enable            : IN STD_LOGIC;
			i_code			    :IN STD_LOGIC_VECTOR(2 downto 0);
			o_addr			    :OUT STD_LOGIC_VECTOR(7 downto 0);
		);
	END COMPONENT;

	COMPONENT eightBitRegister
		PORT ( 
			i_GReset, i_clock 	: IN STD_LOGIC;
			i_enable 			: IN STD_LOGIC;
			i_A 				: IN STD_LOGIC_VECTOR(7 downto 0);
			o_q 				: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;

	COMPONENT eightBitTriStateBuffer
		PORT(
			i_en               :IN STD_LOGIC;
			i_a                :IN STD_LOGIC_VECTOR(7 downto 0);
			o_y			       :OUT STD_LOGIC_VECTOR(7 downto 0);
		);
	END COMPONENT;
	
BEGIN

-- DECODERS --

	decoderReadOne: threeToEightDecoder
		PORT MAP (
			i_enable 	=>	NOT(i_enable);
			i_code		=> 	i_readOne;
			o_addr		=> 	int_readOne
		);
	
	decoderReadTwo: threeToEightDecoder
		PORT MAP (
			i_enable 	=>	NOT(i_enable);
			i_code		=> 	i_readTwo;
			o_addr		=> 	int_readTwo
		);

	decoderWriteReg: threeToEightDecoder
		PORT MAP (
			i_enable 	=>	i_enable;
			i_code		=> 	i_writeReg;
			o_addr		=> 	int_writeReg
		);

-- REGISTERS --

	zero: eightBitRegister
		PORT MAP (
			i_GReset => i_Greset,
			i_clock => i_clk,
			i_enable => int_writeReg(0),
			i_A => int_writeData,
			o_q => int_q0
		);
		
	one: eightBitRegister
		PORT MAP (
			i_GReset => i_Greset,
			i_clock => i_clk,
			i_enable => int_writeReg(1),
			i_A => int_writeData,
			o_q => int_q1
		);
		
	two: eightBitRegister
		PORT MAP (
			i_GReset => i_Greset,
			i_clock => i_clk,
			i_enable => int_writeReg(2),
			i_A => int_writeData,
			o_q => int_q2
		);
	
	three: eightBitRegister
		PORT MAP (
			i_GReset => i_Greset,
			i_clock => i_clk,
			i_enable => int_writeReg(3),
			i_A => int_writeData,
			o_q => int_q3
		);
	
	four: eightBitRegister
		PORT MAP (
			i_GReset => i_Greset,
			i_clock => i_clk,
			i_enable => int_writeReg(4),
			i_A => int_writeData,
			o_q => int_q4
		);
		
	five: eightBitRegister
		PORT MAP (
			i_GReset => i_Greset,
			i_clock => i_clk,
			i_enable => int_writeReg(5),
			i_A => int_writeData,
			o_q => int_q5
		);
		
	six: eightBitRegister
		PORT MAP (
			i_GReset => i_Greset,
			i_clock => i_clk,
			i_enable => int_writeReg(6),
			i_A => int_writeData,
			o_q => int_q6
		);
	
	seven: eightBitRegister
		PORT MAP (
			i_GReset => i_Greset,
			i_clock => i_clk,
			i_enable => int_writeReg(7),
			i_A => int_writeData,
			o_q => int_q8
		);

-- TRI-STATE-BUFFERS --

	readOne0:
		PORT(
			i_en 	=>	int_readOne(0)
			i_a		=>	int_q0
			o_y		=>	---???
		);
	readOne1:
		PORT(
			i_en 	=>	int_readOne(1)
			i_a		=>	int_q1
			o_y		=>	---???
		);

	-- ... Insert other readOne buffers ... --

	readTwo0:
		PORT(
			i_en 	=>	int_readTwo(0)
			i_a		=>	int_q0
			o_y		=>	---???
		);
	readTwo1:
		PORT(
			i_en 	=>	int_readTwo(1)
			i_a		=>	int_q1
			o_y		=>	---???
		);

	-- ... Insert other readOne buffers ... --


	-- Output Driver
	
	o_readDataOne		<= int_answerOne; -- STUCKED HERE --
	o_readDataTwo		<= int_answerTwo;

END ARCHITECTURE rtl;
-------------------------------------------------------------------------------