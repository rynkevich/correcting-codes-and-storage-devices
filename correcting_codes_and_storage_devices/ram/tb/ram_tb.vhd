library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity ram_tb is
end ram_tb;
 
architecture behavioral of ram_tb is 
	constant TestWordSize: integer := 4;
	constant TestAddressSize: integer := 2;
	constant NumberOfTests: integer := 4;
	
	component ram
		generic (
			WordSize: integer;
			AddressSize: integer
		);
		port (
			CLK, WE: in std_logic;
			Address: in std_logic_vector(AddressSize - 1 downto 0);
			Din: in std_logic_vector(WordSize - 1 downto 0);
			Dout: out std_logic_vector(WordSIze - 1 downto 0)
		);
   end component;
	
	type TTestData is array(0 to NumberOfTests - 1) of std_logic_vector(TestWordSize - 1 downto 0);
	
	signal CLK: std_logic := '0';
	signal WE: std_logic := '0';
	signal Din: std_logic_vector(TestWordSize - 1 downto 0);
	signal Address: std_logic_vector(TestAddressSize - 1 downto 0) := "00";
	
	signal Dout: std_logic_vector(TestWordSize - 1 downto 0);
	
	constant ClockPeriod: time := 10 ns;
	constant TestData: TTestData := ("1000", "0001", "1111", "0110");
begin
	UUT: ram
		generic map (
			WordSize => TestWordSize,
			AddressSize => TestAddressSize
		)
		port map (
			CLK => CLK,
			WE => WE,
			Address => Address,
			Din => Din,
			Dout => Dout
		);
		
	Stimulus: process
	begin
		for I in 0 to NumberOfTests - 1 loop
			WE <= '1';
			Din <= TestData(I);
			Address <= std_logic_vector(unsigned(Address) + 1);
			wait for ClockPeriod;
			WE <= '0';
			wait for ClockPeriod;
		end loop;
		
		wait;
	end process;
	
	CLK <= not CLK after ClockPeriod / 2;
end;
