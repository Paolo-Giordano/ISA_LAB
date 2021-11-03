-------------------------------------------------
--Description: saturation unit for the input 
--represented in CA2 on 8 bits
--output on 7 bits
-------------------------------------------------
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SATURATION_UNIT is
    port (
        SU_IN_DATA  : in std_logic_vector (9 downto 0);
        SU_OUT_DATA : out std_logic_vector (8 downto 0)
    );
end entity;

architecture behavioral of SATURATION_UNIT is

    begin

        process (SU_IN_DATA )
        begin
            if(to_integer(signed(SU_IN_DATA)) > 2**8-1) then
                SU_OUT_DATA <= std_logic_vector(to_signed(255,9));
            elsif (to_integer(signed(SU_IN_DATA)) < -2**8) then
                SU_OUT_DATA <= std_logic_vector(to_signed(-256,9));
            else
                SU_OUT_DATA <= SU_IN_DATA(8 downto 0);
            end if;
        end process;
end architecture;