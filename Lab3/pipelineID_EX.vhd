--------------------------------------------------------------------------------
-- Title         : ID/EX pipeline
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : pipelineID_EX.vhd

library ieee;
use ieee.std_logic_1164.all;

-- ENTITY --
entity pipelineID_EX is
    port (
            i_Greset, i_clock	        : IN STD_LOGIC;
            i_enable			        : IN STD_LOGIC;
            
            i_EXSignals                 : in std_logic_vector (3 downto 0);
            i_MEMSignals                : in std_logic_vector (1 downto 0);
            i_WBSignals                 : in std_logic_vector (1 downto 0);
            i_ReadData1                 : in std_logic_vector (7 downto 0);
            i_ReadData2                 : in std_logic_vector (7 downto 0);


            o_EXSignals                 : out std_logic_vector (3 downto 0);
            o_MEMSignals                : out std_logic_vector (1 downto 0);
            o_WBSignals                 : out std_logic_vector (1 downto 0);
            o_ReadData1                 : out std_logic_vector (7 downto 0);
            o_ReadData2                 : out std_logic_vector (7 downto 0)
		);
end pipelineID_EX;


-- ARCHITECTURE --
architecture rtl of pipelineID_EX is
    
    -- Components
    COMPONENT twoBitRegister
        PORT(
            i_resetBar, i_en	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            i_Value			: IN	STD_LOGIC_VECTOR(1 downto 0);
            o_Value			: OUT	STD_LOGIC_VECTOR(1 downto 0)
        );
    END COMPONENT;

    COMPONENT fourBitRegister
        PORT(
            i_resetBar, i_en	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            i_Value			: IN	STD_LOGIC_VECTOR(3 downto 0);
            o_Value			: OUT	STD_LOGIC_VECTOR(3 downto 0)
        );
    END COMPONENT;

    COMPONENT eightBitRegister
        PORT ( 
            i_GReset, i_clock : IN STD_LOGIC;
            i_enable : IN STD_LOGIC;
            i_A : IN STD_LOGIC_VECTOR(7 downto 0);
            o_q : OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    -- Signals
    signal int_EXSignals                    :std_logic_vector (3 downto 0);
    signal int_MEMSignals, int_WBSignals    :std_logic_vector (1 downto 0);
    signal int_ReadData1, int_ReadData2     :std_logic_vector (7 downto 0);

    
    BEGIN
    
    exSignals: fourBitRegister
        PORT MAP (i_Greset, i_enable, i_clock, i_EXSignals, int_EXSignals);
    memSignals: twoBitRegister
        PORT MAP (i_Greset, i_enable, i_clock, i_MEMSignals, int_MEMSignals);
    wbSignals: twoBitRegister
        PORT MAP (i_Greset, i_enable, i_clock, i_WBSignals, int_WBSignals);
    readData1: eightBitRegister 
        PORT MAP (i_Greset, i_clock, i_enable, i_ReadData1, int_ReadData1);
    readData2: eightBitRegister 
        PORT MAP (i_Greset, i_clock, i_enable, i_ReadData2, int_ReadData2);

    --  Output Driver
    o_EXSignals                 <= int_EXSignals;
    o_MEMSignals                <= int_MEMSignals;
    o_WBSignals                 <= int_WBSignals;
    o_ReadData1                 <= int_ReadData1;
    o_ReadData2                 <= int_ReadData2;


end architecture rtl; 