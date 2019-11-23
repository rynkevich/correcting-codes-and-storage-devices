library ieee;
use ieee.std_logic_1164.all;

entity parity_check_code_encoder is
	generic (DataSize: integer := 4);
	port (
		Data: in std_logic_vector(DataSize - 1 downto 0);
		Code: out std_logic_vector(DataSize downto 0)
	);
end parity_check_code_encoder;

architecture behavioral of parity_check_code_encoder is
begin
	Main: process (Data)
		variable ParityBit: std_logic;
	begin
		ParityBit := '0';
		for I in 0 to Data'high loop
			ParityBit := ParityBit xor Data(I);
		end loop;
		Code <= Data & ParityBit;
	end process;
end behavioral;
