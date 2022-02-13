----------------------------------------------------------
--Description: bitwise AND between bits of the same weight
--of two input signals A and B on N bits
----------------------------------------------------------
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BITWISE_AND is
    generic (N_g:integer:=8);
    port (
        AND_IN_A          : in std_logic_vector(N_g-1 downto 0);
        AND_IN_B          : in std_logic_vector(N_g-1 downto 0);
        AND_IN_EN         : in std_logic;
        AND_OUT_RES       : out std_logic_vector(N_g-1 downto 0)
    );
end entity;

architecture behavioral of BITWISE_AND is
    
    begin
        process (AND_IN_A,AND_IN_B,AND_IN_EN)
        begin
            if (AND_IN_EN='1') then
                for i in 0 to N_g-1 loop
                    AND_OUT_RES (i) <= AND_IN_A(i) and AND_IN_B(i);
                end loop;
            else
                AND_OUT_RES <= (others=>'0');
            end if;
        end process;

end architecture;