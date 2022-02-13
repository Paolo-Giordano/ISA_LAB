--------------------------------------------------
--Description: multiplexer with 2 inputs on N bits
--1 selection bit and a single output
--------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity MUX2TO1 is
    generic(N_g: integer:=4);
    port(
        MUX_IN_D0  : IN std_logic_vector (N_g-1 downto 0);
        MUX_IN_D1   : IN std_logic_vector (N_g-1 downto 0);
        MUX_IN_SEL  : IN std_logic;
        MUX_OUT     : OUT std_logic_vector (N_g-1 downto 0)
    );
end entity;
    
architecture behavioral of MUX2TO1 is
    
    begin
    
        MUX_OUT <= MUX_IN_D0 when MUX_IN_SEL='0' else
                   MUX_IN_D1;
end architecture;