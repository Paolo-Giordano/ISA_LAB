--------------------------------------------------
--Description: multiplexer with 8 inputs on N bits
--3 selection bits and a single output
--------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity MUX8TO1 is
generic(N_g: integer:=4);
port(
    MUX_IN_D0  : IN std_logic_vector (N_g-1 downto 0);
    MUX_IN_D1   : IN std_logic_vector (N_g-1 downto 0);
    MUX_IN_D2   : IN std_logic_vector (N_g-1 downto 0);
    MUX_IN_D3   : IN std_logic_vector (N_g-1 downto 0);
    MUX_IN_D4   : IN std_logic_vector (N_g-1 downto 0);
    MUX_IN_D5   : IN std_logic_vector (N_g-1 downto 0);
    MUX_IN_D6   : IN std_logic_vector (N_g-1 downto 0);
    MUX_IN_D7   : IN std_logic_vector (N_g-1 downto 0);
    MUX_IN_SEL  : IN std_logic_vector (2 downto 0);
    MUX_OUT     : OUT std_logic_vector (N_g-1 downto 0)
);
end entity;

architecture behavioral of MUX8TO1 is

begin

    MUX_OUT <= MUX_IN_D0 when MUX_IN_SEL="000" else
        MUX_IN_D1 when MUX_IN_SEL="001" else  
        MUX_IN_D2 when MUX_IN_SEL="010" else
        MUX_IN_D3 when MUX_IN_SEL="011" else
        MUX_IN_D4 when MUX_IN_SEL="100" else
        MUX_IN_D5 when MUX_IN_SEL="101" else
        MUX_IN_D6 when MUX_IN_SEL="110" else
        MUX_IN_D7 ;
end architecture;