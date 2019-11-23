library ieee;
use ieee.std_logic_1164.all;

entity reg_n is
	generic (N: integer := 4);
	port (
		INIT, EN, CLK, OE: in std_logic;
		Din: in std_logic_vector(N - 1 downto 0);
		Dout: out std_logic_vector(N - 1 downto 0)
	);
end reg_n;

architecture behavioral of reg_n is
	signal StoredValues: std_logic_vector(N - 1 downto 0);
begin
	ReadProcess: process (INIT, OE)
	begin
		if OE = '1' then
			Dout <= StoredValues;
		else
			Dout <= (others => 'Z');
		end if;
	end process;
	
	WriteProcess: process (INIT, EN, CLK, Din)
	begin
		if INIT = '1' then
			StoredValues <= (others => '0');
		elsif EN = '1' then
			if rising_edge(CLK) then
				StoredValues <= Din;
			end if;
		end if;
	end process;
end behavioral;
