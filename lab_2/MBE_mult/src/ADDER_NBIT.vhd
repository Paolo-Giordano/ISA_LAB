-------------------------------------------------
--Description: behavioral generic ADDER with 
--inputs on N bits
-------------------------------------------------
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADDER_NBIT is
    generic (N_g:integer:=8);
    port (
        ADDER_IN_A      : in std_logic_vector(N_g-1 downto 0);
        ADDER_IN_B      : in std_logic_vector(N_g-1 downto 0);
        ADDER_OUT_SUM   : out std_logic_vector(N_g-1 downto 0)
    );
end entity;

architecture behavioral of ADDER_NBIT is
    signal a_unsigned, b_unsigned, sum_unsigned : unsigned (N_g-1 downto 0);
    begin
        a_unsigned        <= unsigned(ADDER_IN_A);
        b_unsigned        <= unsigned(ADDER_IN_B);
        sum_unsigned      <= a_unsigned + b_unsigned;
        ADDER_OUT_SUM     <= std_logic_vector(sum_unsigned);

end architecture;
