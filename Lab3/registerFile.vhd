-------------------------------------------------------------------------------
-- Title		: Register File (8 registers, Read/Write control)
-- file			: registerFile.vhd
-- Project		: Single Cycle Processor
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registerFile IS
	PORT(
		i_reset, i_clock : IN STD_LOGIC;
		i_RegWrite : IN STD_LOGIC; -- RegWrite control signal --
		readRegister1 : IN STD_LOGIC_VECTOR(4 downto 0);  --We only use bits 0-2 of the ports
		readRegister2 : IN STD_LOGIC_VECTOR(4 downto 0);  
		writeRegister : IN STD_LOGIC_VECTOR(4 downto 0);
		writeData : IN STD_LOGIC_VECTOR(7 downto 0);
		readData1 : OUT STD_LOGIC_VECTOR(7 downto 0);
		readData2 : OUT STD_LOGIC_VECTOR(7 downto 0)
	);

END ENTITY registerFile;

ARCHITECTURE rtl OF registerFile IS

	signal decodeOut, regOut0, regOut1, regOut2, regOut3, regOut4, regOut5, regOut6, regOut7 : STD_LOGIC_VECTOR(7 downto 0);
	signal temp : STD_LOGIC_VECTOR(7 downto 0);

	component eightBitRegister is 
		PORT ( 
			i_GReset, i_clock : IN STD_LOGIC;
			i_enable : IN STD_LOGIC;
			i_A : IN STD_LOGIC_VECTOR(7 downto 0);
			o_q : OUT STD_LOGIC_VECTOR(7 downto 0));
	end component;

	component threeToEightDecoder is
		port(
			A: in std_logic_vector(2 downto 0);
			Y: out std_logic_vector(7 downto 0)
		);
	end component;

	component threeToEightMux is 
		port (
			a1, a2, a3, a4, a5, a6, a7, a8: in std_logic_vector(7 downto 0);
			s: in std_logic_vector(2 downto 0);
			m: out std_logic_vector(7 downto 0)
		);
	end component;

BEGIN
	decode: threeToEightDecoder port map(writeRegister(2 downto 0), decodeOut);

	temp(0) <= i_RegWrite and decodeOut(7);
	temp(1) <= i_RegWrite and decodeOut(6);
	temp(2) <= i_RegWrite and decodeOut(5);
	temp(3) <= i_RegWrite and decodeOut(4);
	temp(4) <= i_RegWrite and decodeOut(3);
	temp(5) <= i_RegWrite and decodeOut(2);
	temp(6) <= i_RegWrite and decodeOut(1);
	temp(7) <= i_RegWrite and decodeOut(0);

	Reg0: eightBitRegister port map(i_reset, i_clock, temp(0), writeData, regOut0);
	Reg1: eightBitRegister port map(i_reset, i_clock, temp(1), writeData, regOut1);
	Reg2: eightBitRegister port map(i_reset, i_clock, temp(2), writeData, regOut2);
	Reg3: eightBitRegister port map(i_reset, i_clock, temp(3), writeData, regOut3);
	Reg4: eightBitRegister port map(i_reset, i_clock, temp(4), writeData, regOut4);
	Reg5: eightBitRegister port map(i_reset, i_clock, temp(5), writeData, regOut5);
	Reg6: eightBitRegister port map(i_reset, i_clock, temp(6), writeData, regOut6);
	Reg7: eightBitRegister port map(i_reset, i_clock, temp(7), writeData, regOut7);

	mux1: threeToEightMux port map(regOut0, regOut1, regOut2, regOut3, regOut4, regOut5, regOut6, regOut7, readRegister1(2 downto 0), readData1);
	mux2: threeToEightMux port map(regOut0, regOut1, regOut2, regOut3, regOut4, regOut5, regOut6, regOut7, readRegister2(2 downto 0), readData2);


END ARCHITECTURE rtl;
