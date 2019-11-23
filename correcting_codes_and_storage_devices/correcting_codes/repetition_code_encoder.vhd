library ieee;
use ieee.std_logic_1164.all;

entity repetition_code_encoder is
	generic (DataSize: integer := 4);
	port (
		Data: in std_logic_vector(DataSize - 1 downto 0);
		Code: out std_logic_vector(DataSize * 2 - 1 downto 0)
	);
end repetition_code_encoder;

architecture behavioral of repetition_code_encoder is
begin
	Code <= Data & Data;
end behavioral;
