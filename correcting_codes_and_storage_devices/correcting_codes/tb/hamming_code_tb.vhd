library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity hamming_code_tb is
end hamming_code_tb;
 
architecture behavioral of hamming_code_tb is 
	component hamming_code_encoder
		port (
			Data: in std_logic_vector(3 downto 0);
			Code: out std_logic_vector(6 downto 0)
		);
   end component;
	
	component hamming_code_decoder
		port (
			Code: in std_logic_vector(6 downto 0);
			Data: out std_logic_vector(3 downto 0);
			Error: out std_logic
		);
	end component;
	
   signal DataIn, DataOut: std_logic_vector(3 downto 0);
	signal CodeIn, CodeOut: std_logic_vector(6 downto 0);
	
	signal InjectError: std_logic;
	signal Error: std_logic_vector(6 downto 0);
	
	signal ErrorDetected: std_logic;
begin
	Encoder: hamming_code_encoder
		port map (
			Data => DataIn,
			Code => CodeOut
		);
	
	Decoder: hamming_code_decoder
		port map (
			Code => CodeIn,
			Data => DataOut,
			Error => ErrorDetected
		);
		
	CodeIn <= CodeOut when InjectError = '0' else Error;

	Stimulus: process
	begin
		-- Reset inputs
		DataIn <= (others => '0');
		InjectError <= '0';
		Error <= (others => '0');
		wait for 10 ns;
		
		-- No error case
		for I in 0 to 14 loop
			DataIn <= std_logic_vector(unsigned(DataIn) + 1);
			wait for 10 ns;
		end loop;

		-- Error case
		DataIn <= "1001";
		InjectError <= '1';
		Error <= "1101100";
		wait for 10 ns;
	end process;
end;
