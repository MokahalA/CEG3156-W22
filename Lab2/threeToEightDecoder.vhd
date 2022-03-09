-------------------------------------------------------------------------------
-- Title		: 3x8 Decoder
-- file			: threeToEightDecoder.vhd
-- Project		: Single-cycle processor
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------
-- ENTITY
-------------------------------------------------------------------------------
ENTITY threeToEightDecoder IS
	PORT(
        --i_GReset, i_clock   : IN STD_LOGIC;
		i_enable            : IN STD_LOGIC;
		i_code			    :IN STD_LOGIC_VECTOR(2 downto 0);
		o_addr			    :OUT STD_LOGIC_VECTOR(7 downto 0);
	);

END ENTITY threeToEightDecoder;
-------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------
ARCHITECTURE bhv OF threeToEightDecoder IS

	signal int_addr	:STD_LOGIC_VECTOR(7 downto 0);
	
	
BEGIN

    IF (i_en = '0') THEN
        int_addr <=  "00000000";
    ELSE
    
        PROCESS(i_code)
            BEGIN
                CASE i_code IS 
                    WHEN "000" => int_addr <= "00000001";
                    WHEN "001" => int_addr <= "00000010";
                    WHEN "010" => int_addr <= "00000100";
                    WHEN "011" => int_addr <= "00001000";
                    WHEN "100" => int_addr <= "00010000";
                    WHEN "101" => int_addr <= "00100000";
                    WHEN "110" => int_addr <= "01000000";
                    WHEN "111" => int_addr <= "10000000";
                    WHEN others => int_addr <= "00000000";
                END CASE;
        END PROCESS;
    END IF; 

	-- Output Driver
	o_addr		<= int_addr;

END ARCHITECTURE bhv;
-------------------------------------------------------------------------------