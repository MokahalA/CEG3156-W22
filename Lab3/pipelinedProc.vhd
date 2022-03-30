--------------------------------------------------------------------------------
-- Title         : Pipelined Single Cycle Processor (Top-level entity)
-- Project       : Pipelined Single Cycle MIPS Processor
-------------------------------------------------------------------------------
-- File          : pipelinedProc.vhd

library ieee;
use ieee.std_logic_1164.all;

entity pipelinedProc is
  port (
    -- inputs --
    GClock : IN STD_LOGIC;
    GClock2 : IN STD_LOGIC;
    GReset : IN STD_LOGIC;
    valueSelect : IN STD_LOGIC_VECTOR(2 downto 0);

    -- outputs --
    MuxOut : OUT STD_LOGIC_VECTOR(7 downto 0);
    InstructionOut : OUT STD_LOGIC_VECTOR(31 downto 0);
    BranchOut : OUT STD_LOGIC;
    ZeroOut : OUT STD_LOGIC;
    MemWriteOut : OUT STD_LOGIC;
    RegWriteOut : OUT STD_LOGIC
  ) ;
end pipelinedProc ;

architecture arch of pipelinedProc is
    -- Internal Signals --


    
    -- Components --

begin



end architecture ; -- arch
