--------------------------------------------------------------------------------
-- Title         : Data Memory Block (RAM)
-- Project       : VHDL Synthesis Overview
-- Designed using the Intel LPM_RAM core documentation
-------------------------------------------------------------------------------
-- File          : dataMemory.vhd


LIBRARY ieee;
LIBRARY lpm;
USE ieee.std_logic_1164.ALL;
USE lpm.lpm_components.ALL;


ENTITY dataMemory IS
	PORT (	i_inclock, i_outclock 	: IN  STD_LOGIC;
			i_memWrite, i_memRead	: IN  STD_LOGIC;
			i_address 		     	: IN  STD_LOGIC_VECTOR(7 downto 0);
			i_writeData		       	: IN  STD_LOGIC_VECTOR(7 downto 0);
			o_readData 			    : OUT STD_LOGIC_VECTOR(7 downto 0));
END dataMemory;

ARCHITECTURE struct OF dataMemory IS

COMPONENT lpm_ram_dq
	GENERIC
		(	LPM_WIDTH : natural;    -- MUST be greater than 0
            LPM_WIDTHAD : natural;    -- MUST be greater than 0
            LPM_NUMWORDS : natural := 0;
            LPM_INDATA : string := "REGISTERED";
			LPM_ADDRESS_CONTROL: string := "REGISTERED";
			LPM_OUTDATA : string := "REGISTERED";
			LPM_FILE : string := "UNUSED";
			LPM_TYPE : string := L_RAM_DQ;
			USE_EAB  : string := "ON";
			INTENDED_DEVICE_FAMILY  : string := "UNUSED";
			LPM_HINT : string := "UNUSED");
	 port (	DATA : in std_logic_vector(LPM_WIDTH-1 downto 0);
            ADDRESS : in std_logic_vector(LPM_WIDTHAD-1 downto 0);
            INCLOCK : in std_logic := '0';
			OUTCLOCK : in std_logic := '0';
			WE : in std_logic;
			Q : out std_logic_vector(LPM_WIDTH-1 downto 0));
END COMPONENT;

CONSTANT dataFile : STRING := "data.mif";

SIGNAL int_q : STD_LOGIC_VECTOR(7 downto 0);

BEGIN

dataMem: lpm_ram_dq
	GENERIC MAP (LPM_WIDTH => 8,
				LPM_WIDTHAD => 8,
				LPM_NUMWORDS => 256,
				LPM_FILE => dataFile)
	PORT MAP (	DATA => i_writeData,
		        ADDRESS => i_address,
				INCLOCK => i_inclock,
				OUTCLOCK => i_outclock,
				WE => i_memWrite,				
                Q => int_q);


--Output driver
process(i_memRead, i_inclock, i_outclock)
begin 
    if(i_memRead = '1') then 
        o_readData <= int_q ;
    end if;
end process;
			
END struct;	