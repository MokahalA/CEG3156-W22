---------------------------------------------------------------------------------------------------------------
-- Title		: The ALU used in the R-type and I-type datapaths, generates a Zero output signal & ALU result.
-- file			: lowerALU.vhd
-- Project		: Single Cycle Processor
---------------------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY lowerALU IS
	PORT(
        i_aluOp : IN STD_LOGIC_VECTOR(2 downto 0);
        i_A, i_B : IN STD_LOGIC_VECTOR(7 downto 0);
        aluResult : OUT STD_LOGIC_VECTOR(7 downto 0); --Output result
        Zero : OUT STD_LOGIG  --Output status signal 
	);

END ENTITY lowerALU;

ARCHITECTURE rtl OF lowerALU IS



END ARCHITECTURE rtl;
