--------------------------------------------------------
--Description: behavioral generic ADDER_SUBTRACTOR with 
--inputs on N_g bits, the input control signal sub_add_n
--has to be set to 0 to perform a sum, to 1 to perform a 
--subtraction
--------------------------------------------------------
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADDER_SUBTRACTOR is
    generic (N_g:integer:=8);
    port (
        ADD_SUB_IN_A          : in std_logic_vector(N_g-1 downto 0);
        ADD_SUB_IN_B          : in std_logic_vector(N_g-1 downto 0);
        ADD_SUB_IN_SUB_ADD_n  : in std_logic;
        ADD_SUB_IN_EN         : in std_logic;
        ADD_SUB_OUT_RES       : out std_logic_vector(N_g-1 downto 0)
    );
end entity;

architecture behavioral of ADDER_SUBTRACTOR is
    signal a_signed, b_signed, res_signed : signed (N_g-1 downto 0);
    begin
        a_signed        <= signed(ADD_SUB_IN_A);
        b_signed        <= signed(ADD_SUB_IN_B);
        process (ADD_SUB_IN_SUB_ADD_n,a_signed,b_signed,ADD_SUB_IN_EN)
        begin
            if (ADD_SUB_IN_EN='1') then
                if (ADD_SUB_IN_SUB_ADD_n='0') then
                    res_signed      <= a_signed + b_signed;
                else
                    res_signed      <= a_signed - b_signed;
                end if;
            else
                res_signed <= to_signed(0,32);
            end if;
        end process;
        ADD_SUB_OUT_RES   <= std_logic_vector(res_signed);

end architecture;