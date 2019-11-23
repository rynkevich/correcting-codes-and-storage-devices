library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity fifo_tb is
end fifo_tb;
 
architecture behavioral of fifo_tb is 
	constant TestWordSize: integer := 4;
	constant TestDepth: integer := 4;
	constant NumberOfTests: integer := 4;
	
	component fifo
		generic (
			WordSize: integer;
			Depth: integer
		);
		port ( 
			CLK, WE: in std_logic;
			Din: in std_logic_vector(WordSize - 1 downto 0);
			Dout: out std_logic_vector(WordSize - 1 downto 0);
			Empty, Full: out std_logic
		);
   end component;
	
	type TTestData is array(0 to NumberOfTests - 1) of std_logic_vector(TestWordSize - 1 downto 0);
	
	signal CLK: std_logic := '0';
	signal WE: std_logic := '0';
	signal Din: std_logic_vector(TestWordSize - 1 downto 0);
	signal Empty, Full: std_logic;
	
	signal Dout: std_logic_vector(TestWordSize - 1 downto 0);
	
	constant ClockPeriod: time := 10 ns;
	constant TestData: TTestData := ("1000", "0001", "1111", "0110");
begin
	UUT: fifo
		generic map (
			WordSize => TestWordSize,
			Depth => TestDepth
		)
		port map (
			CLK => CLK,
			WE => WE,
			Din => Din,
			Dout => Dout,
			Empty => Empty,
			Full => Full
		);
		
	Stimulus: process
	begin
		-- Push
		WE <= '1';
		for I in 0 to NumberOfTests - 1 loop
			Din <= TestData(I);
			wait for ClockPeriod;
		end loop;
		
		-- Pop
		WE <= '0';
		for I in 0 to NumberOfTests - 1 loop
			wait for ClockPeriod;
		end loop;
		
		wait;
	end process;
	
	CLK <= not CLK after ClockPeriod / 2;
end;
