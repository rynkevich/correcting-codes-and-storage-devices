library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decoder is
	generic (N: integer := 2);
	port (
		Code: in std_logic_vector(N - 1 downto 0);
		Data: out std_logic_vector((2 ** N) - 1 downto 0)
	);
end decoder;

architecture behavioral of decoder is
begin
	Main: process (Code)
		variable Result: std_logic_vector((2 ** N) - 1 downto 0);
	begin
		Result := (others => '0');
		Result(CONV_INTEGER(Code)) := '1';
		Data <= Result;
	end process;
end behavioral;
