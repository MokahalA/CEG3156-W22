--------------------------------------------------------------------------------
-- Title         : MEM/WB pipeline
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : pipelineMEM_WB.vhd

library ieee;
use ieee.std_logic_1164.all;

-- ENTITY --
entity pipelineMEM_WB is
    port (
            i_Greset, i_clock	        : IN STD_LOGIC;
            i_enable			        : IN STD_LOGIC;
            
            i_WBSignals                 : in std_logic_vector (1 downto 0);
            i_MemoryData                : in std_logic_vector (7 downto 0);
            i_ALUresult                 : in std_logic_vector (7 downto 0);
            i_EXMEM_RegisterRd          : in std_logic_vector (4 downto 0);
            
            o_WBSignals                 : out std_logic_vector (1 downto 0);
            o_MemoryData                : out std_logic_vector (7 downto 0);
            o_ALUresult                 : out std_logic_vector (7 downto 0);
            o_MEMWB_RegisterRd          : out std_logic_vector (4 downto 0)
		);
end pipelineMEM_WB;


-- ARCHITECTURE --
architecture rtl of pipelineMEM_WB is
    
    -- Components
    COMPONENT twoBitRegister
        PORT(
            i_resetBar, i_en	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            i_Value			: IN	STD_LOGIC_VECTOR(1 downto 0);
            o_Value			: OUT	STD_LOGIC_VECTOR(1 downto 0)
        );
    END COMPONENT;

    COMPONENT fiveBitRegister
        PORT(
            i_resetBar, i_en	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            i_Value			: IN	STD_LOGIC_VECTOR(4 downto 0);
            o_Value			: OUT	STD_LOGIC_VECTOR(4 downto 0)
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
    signal int_WBSignals   :std_logic_vector (1 downto 0);
    signal int_MemoryData, int_ALUresult :std_logic_vector (7 downto 0);
    signal int_MEMWB_RegisterRd :std_logic_vector (4 downto 0);

    
    BEGIN
    wbSignals: twoBitRegister
        PORT MAP (i_Greset, i_enable, i_clock, i_WBSignals, int_WBSignals);
    memoryData: eightBitRegister 
        PORT MAP (i_Greset, i_clock, i_enable, i_MemoryData, int_MemoryData);
    aluResult: eightBitRegister 
        PORT MAP (i_Greset, i_clock, i_enable, i_ALUresult, int_ALUresult);
    registerRd: fiveBitRegister 
        PORT MAP (i_Greset, i_enable, i_clock, i_EXMEM_RegisterRd, int_MEMWB_RegisterRd);

    --  Output Driver
    o_WBSignals                 <= int_WBSignals;
    o_MemoryData                <= int_MemoryData;
    o_ALUresult                 <= int_ALUresult;
    o_MEMWB_RegisterRd          <= int_MEMWB_RegisterRd;


end architecture rtl; 