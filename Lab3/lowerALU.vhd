---------------------------------------------------------------------------------------------------------------
-- Title		: The ALU used in the R-type and I-type datapaths, generates a Zero output signal & ALU result.
-- file			: lowerALU.vhd
-- Project		: Single Cycle Processor
-- OpSelects:
        -- 000: AND
        -- 001: OR
        -- 010: ADD
        -- 011: SUB
        -- 100: SLT
---------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lowerALU is 
port (
        i_aluOp :in std_logic_vector(2 downto 0);
        i_A, i_B: in std_logic_vector(7 downto 0);
        aluResult : out std_logic_vector(7 downto 0);
        Zero : out std_logic);
end lowerALU;

architecture rtl of lowerALU is
--Functions: AND OR SUB ADD SLT

--ADDER Component
component fullAdder8Bit is
	port(
		M : in std_logic_vector (7 downto 0);
		N : in std_logic_vector (7 downto 0);
		Cin : in std_logic;
		Cout : out std_logic;
		Sum : out std_logic_vector (7 downto 0)
	);
end component;

--Subtractor
component fullSubtractor8Bit is
	port(
		M : in std_logic_vector (7 downto 0);
		N : in std_logic_vector (7 downto 0);
		Din : in std_logic;
		Cout : out std_logic;
		Sum : out std_logic_vector (7 downto 0)
	);
end component;

--AND
component eightBitAND is
	port (
                valA, valB : in std_logic_vector (7 downto 0);
                valO: out std_logic_vector(7 downto 0)
	);
end component eightBitAND;
--OR 
 component eightBitOR is
	port (
                valA, valB : in std_logic_vector (7 downto 0);
                valO: out std_logic_vector(7 downto 0)
	);
end component eightBitOR;
--LST
component eightBitLT is
	port (
                valA, valB : in std_logic_vector (7 downto 0);
                valO: out std_logic_vector(7 downto 0)
	);
end component eightBitLT;

component mux8x3 is
	port (
		a,b,c,d,e,f,g,h : in std_logic_vector(7 downto 0);
		selec: in std_logic_vector(2 downto 0);
		m : out std_logic_vector(7 downto 0)
	);
end component mux8x3;
signal inSigA, inSigB, inMuxA, inMuxB, inMuxC, inMuxD, inMuxE, outMuxA: std_logic_vector(7 downto 0);
signal i_aluOptors : std_logic_vector(2 downto 0);
begin
i_aluOptors <= i_aluOp;
inSigA <= i_A ; inSigB <= i_B;


 sAND: eightBitAND port map(inSigA,inSigB,inMuxA);
 sOR: eightBitOR port map(inSigA,inSigB,inMuxB);
 sADD: fullAdder8Bit port map(inSigA,inSigB, '0', open, inMuxC);
 sSUB: fullSubtractor8Bit port map(inSigA, inSigB, '0', open, inMuxD);
 sSLT: eightBitLT port map(inSigA,inSigB,inMuxE);
 mux: mux8x3 port map(inMuxA,inMuxB,inMuXC,inMuxD,inMuxE,"00000000","00000000","00000000", i_aluOptors, outMuxA);
 aluResult <= outMuxA;
 Zero <= not(outMuxA(0) or outMuxA(1) or outMuxA(2) or outMuxA(3) or outMuxA(4) or outMuxA(5) or outMuxA(6) or outMuxA(7));
 
end architecture rtl;


