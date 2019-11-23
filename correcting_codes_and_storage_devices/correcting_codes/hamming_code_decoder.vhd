library ieee;
use ieee.std_logic_1164.all;

entity hamming_code_decoder is
	port (
		Code: in std_logic_vector(6 downto 0);
		Data: out std_logic_vector(3 downto 0);
		Error: out std_logic
	);
end hamming_code_decoder;

architecture behavioral of hamming_code_decoder is
begin
	Main: process (Code)
		variable ControlBits: std_logic_vector(0 to 2);
	begin
		ControlBits(0) := Code(6) xor Code(5) xor Code(4);
		ControlBits(1) := Code(6) xor Code(5) xor Code(3);
		ControlBits(2) := Code(6) xor Code(4) xor Code(3);
		
		if ControlBits = Code(2 downto 0) then
			Error <= '0';
		else
			Error <= '1';
		end if;
		Data <= Code(6 downto 3);
	end process;
end behavioral;
