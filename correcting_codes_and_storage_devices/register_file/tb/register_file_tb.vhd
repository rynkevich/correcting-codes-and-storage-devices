library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity register_file_tb is
end register_file_tb;
 
architecture behavioral of register_file_tb is 
	constant TestRegisterSize: integer := 4;
	constant TestAddressSize: integer := 2;
	constant NumberOfTests: integer := 4;
	
	component register_file
		generic (
			RegisterSize: integer;
			AddressSize: integer
		);
		port (
			INIT, WE: in std_logic;
			WriteDataPort: in std_logic_vector(RegisterSize - 1 downto 0);
			ReadAddress, WriteAddress: in std_logic_vector(AddressSize - 1 downto 0);
			ReadDataPort: out std_logic_vector(RegisterSize - 1 downto 0)
		);
   end component;
	
	type TTestData is array(0 to NumberOfTests - 1) of std_logic_vector(TestRegisterSize - 1 downto 0);
	
	signal WE: std_logic := '0';
   signal INIT: std_logic;
	signal WriteDataPort: std_logic_vector(TestRegisterSize - 1 downto 0);
	signal ReadAddress: std_logic_vector(TestAddressSize - 1 downto 0) := "00";
	signal WriteAddress: std_logic_vector(TestAddressSize - 1 downto 0) := "00";
	
	signal ReadDataPort: std_logic_vector(TestRegisterSize - 1 downto 0);
	
	constant ClockPeriod: time := 10 ns;
	constant TestData: TTestData := ("1000", "0001", "1111", "0110");
begin
	UUT: register_file
		generic map (
			RegisterSize => TestRegisterSize,
			AddressSize => TestAddressSize
		)
		port map (
			INIT => INIT,
			WE => WE,
			WriteDataPort => WriteDataPort,
			ReadAddress => ReadAddress,
			WriteAddress => WriteAddress,
			ReadDataPort => ReadDataPort
		);
		
	Stimulus: process
	begin
		INIT <= '1';
		wait for ClockPeriod;
		
		INIT <= '0';
		for I in 0 to NumberOfTests - 1 loop
			WriteDataPort <= TestData(I);
			WriteAddress <= std_logic_vector(unsigned(WriteAddress) + 1);
			wait for ClockPeriod;
			ReadAddress <= std_logic_vector(unsigned(ReadAddress) + 1);
			wait for ClockPeriod;
		end loop;
		
		wait;
	end process;
	
	WE <= not WE after ClockPeriod / 2;
end;
