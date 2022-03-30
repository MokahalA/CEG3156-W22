--------------------------------------------------------------------------------
-- Title         : 5-Bit Comparator
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : fiveBitComparator.vhd

library ieee;
use ieee.std_logic_1164.all;

-- ENTITY --
entity fiveBitComparator is
    port (
			i_A, i_B        : in std_logic_vector (4 downto 0);
            i_enable        : in std_logic;
			o_Result        : out std_logic
		);
end fiveBitComparator;


-- ARCHITECTURE --
architecture rtl of fiveBitComparator is
    
    
    signal int_Val :std_logic_vector (4 downto 0);
    signal int_Result :std_logic;

    BEGIN
     --  Concurrent Signal Assignment
    int_Val <= i_A XNOR i_B;
    int_Result <= int_Val(4) AND int_Val(3) AND int_Val(2) AND int_Val(1) AND int_Val(0) AND i_enable;

    --  Output Driver
    o_Result <= int_Result;


end architecture rtl; 