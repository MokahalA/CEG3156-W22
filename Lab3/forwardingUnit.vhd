--------------------------------------------------------------------------------
-- Title         : Forwarding Unit
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : forwardingUnit.vhd

library ieee;
use ieee.std_logic_1164.all;

-- ENTITY --
entity forwardingUnit is
    port (
			i_EXRegisterRs          : in std_logic_vector (4 downto 0);
            i_EXRegisterRt          : in std_logic_vector (4 downto 0);
            i_MEMRegisterRd         : in std_logic_vector (4 downto 0);
            i_WBRegisterRd          : in std_logic_vector (4 downto 0);
            i_MEMRegWrite           : in std_logic;
            i_WBRegWrite            : in std_logic;
			o_ForwardA              : out std_logic_vector(1 downto 0);
            o_ForwardB              : out std_logic_vector(1 downto 0)
		);
end forwardingUnit;


-- ARCHITECTURE --
architecture rtl of forwardingUnit is

    -- Components
    COMPONENT fiveBitComparator
        PORT (
            i_A, i_B        : in std_logic_vector (4 downto 0);
            i_enable        : in std_logic;
            o_Result        : out std_logic);
    END COMPONENT;
    
    -- Signals
    signal int_ForwardA, int_ForwardB   :std_logic_vector(1 downto 0);

    signal int_CompA, int_CompB, int_CompC, int_CompD :std_logic; -- Comparator Outputs

    signal int_A, int_C :std_logic; -- Data Hazard types 3 & 4
    signal int_B, int_D :std_logic; -- Data Hazard types 1 & 2

    signal int_MEMRegisterRd_NotZero    :std_logic; -- $0 register must always return 0
    signal int_WBRegisterRd_NotZero     :std_logic; -- $0 register must always return 0
    

    BEGIN

    comparatorA: fiveBitComparator
        port map (
            i_A => i_EXRegisterRs,
            i_B => i_WBRegisterRd,
            i_enable => i_WBRegWrite,
            o_Result => int_CompA
        );

    comparatorB: fiveBitComparator
        port map (
            i_A => i_EXRegisterRs,
            i_B => i_MEMRegisterRd,
            i_enable => i_MEMRegWrite,
            o_Result => int_CompB
        );

    comparatorC: fiveBitComparator
        port map (
            i_A => i_EXRegisterRt,
            i_B => i_WBRegisterRd,
            i_enable => i_WBRegWrite,
            o_Result => int_CompC
        );

    comparatorD: fiveBitComparator
        port map (
            i_A => i_EXRegisterRt,
            i_B => i_MEMRegisterRd,
            i_enable => i_MEMRegWrite,
            o_Result => int_CompD
        );

     --  Concurrent Signal Assignment
     int_MEMRegisterRd_NotZero <= i_MEMRegisterRd(4) OR i_MEMRegisterRd(3) OR i_MEMRegisterRd(2) OR i_MEMRegisterRd(1) OR i_MEMRegisterRd(0);
     int_WBRegisterRd_NotZero <= i_WBRegisterRd(4) OR i_WBRegisterRd(3) OR i_WBRegisterRd(2) OR i_WBRegisterRd(1) OR i_WBRegisterRd(0);

    int_A <= int_WBRegisterRd_NotZero AND int_CompA;
    int_B <= int_MEMRegisterRd_NotZero AND int_CompB;
    int_C <= int_WBRegisterRd_NotZero AND int_CompC;
    int_D <= int_MEMRegisterRd_NotZero AND int_CompD;

    int_ForwardA <= int_B & (NOT(int_B) AND int_A);
    int_ForwardB <= int_D & (NOT(int_D) AND int_C);

    --  Output Driver
    o_ForwardA <= int_ForwardA;
    o_ForwardB <= int_ForwardB;


end architecture rtl; 