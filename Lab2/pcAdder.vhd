--------------------------------------------------------------------------------
-- Title         : PC adder (8 bit I/O) used to increment PC + 4
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : pcAdder.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all; 

entity pcAdder is
  port (
    clk : IN STD_LOGIC;
    PC_in : IN STD_LOGIC_VECTOR(7 downto 0);
    PC_out : OUT STD_LOGIC_VECTOR(7 downto 0)
  ) ;
end pcAdder ;

architecture arch of pcAdder is
    signal pcout: std_logic_vector(7 downto 0); 

begin 
    process(clk) 
        begin 
            if rising_edge(clk) then  
                pcout<= std_logic_vector(unsigned(PC_in) + 4);  
            
            end if; 
      end process; 

    PC_out <= pcout; 

end architecture ; -- arch