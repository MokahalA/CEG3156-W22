-------------------------------------------------------------------------------
-- Title		: 8bit Tri-State-Buffer
-- file			: eightBitTriStateBuffer.vhd
-- Project		: Single-cycle processor
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------
-- ENTITY
-------------------------------------------------------------------------------
ENTITY eightBitTriStateBuffer IS
	PORT(
        i_en               :IN STD_LOGIC;
		i_a                :IN STD_LOGIC_VECTOR(7 downto 0);
		o_y			       :OUT STD_LOGIC_VECTOR(7 downto 0)
	);

END ENTITY eightBitTriStateBuffer;
-------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------
ARCHITECTURE bhv OF eightBitTriStateBuffer IS

	signal int_y	:STD_LOGIC_VECTOR(7 downto 0);
	
	
BEGIN
    
    int_y <= i_a when (i_en = '1') else "ZZZZZZZZ";

END ARCHITECTURE bhv;
-------------------------------------------------------------------------------