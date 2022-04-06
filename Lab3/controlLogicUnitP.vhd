--------------------------------------------------------------------------------
-- Title         : ALU Pipelined Control Unit
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : controlLogicUnitP.vhd

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------
-- ENTITY
-------------------------------------------------------------------------------
ENTITY controlLogicUnit IS
	PORT(
		i_Operation  	                 :IN std_logic_vector(5 downto 0);
        i_Zero                           :IN std_logic;
        o_ControlSignals                 :OUT std_logic_vector(7 downto 0);
        o_IFFlush, o_BranchMUX           :OUT std_logic
        );

END ENTITY controlLogicUnit;
-------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------
ARCHITECTURE rtl OF controlLogicUnit IS

SIGNAL int_R, int_lw, int_sw, int_beq                   :std_logic;
SIGNAL int_ALUSrc, int_RegWrite                         :std_logic;
SIGNAL int_ALUOp 	                                    :std_logic_vector (1 downto 0);
SIGNAL int_IFFlush, int_BranchMUX                       :std_logic;                     

SIGNAL int_EX                                           :std_logic_vector (3 downto 0);
SIGNAL int_MEM                                          :std_logic_vector (1 downto 0);
SIGNAL int_WB                                           :std_logic_vector (1 downto 0);

	
BEGIN
    
    --  Concurrent Signal Assignment
	int_R   <= NOT(i_Operation(5)) AND NOT(i_Operation(4)) AND NOT(i_Operation(3)) AND NOT(i_Operation(2)) AND NOT(i_Operation(1)) AND NOT(i_Operation(0));
    int_lw  <= i_Operation(5) AND NOT(i_Operation(4)) AND NOT(i_Operation(3)) AND NOT(i_Operation(2)) AND i_Operation(1) AND i_Operation(0);
    int_sw  <= i_Operation(5) AND NOT(i_Operation(4)) AND i_Operation(3) AND NOT(i_Operation(2)) AND i_Operation(1) AND i_Operation(0);
    int_beq <= NOT(i_Operation(5)) AND NOT(i_Operation(4)) AND NOT(i_Operation(3)) AND i_Operation(2) AND NOT(i_Operation(1)) AND NOT(i_Operation(0));

	
    int_ALUOp(1)        <=      int_R;
    int_ALUOp(0)        <=      int_beq;
    int_ALUSrc          <=      int_lw OR int_sw;
    int_RegWrite        <=      int_R OR int_lw;
	
    int_IFFlush     <= i_Zero;
    int_BranchMUX   <= int_beq AND i_Zero;
    int_WB          <= int_RegWrite & int_lw;               --RegWrite & MemtoReg
    int_MEM         <= int_lw & int_sw;                     --MemRead & MemWrite
    int_EX          <= int_R & int_ALUOp & int_ALUSrc;      --RegDst & ALUOp & ALUSrc

	--  Output Driver
    o_IFFlush           <= int_IFFlush;                          -- Status siganl that zeros contents of IF/ID pipeline
    o_BranchMUX          <= int_BranchMUX;                        -- Selector signal for Branching Address MUX  
	o_ControlSignals    <= int_WB & int_MEM & int_EX ;           -- |WB signals|MEM signals|EX signals|

END ARCHITECTURE rtl;
-------------------------------------------------------------------------------