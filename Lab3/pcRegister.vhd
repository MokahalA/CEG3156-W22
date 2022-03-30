--------------------------------------------------------------------------------
-- Title         : PC register (8 bit I/O)
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : pcRegister.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pcRegister is
  port (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    PC_in : IN STD_LOGIC_VECTOR(7 downto 0);
    PC_out : OUT STD_LOGIC_VECTOR(7 downto 0)
  ) ;
end pcRegister ;

architecture arch of pcRegister is

    SIGNAL int_out : STD_LOGIC_VECTOR(7 downto 0);

    component eightBitRegister is
    	PORT ( 
		i_GReset, i_clock : IN STD_LOGIC;
		i_enable : IN STD_LOGIC;
		i_A : IN STD_LOGIC_VECTOR(7 downto 0);
		o_q : OUT STD_LOGIC_VECTOR(7 downto 0));
    end component;


begin
    pcStore: eightBitRegister port map(reset, clk, '1', PC_in, int_out);

    PC_out <= int_out;

end architecture ; -- arch