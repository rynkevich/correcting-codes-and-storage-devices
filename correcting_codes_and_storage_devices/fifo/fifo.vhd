library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity fifo is
	generic (
		WordSize: integer := 4;
		Depth: integer := 4
	);
	port ( 
		CLK, WE: in std_logic;
		Din: in std_logic_vector(WordSize - 1 downto 0);
		Dout: out std_logic_vector(WordSize - 1 downto 0);
		Empty, Full: out std_logic
	);
end fifo;

architecture behavioral of fifo is
	type TMemory is array (0 to Depth - 1) of std_logic_vector(WordSize - 1 downto 0);
	
	signal Memory: TMemory; 
	signal Head: natural range 0 to Memory'high := 0;
	signal Tail: natural range 0 to Memory'high := 0;
	signal IsLooped: boolean := False;
	signal IsFull: std_logic := '0';
	signal IsEmpty: std_logic := '1';
begin
	UpdateState: process (CLK)
	begin
		if rising_edge(CLK) then
			if WE = '1' then
				if IsLooped = False or Head /= Tail then
					if Head = Memory'high then
						Head <= 0;
						IsLooped <= True;
					else
						Head <= Head + 1;
					end if;
				end if;
			elsif IsLooped = True or Head /= Tail then
				if Tail = Memory'high then
					Tail <= 0;
					IsLooped <= False;
				else 
					Tail <= Tail + 1;
				end if;
			end if;
		end if;
		
		if Head /= Tail then
			IsEmpty <= '0';
			IsFull <= '0';
		elsif IsLooped then
			IsFull <= '1';
		else
			IsEmpty <= '1';
		end if;
	end process;
	
	Empty <= IsEmpty;
	Full <= IsFull;
	
	ReadProcess: process (Tail)
	begin
		if WE = '0' and IsEmpty = '0' then
			Dout <= Memory(Tail);
		else 
			Dout <= (others => 'Z');
		end if;
	end process;
	
	WriteProcess: process (Head)
	begin
		if WE = '1' and IsFull = '0' then	
			Memory(Head) <= Din;
		end if;
	end process;
end behavioral;