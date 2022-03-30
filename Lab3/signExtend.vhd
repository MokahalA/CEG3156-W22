--------------------------------------------------------------------------------
-- Title         : Sign Extension Unit (16-bits to 32-bits)
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : signExtend.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signExtend is
	port (
	se_IN : in std_logic_vector(15 downto 0);
	se_OUT : out std_logic_vector(31 downto 0)
	);
end entity;

architecture behave of signExtend is
begin

se_OUT(31 downto 16) <= ( others=>se_IN(15) );
se_OUT(15 downto 0) <= se_IN;

end architecture;