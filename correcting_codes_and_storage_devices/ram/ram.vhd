library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
	generic (
		WordSize: integer := 4;
		AddressSize: integer := 2
	);
	port (
		CLK, WE: in std_logic;
		Address: in std_logic_vector(AddressSize - 1 downto 0);
		Din: in std_logic_vector(WordSize - 1 downto 0);
		Dout: out std_logic_vector(WordSize - 1 downto 0)
	);
end ram;

architecture behavioral of ram is
   type TMemory is array (0 to (2 ** AddressSize) - 1) of std_logic_vector(WordSize - 1 downto 0);
	
   signal Memory: TMemory;
   signal ReadAddress: std_logic_vector(AddressSize - 1 downto 0);
begin
	ReadProcess: process (CLK) is
	begin
		if rising_edge(CLK) then
			if WE = '0' then
				ReadAddress <= Address;
			end if;
		end if;
	end process;
	
	WriteProcess: process (CLK) is
	begin
		if rising_edge(CLK) then
			if WE = '1' then
				Memory(to_integer(unsigned(Address))) <= Din;
			end if;
		end if;
	end process;
	
	Dout <= Memory(to_integer(unsigned(ReadAddress)));
end architecture behavioral;