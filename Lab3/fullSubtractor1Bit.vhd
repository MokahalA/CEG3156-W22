--------------------------------------------------------------------------------
-- Title         : 1-Bit Full Subtractor
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : fullSubtractor1Bit.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fullSubtractor1Bit is
    Port ( 
    A, B, C : in  STD_LOGIC;
    DIFFERENCE, BORROW : out  STD_LOGIC);

end fullSubtractor1Bit;

architecture arch of fullSubtractor1Bit is
begin

    DIFFERENCE <= A xor B xor C;
    BORROW <= ((not A) and (B or C)) or (B and C);

end arch;