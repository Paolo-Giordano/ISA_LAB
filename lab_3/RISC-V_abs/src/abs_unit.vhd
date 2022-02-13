--------------------------------------------------------
--Description: behavioral generic ABSOLUTE VALUE UNIT with 
--input on N_g bits, to get the absolute value of a negative 
--number it has to be inverted and incremented by one, if 
--the input is positive no operations are needed ->
--all the input bits are put in XOR with the sign bit of 
--the input, then the sign bit is summed
--------------------------------------------------------
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ABS_UNIT is
    generic (N_g:integer:=8);
    port (
        ABS_UNIT_IN_A          : in std_logic_vector(N_g-1 downto 0);
        ABS_UNIT_IN_EN         : in std_logic;
        ABS_UNIT_OUT_RES       : out std_logic_vector(N_g-1 downto 0)
    );
end entity;

architecture behavioral of ABS_UNIT is
    signal res_signed : signed (N_g-1 downto 0);
    begin

        process (ABS_UNIT_IN_A,ABS_UNIT_IN_EN)
        variable xor_signal : std_logic_vector(N_g-1 downto 0);
        begin
            if (ABS_UNIT_IN_EN='1') then
                --the input is inverted if it's negative, otherwise is unchanged
                for i in 0 to N_g-1 loop
                    xor_signal(i)   := ABS_UNIT_IN_A(i) xor ABS_UNIT_IN_A(N_g-1);
                end loop;
                --1 is summed at the output of the XOR gates only if the input is negative
                if (ABS_UNIT_IN_A(N_g-1)='0') then
                    res_signed      <= signed(xor_signal);
                else
                    res_signed      <= signed(xor_signal)+to_signed(1,N_g);
                end if;
            else
                res_signed<=to_signed(0,32);
            end if;
        end process;
        ABS_UNIT_OUT_RES   <= std_logic_vector(res_signed);

end architecture;