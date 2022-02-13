----------------------------------------------------------
--Description: bitwise XOR between bits of the same weight
--of two input signals A XOR B on N bits
----------------------------------------------------------
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BITWISE_XOR is
    generic (N_g:integer:=8);
    port (
        XOR_IN_A          : in std_logic_vector(N_g-1 downto 0);
        XOR_IN_B          : in std_logic_vector(N_g-1 downto 0);
        XOR_IN_EN         : in std_logic;
        XOR_OUT_RES       : out std_logic_vector(N_g-1 downto 0)
    );
end entity;

architecture behavioral of BITWISE_XOR is
    
    begin
        process (XOR_IN_A,XOR_IN_B,XOR_IN_EN)
        begin
            if (XOR_IN_EN='1')then
                for i in 0 to N_g-1 loop
                    XOR_OUT_RES (i) <= XOR_IN_A(i) XOR XOR_IN_B(i);
                end loop;
            else
                XOR_OUT_RES <= (others=>'0');
            end if;
        end process;

end architecture;