library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_hamming is
	port (
		CLK, WE: in std_logic;
		Address: in std_logic_vector(1 downto 0);
		Din: in std_logic_vector(3 downto 0);
		Dout: out std_logic_vector(3 downto 0);
		Error: out std_logic
	);
end ram_hamming;

architecture structural of ram_hamming is
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
   
	component hamming_code_encoder is
		port (
			Data: in std_logic_vector(3 downto 0);
			Code: out std_logic_vector(6 downto 0)
		);
	end component;
	
	component hamming_code_decoder is
		port (
			Code: in std_logic_vector(6 downto 0);
			Data: out std_logic_vector(3 downto 0);
			Error: out std_logic
		);
	end component;
	
	signal InternalIn, InternalOut: std_logic_vector(6 downto 0);
begin
	HammingEncoder: hamming_code_encoder port map (Data => Din, Code => InternalIn);
	
	Memory: ram 
		generic map (WordSize => 7, AddressSize => 2)
		port map (
			CLK => CLK,
			WE => WE,
			Address => Address,
			Din => InternalIn,
			Dout => InternalOut
		);
		
	HammingDecoder: hamming_code_decoder port map (Code => InternalOut, Data => Dout, Error => Error);
end architecture structural;