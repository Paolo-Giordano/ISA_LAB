-------------------------------------------------
--Description: behavioral flip flop
-------------------------------------------------
 
library IEEE;
use IEEE.std_logic_1164.all;

entity FF is
    port (
        FF_IN_RST_N  : in std_logic;
        FF_IN_CLK    : in std_logic;
        FF_IN_EN     : in std_logic;
        FF_IN_D      : in std_logic;
        FF_OUT_Q     : out std_logic
    );
end entity;

architecture behavioral of FF is

    begin

        process (FF_IN_RST_N, FF_IN_CLK )
        begin
            if(FF_IN_RST_N='0') then
                FF_OUT_Q      <= '0';
            elsif (FF_IN_CLK'event and FF_IN_CLK='1') then
                if (FF_IN_EN='1') then
                    FF_OUT_Q  <= FF_IN_D;
                end if;
            end if;
        end process;
end architecture;