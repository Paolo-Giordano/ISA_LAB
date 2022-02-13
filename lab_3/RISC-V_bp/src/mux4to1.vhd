--------------------------------------------------
--Description: multiplexer with 4 inputs on N bits
--2 selection bits and a single output
--------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity MUX4TO1 is
generic(N_g: integer:=4);
port(
    MUX_IN_D0  : IN std_logic_vector (N_g-1 downto 0);
    MUX_IN_D1   : IN std_logic_vector (N_g-1 downto 0);
    MUX_IN_D2   : IN std_logic_vector (N_g-1 downto 0);
    MUX_IN_D3   : IN std_logic_vector (N_g-1 downto 0);
    MUX_IN_SEL  : IN std_logic_vector (1 downto 0);
    MUX_OUT     : OUT std_logic_vector (N_g-1 downto 0)
);
end entity;

architecture behavioral of MUX4TO1 is

begin

    MUX_OUT <= MUX_IN_D0 when MUX_IN_SEL="00" else
        MUX_IN_D1 when MUX_IN_SEL="01" else  
        MUX_IN_D2 when MUX_IN_SEL="10" else
        MUX_IN_D3;
end architecture;