-------------------------------------------------------------------------------
-- Title		: ALU Control Unit
-- file			: contolLogicUnit.vhd
-- Project		: Single-cycle processor
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------
-- ENTITY
-------------------------------------------------------------------------------
ENTITY controlLogicUnit IS
	PORT(
		i_Operation  	:IN std_logic_vector(5 downto 0);
		o_RegDst		:OUT std_logic;
        o_Jump          :OUT std_logic;
        o_BNE           :OUT std_logic;         --eliminate if needed--
        o_Branch        :OUT std_logic;
        o_MemRead       :OUT std_logic;
        o_MemtoReg      :OUT std_logic;
        o_ALUOp         :OUT std_logic_vector(1 downto 0);
        o_MemWrite      :OUT std_logic;
        o_ALUSrc        :OUT std_logic;
        o_RegWrite      :OUT std_logic
        );

END ENTITY controlLogicUnit;
-------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------
ARCHITECTURE rtl OF contolLogicUnit IS

SIGNAL int_R, int_lw, int_sw, int_beq, int_j, int_bne   :std_logic;
SIGNAL int_ALUSrc, int_RegWrite                         :std_logic;
SIGNAL int_ALUOp 	                                    :std_logic_vector (1 downto 0);

	
BEGIN
    
    --  Concurrent Signal Assignment
	int_R   <= NOT(i_Operation(5)) AND NOT(i_Operation(4)) AND NOT(i_Operation(3)) AND NOT(i_Operation(2)) AND NOT(i_Operation(1)) AND NOT(i_Operation(0));
    int_lw  <= i_Operation(5) AND NOT(i_Operation(4)) AND NOT(i_Operation(3)) AND NOT(i_Operation(2)) AND i_Operation(1) AND i_Operation(0);
    int_sw  <= i_Operation(5) AND NOT(i_Operation(4)) AND i_Operation(3) AND NOT(i_Operation(2)) AND i_Operation(1) AND i_Operation(0);
    int_beq <= NOT(i_Operation(5)) AND NOT(i_Operation(4)) AND NOT(i_Operation(3)) AND i_Operation(2) AND NOT(i_Operation(1)) AND NOT(i_Operation(0));
    int_j   <= NOT(i_Operation(5)) AND NOT(i_Operation(4)) AND NOT(i_Operation(3)) AND NOT(i_Operation(2)) AND i_Operation(1) AND NOT(i_Operation(0));
    int_bne  <= NOT(i_Operation(5)) AND NOT(i_Operation(4)) AND NOT(i_Operation(3)) AND i_Operation(2) AND NOT(i_Operation(1)) AND i_Operation(0);
	
    int_ALUOp(1)        <=      int_R;
    int_ALUOp(0)        <=      int_bne OR int_beq;
    int_ALUSrc          <=      int_lw OR int_sw;
    int_RegWrite        <=      int_R OR int_lw;

	--  Output Driver
	o_RegDst		<=  int_R;
    o_Jump          <=  int_j;
    o_BNE           <=  int_bne;
    o_Branch        <=  int_beq;
    o_MemRead       <=  int_lw;
    o_MemtoReg      <=  int_lw;
    o_ALUOp         <=  int_ALUOp;
    o_MemWrite      <=  int_sw;
    o_ALUSrc        <=  int_ALUSrc;
    o_RegWrite      <=  int_RegWrite;

END ARCHITECTURE rtl;
-------------------------------------------------------------------------------