library ieee;
use ieee.std_logic_1164.all;

entity register_file is
	generic (
		RegisterSize: integer := 4;
		AddressSize: integer := 2
	);
	port (
		INIT, WE: in std_logic;
		WriteDataPort: in std_logic_vector(RegisterSize - 1 downto 0);
		ReadAddress, WriteAddress: in std_logic_vector(AddressSize - 1 downto 0);
		ReadDataPort: out std_logic_vector(RegisterSize - 1 downto 0)
	);
end register_file;

architecture structural of register_file is
	component reg_n is
		generic (N: integer);
		port (
			INIT, EN, CLK, OE: in std_logic;
			Din: in std_logic_vector(N - 1 downto 0);
			Dout: out std_logic_vector(N - 1 downto 0)
		);
	end component;
	
	component decoder is
		generic (N: integer := AddressSize);
		port (
			Code: in std_logic_vector(N - 1 downto 0);
			Data: out std_logic_vector((2 ** N) - 1 downto 0)
		);
	end component;
	
	signal WriteEnable, ReadEnable: std_logic_vector((2 ** AddressSize) - 1 downto 0);
	signal ReadData: std_logic_vector(RegisterSize - 1 downto 0);
begin
	WriteAddressDecoder: decoder port map (Code => WriteAddress, Data => WriteEnable);
	ReadAddressDecoder: decoder port map (Code => ReadAddress, Data => ReadEnable);
	
	Registers: for I in (2 ** AddressSize) - 1 downto 0 generate
		Register_I: reg_n
			generic map (N => RegisterSize)
			port map (
				INIT => INIT,
				EN => WriteEnable(I),
				CLK => WE,
				OE => ReadEnable(I),
				Din => WriteDataPort,
				Dout => ReadData
			);
	end generate;
	
	ReadDataPort <= ReadData;
end structural;
