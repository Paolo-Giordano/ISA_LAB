library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity FA  is
  port (
		FA_IN_A: in std_logic;
		FA_IN_B: in std_logic;
		FA_IN_CIN: in std_logic;
		FA_OUT_S: out std_logic;
		FA_OUT_COUT: out std_logic
  );
end FA;

architecture struct of FA is
	signal s1 : std_logic;
begin
	s1<= FA_IN_A xor FA_IN_B;
	FA_OUT_S <= s1 xor FA_IN_CIN;
	FA_OUT_COUT <= (FA_IN_A and FA_IN_B) or (s1 and FA_IN_CIN);
end struct;
