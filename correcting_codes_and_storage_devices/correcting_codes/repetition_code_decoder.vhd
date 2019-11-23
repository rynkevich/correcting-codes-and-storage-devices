library ieee;
use ieee.std_logic_1164.all;

entity repetition_code_decoder is
	generic (DataSize: integer := 4);
	port (
		Code: in std_logic_vector(DataSize * 2 - 1 downto 0);
		Data: out std_logic_vector(DataSize - 1 downto 0);
		Error: out std_logic
	);
end repetition_code_decoder;

architecture behavioral of repetition_code_decoder is
begin
	Data <= Code(DataSize - 1 downto 0);
	Error <= '0' when Code(DataSize - 1 downto 0) = Code(DataSize * 2 - 1 downto DataSize) else '1';
end behavioral;
