-------------------------------------------------
--Description: behavioral generic REGISTER with 
--inputs on N bits
-------------------------------------------------
 
library IEEE;
use IEEE.std_logic_1164.all;

entity REGISTER_NBIT is
    generic (N_g:integer:=8);
    port (
        REGISTER_IN_RST_N  : in std_logic;
        REGISTER_IN_CLK    : in std_logic;
        REGISTER_IN_EN     : in std_logic;
        REGISTER_IN_D      : in std_logic_vector(N_g-1 downto 0);
        REGISTER_OUT_Q     : out std_logic_vector(N_g-1 downto 0)
    );
end entity;

architecture behavioral of REGISTER_NBIT is

    begin

        process (REGISTER_IN_RST_N, REGISTER_IN_CLK )
        begin
            if(REGISTER_IN_RST_N='0') then
                REGISTER_OUT_Q      <= (others=>'0');
            elsif (REGISTER_IN_CLK'event and REGISTER_IN_CLK='1') then
                if (REGISTER_IN_EN='1') then
                    REGISTER_OUT_Q  <= REGISTER_IN_D;
                end if;
            end if;
        end process;
end architecture;