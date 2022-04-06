--------------------------------------------------------------------------------
-- Title         : Branch Comparator
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : branchComparator.vhd

library ieee;
use ieee.std_logic_1164.all;

-- ENTITY --
entity branchComparator is
    port (
			i_A, i_B        : in std_logic_vector (7 downto 0);
			o_Zero        : out std_logic
		);
end branchComparator;


-- ARCHITECTURE --
architecture rtl of branchComparator is
    
    
    signal int_Val :std_logic_vector (7 downto 0);
    signal int_Zero :std_logic;

    BEGIN
     --  Concurrent Signal Assignment
    int_Val <= i_A XNOR i_B;
    int_Zero <= int_Val(7) AND int_Val(6) AND int_Val(5) AND int_Val(4) AND int_Val(3) AND int_Val(2) AND int_Val(1) AND int_Val(0);

    --  Output Driver
    o_Zero <= int_Zero;


end architecture rtl; 