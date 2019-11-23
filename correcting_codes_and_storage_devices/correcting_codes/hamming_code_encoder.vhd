library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity hamming_code_encoder is
	port (
		Data: in std_logic_vector(3 downto 0);
		Code: out std_logic_vector(6 downto 0)
	);
end hamming_code_encoder;

architecture behavioral of hamming_code_encoder is
begin
	Main: process (Data)
		variable Result: std_logic_vector(6 downto 0);
	begin
		Result := Data & "000";
		
		Result(2) := Data(3) xor Data(2) xor Data(1);
		Result(1) := Data(3) xor Data(2) xor Data(0);
		Result(0) := Data(3) xor Data(1) xor Data(0);
		
		Code <= Result;
	end process;
end behavioral;
