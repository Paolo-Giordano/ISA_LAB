-----------------------------------------
--Description: multiplexer with 8 inputs
--3 selection bits and a single output
-----------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux8to1 is
generic(N: integer:=4);
port(
    D0_IN   : IN std_logic_vector (N-1 downto 0);
    D1_IN   : IN std_logic_vector (N-1 downto 0);
    D2_IN   : IN std_logic_vector (N-1 downto 0);
    D3_IN   : IN std_logic_vector (N-1 downto 0);
    D4_IN   : IN std_logic_vector (N-1 downto 0);
    D5_IN   : IN std_logic_vector (N-1 downto 0);
    D6_IN   : IN std_logic_vector (N-1 downto 0);
    D7_IN   : IN std_logic_vector (N-1 downto 0);
    SEL_IN  : IN std_logic_vector (2 downto 0);
    D_OUT   : OUT std_logic_vector (N-1 downto 0)
);
end entity;

architecture behavioral of mux8to1 is

begin

D_OUT <= D0_IN when SEL_IN="000" else
         D1_IN when SEL_IN="001" else  
         D2_IN when SEL_IN="010" else
         D3_IN when SEL_IN="011" else
         D4_IN when SEL_IN="100" else
         D5_IN when SEL_IN="101" else
         D6_IN when SEL_IN="110" else
         D7_IN ;
end architecture;