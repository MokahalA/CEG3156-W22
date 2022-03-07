--------------------------------------------------------------------------------
-- Title         : Instruction Memory Block (ROM)
-- Project       : VHDL Synthesis Overview
-- Designed using the Intel LPM_ROM core documentation
-------------------------------------------------------------------------------
-- File          : instructionMemory.vhd


LIBRARY ieee;
LIBRARY lpm;
USE ieee.std_logic_1164.ALL;
USE lpm.lpm_components.ALL;

ENTITY instructionMemory IS
	PORT (	i_inclock, i_outclock 	: IN  STD_LOGIC;
			readAddress 			: IN  STD_LOGIC_VECTOR(7 downto 0);
			o_q 			: OUT STD_LOGIC_VECTOR(31 downto 0));
END instructionMemory;

ARCHITECTURE struct OF instructionMemory IS

COMPONENT LPM_ROM
        GENERIC (	
			LPM_WIDTH : NATURAL;    -- MUST be greater than 0
            LPM_WIDTHAD : NATURAL;    -- MUST be greater than 0
			LPM_NUMWORDS : NATURAL := 0;
			LPM_ADDRESS_CONTROL : STRING := "REGISTERED";
			LPM_OUTDATA : STRING := "REGISTERED";
			LPM_FILE : STRING;
			LPM_TYPE : STRING := L_ROM;
			INTENDED_DEVICE_FAMILY  : STRING := "UNUSED";
			LPM_HINT : STRING := "UNUSED");
	    PORT (		
			ADDRESS : in STD_LOGIC_VECTOR(LPM_WIDTHAD-1 downto 0);
			INCLOCK : IN STD_LOGIC := '0';
			OUTCLOCK : IN STD_LOGIC := '0';
			MEMENAB : IN STD_LOGIC := '1';
			Q : OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 downto 0));
END COMPONENT;

CONSTANT instructionsFile : STRING := "instructions.mif"; --Instructions are stored here

SIGNAL int_q : STD_LOGIC_VECTOR(31 downto 0);

BEGIN
	
instructionMem: LPM_ROM 
	GENERIC MAP (		
                LPM_WIDTH => 32,
				LPM_WIDTHAD => 8,
				LPM_NUMWORDS => 256,
				LPM_FILE => instructionsFile)
	PORT MAP (		
                ADDRESS => readAddress,
				INCLOCK => i_inclock,
				OUTCLOCK => i_outclock,
				MEMENAB => '1',
				Q => int_q);

	--Output driver
	o_q <= int_q;
								
end struct;