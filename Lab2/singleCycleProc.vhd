--------------------------------------------------------------------------------
-- Title         : Single Cycle Processor (Top-level entity)
-- Project       : Single Cycle MIPS Processor
-------------------------------------------------------------------------------
-- File          : singleCycleProc

library ieee;
use ieee.std_logic_1164.all;

entity singleCycleProc is
  port (
    -- inputs --
    GClock : IN STD_LOGIC;
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
end singleCycleProc ;

architecture arch of singleCycleProc is
    -- Internal Signals --
    SIGNAL int_branchMuxOut : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
    SIGNAL int_jumpMuxOut, int_pcRegOut, int_MemtoRegMuxOut, int_aluMuxOut : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL int_instruction, int_signExtended : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL int_RegDst, int_Jump, int_BranchNE, int_Branch, int_MemRead, int_MemtoReg, int_MemWrite, int_ALUsrc, int_RegWrite : STD_LOGIC; 
    SIGNAL int_ALUop : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL int_regDstMuxOut : STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL int_readData1, int_readData2, int_other, int_MuxOut : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL int_aluControl : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL int_Zero, int_branchSignal, int_and1, int_and2 : STD_LOGIC;
    SIGNAL int_aluResult, int_dataMemOut, int_pcAdderOut, int_jumpAddress, int_shifted, int_branchResult : STD_LOGIC_VECTOR(7 downto 0);


    -- Components --
    component pcRegister is 
        port (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            PC_in : IN STD_LOGIC_VECTOR(7 downto 0);
            PC_out : OUT STD_LOGIC_VECTOR(7 downto 0)
        ) ;
    end component;

    component instructionMemory is
        PORT (	i_inclock, i_outclock 	: IN  STD_LOGIC;
        readAddress 			: IN  STD_LOGIC_VECTOR(7 downto 0);
        o_q 			: OUT STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component mux5x5 is
        port (
            sel : in std_logic;
            i_a, i_b : in std_logic_vector(4 downto 0);
            i_z : out std_logic_vector(4 downto 0)
        );
    end component;
    
    component registerFile is 
        PORT(
            i_reset, i_clock : IN STD_LOGIC;
            i_RegWrite : IN STD_LOGIC; -- RegWrite control signal --
            readRegister1 : IN STD_LOGIC_VECTOR(4 downto 0);  --We only use bits 0-2 of the ports
            readRegister2 : IN STD_LOGIC_VECTOR(4 downto 0);  
            writeRegister : IN STD_LOGIC_VECTOR(4 downto 0);
            writeData : IN STD_LOGIC_VECTOR(7 downto 0);
            readData1 : OUT STD_LOGIC_VECTOR(7 downto 0);
            readData2 : OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component signExtend is 
        port (
            se_IN : in std_logic_vector(15 downto 0);
            se_OUT : out std_logic_vector(31 downto 0)
        );
    end component;

    component mux2to1_8bit is 
        PORT (A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        s : IN STD_LOGIC;
        R : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    end component;

    component lowerALU is 
        port (
            i_aluOp :in std_logic_vector(2 downto 0);
            i_A, i_B: in std_logic_vector(7 downto 0);
            aluResult : out std_logic_vector(7 downto 0);
            Zero : out std_logic);
    end component;

    component dataMemory is 
        PORT (	i_inclock, i_outclock 	: IN  STD_LOGIC;
                i_memWrite, i_memRead	: IN  STD_LOGIC;
                i_address 		     	: IN  STD_LOGIC_VECTOR(7 downto 0);
                i_writeData		       	: IN  STD_LOGIC_VECTOR(7 downto 0);
                o_readData 			    : OUT STD_LOGIC_VECTOR(7 downto 0));
    end component;

    component pcAdder is 
        port (
            clk : IN STD_LOGIC;
            PC_in : IN STD_LOGIC_VECTOR(7 downto 0);
            PC_out : OUT STD_LOGIC_VECTOR(7 downto 0)
        ) ;
    end component;

    component shiftLeft2 is 
        port(
            x : in std_logic_vector(7 downto 0);
            y : out std_logic_vector(7 downto 0));
    end component;

    component fullAdder8Bit is  --Produces aluResult for Branch target
        port(
            M : in std_logic_vector (7 downto 0);
            N : in std_logic_vector (7 downto 0);
            Cin : in std_logic;
            Cout : out std_logic;
            Sum : out std_logic_vector (7 downto 0)
        );
    end component;


    component aluCtrlUnit is
        port (
            aluOpIn : in std_logic_vector(1 downto 0);
            functionBits : in std_logic_vector(5 downto 0);
            aluOpOut : out std_logic_vector(2 downto 0)
            
        );
    end component;

    component controlLogicUnit is
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
    end component;

    component top_mux8x8 is 
        port(PC, ALUresult, readData1, readData2, writeData, other, i6, i7: in std_logic_vector(7 downto 0); -- i6 and i7 not used
        sel :in std_logic_vector(2 downto 0);
        muxOut: out std_logic_vector(7 downto 0));
    end component;

begin

    -- Port Maps --
    PCreg: pcRegister port map(GClock, GReset, int_jumpMuxOut, int_pcRegOut);
    instructionMem: instructionMemory port map(GClock, GClock, int_pcRegOut, int_instruction);
    regDstMux: mux5x5 port map(int_RegDst, int_instruction(15 downto 11), int_instruction(20 downto 16), int_regDstMuxOut);
    regFile: registerFile port map(GReset, GClock, int_RegWrite, int_instruction(25 downto 21), int_instruction(20 downto 16), int_regDstMuxOut, int_MemtoRegMuxOut, int_readData1, int_readData2);
    signExt: signExtend port map(int_instruction(15 downto 0), int_signExtended);
    aluMux: mux2to1_8bit port map(int_readData2, int_signExtended(7 downto 0), int_ALUsrc, int_aluMuxOut);
    zeroALU: lowerALU port map(int_aluControl, int_readData1, int_aluMuxOut, int_aluResult, int_Zero);
    dataMem: dataMemory port map(GClock, GClock, int_MemWrite, int_MemRead, int_aluResult, int_readData2, int_dataMemOut);
    memToRegMux: mux2to1_8bit port map(int_dataMemOut, int_aluResult, int_MemtoReg, int_MemtoRegMuxOut);
    
    PCadd: pcAdder port map(GClock, int_pcRegOut, int_pcAdderOut);
    sl1: shiftLeft2 port map(int_instruction(25 downto 18), int_jumpAddress);
    sl2: shiftLeft2 port map(int_signExtended(7 downto 0), int_shifted);
    branchAdder: fullAdder8Bit port map(int_pcAdderOut, int_shifted, '0', open, int_branchResult);
    --branchMux: mux2to1_8bit port map(int_pcAdderOut, int_branchResult, int_branchSignal, int_branchMuxOut); 
    --jumpMux: mux2to1_8bit port map(int_branchMuxOut, int_jumpAddress, int_Jump, int_jumpMuxOut);

    aluControl1: aluCtrlUnit port map(int_ALUop, int_instruction(5 downto 0), int_aluControl);
    cpuCtrl: controlLogicUnit port map(int_instruction(31 downto 26), int_RegDst, int_Jump, int_BranchNE, int_Branch, int_MemRead, int_MemtoReg, int_ALUop, int_MemWrite, int_ALUsrc, int_RegWrite);

    selectMux: top_mux8x8 port map(int_pcAdderOut, int_aluResult, int_readData1, int_readData2, int_MemtoRegMuxOut, int_other, int_other, int_other, valueSelect, int_MuxOut);

    int_jumpMuxOut <= int_pcAdderOut; -- Remove this for branching/jump

    int_and1 <= int_BranchNE and not(int_Zero);
    int_and2 <= int_Branch and int_Zero;
    int_branchSignal <= int_and1 or int_and2;

    
    int_other(0) <= int_Zero;
    int_other(1) <= int_RegDst;
    int_other(2) <= int_Jump;
    int_other(3) <= int_MemRead;
    int_other(4) <= int_MemtoReg;
    int_other(6 downto 5) <= int_ALUop;
    int_other(7) <= int_ALUsrc;

    --Output drivers

    MuxOut <= int_MuxOut;
    InstructionOut <= int_instruction;
    BranchOut <= int_Branch;
    ZeroOut <= int_Zero;
    MemWriteOut <= int_MemWrite;
    RegWriteOut <= int_RegWrite;


end architecture ; -- arch
