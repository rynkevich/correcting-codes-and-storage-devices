library ieee;
use ieee.std_logic_1164.all;

entity parity_check_code_decoder is
	generic (DataSize: integer := 4);
	port (
		Code: in std_logic_vector(DataSize downto 0);
		Data: out std_logic_vector(DataSize - 1 downto 0);
		Error: out std_logic
	);
end parity_check_code_decoder;

architecture behavioral of parity_check_code_decoder is
begin
	Main: process (Code)
		variable ParityBit: std_logic;
	begin
		ParityBit := '0';
		for I in Code'high downto 1 loop
			ParityBit := ParityBit xor Code(I);
		end loop;
		
		Data <= Code(Code'high downto 1);
		if ParityBit /= Code(0) then
			Error <= '1';
		else
			Error <= '0';
		end if;
	end process;
end behavioral;
