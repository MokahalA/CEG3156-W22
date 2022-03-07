----------------------------------------------------------------------------------------
-- Title         : Fetch Increment Block (TEST FILE)
---
---      THIS IS A TEST FILE I BUILT TO TEST FETCHING & INCREMENTING INSTRUCTIONS
----------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity fetchIncrement is
  port (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    pcAdderOut : OUT STD_LOGIC_VECTOR(7 downto 0);
    instructionOut : OUT STD_LOGIC_VECTOR(31 downto 0)
  ) ;
end fetchIncrement ;

architecture arch of fetchIncrement is

    SIGNAL int_pcRegOut, int_pcAdderOut : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL int_instructionOut : STD_LOGIC_VECTOR(31 downto 0);

    COMPONENT pcAdder IS
        port (
            clk : IN STD_LOGIC;
            PC_in : IN STD_LOGIC_VECTOR(7 downto 0);
            PC_out : OUT STD_LOGIC_VECTOR(7 downto 0)
        ) ;
    end component;

    COMPONENT pcRegister is 
        port (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            PC_in : IN STD_LOGIC_VECTOR(7 downto 0);
            PC_out : OUT STD_LOGIC_VECTOR(7 downto 0)
        ) ;
    end component;

    COMPONENT instructionMemory is 
        PORT (	i_inclock, i_outclock 	: IN  STD_LOGIC;
                readAddress 			: IN  STD_LOGIC_VECTOR(7 downto 0);
                o_q 			: OUT STD_LOGIC_VECTOR(31 downto 0));
    end component;

begin
    pcReg: pcRegister port map(clk, reset, int_pcAdderOut, int_pcRegOut);
    pcAdd: pcAdder port map(clk, int_pcRegOut, int_pcAdderOut);
    imReg: instructionMemory port map(clk, clk, int_pcRegOut, int_instructionOut);

    pcAdderOut <= int_pcAdderOut;
    instructionOut <= int_instructionOut;


end architecture ; -- arch