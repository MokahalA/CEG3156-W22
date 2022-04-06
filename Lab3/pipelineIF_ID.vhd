--------------------------------------------------------------------------------
-- Title         : IF/ID pipeline
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : pipelineIF_ID.vhd

library ieee;
use ieee.std_logic_1164.all;

-- ENTITY --
entity pipelineIF_ID is
    port (
            i_Greset, i_clock	        : IN STD_LOGIC;
            i_enable			        : IN STD_LOGIC;

            i_IFIDWrite                 : in std_logic; -- enable signal.
            i_Flush                     : in std_logic; -- If set, zero all registers.

            i_PCAddress                 : in std_logic_vector (7 downto 0);
            i_Intsruction               : in std_logic_vector (31 downto 0);


            o_PCAddress                 : out std_logic_vector (7 downto 0);
            o_Intsruction               : out std_logic_vector (31 downto 0)
		);
end pipelineIF_ID;


-- ARCHITECTURE --
architecture rtl of pipelineIF_ID is
    
    -- Components

    COMPONENT eightBitRegister
        PORT ( 
            i_GReset, i_clock : IN STD_LOGIC;
            i_enable : IN STD_LOGIC;
            i_A : IN STD_LOGIC_VECTOR(7 downto 0);
            o_q : OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT thirtyTwoBitRegister
        PORT(
            i_resetBar, i_en	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            i_Value			: IN	STD_LOGIC_VECTOR(31 downto 0);
            o_Value			: OUT	STD_LOGIC_VECTOR(31 downto 0)
        );
    END COMPONENT;


    -- Signals
    signal int_PCAddress :std_logic_vector (7 downto 0);
    signal int_Intsruction :std_logic_vector (31 downto 0);

    
    BEGIN
    
    pcAddress: eightBitRegister 
        PORT MAP (i_Greset, i_enable, i_clock, i_PCAddress, int_PCAddress);
    intruction: thirtyTwoBitRegister 
        PORT MAP (i_Greset, i_enable, i_clock, i_Intsruction, int_Intsruction);

    --  Output Driver
    o_PCAddress            <= int_PCAddress;
    o_Intsruction          <= int_Intsruction;


end architecture rtl; 