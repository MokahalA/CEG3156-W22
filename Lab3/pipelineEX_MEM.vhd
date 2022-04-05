--------------------------------------------------------------------------------
-- Title         : MEM/WB pipeline
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : pipelineEX_MEM.vhd

library ieee;
use ieee.std_logic_1164.all;

-- ENTITY --
entity pipelineEX_MEM is
    port (
            i_Greset, i_clock	        : IN STD_LOGIC;
            i_enable			        : IN STD_LOGIC;
            i_ALUresult                 : in std_logic_vector (7 downto 0);
            i_IDEX_RegisterRd           : in std_logic_vector (4 downto 0);
            o_ALUresult                 : out std_logic_vector (7 downto 0);
            o_IDEX_RegisterRd           : out std_logic_vector (4 downto 0)
		);
end pipelineEX_MEM;


-- ARCHITECTURE --
architecture rtl of pipelineEX_MEM is
    
    -- Components

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
    signal int_ALUresult :std_logic_vector (7 downto 0);
    signal int_IDEX_RegisterRd :std_logic_vector (4 downto 0);

    
    BEGIN
    
    aluResult: eightBitRegister 
        PORT MAP (i_Greset, i_enable, i_clock, i_ALUresult, int_ALUresult);
    registerRd: fiveBitRegister 
        PORT MAP (i_Greset, i_enable, i_clock, i_IDEX_RegisterRd, int_IDEX_RegisterRd);

    --  Output Driver
    o_ALUresult                <= int_ALUresult;
    o_IDEX_RegisterRd          <= int_IDEX_RegisterRd;


end architecture rtl; 