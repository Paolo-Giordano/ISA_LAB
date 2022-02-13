-------------------------------------------------
--Description: behavioral generic REGISTER used as
-- PC. the reset value is the initial address of the
--instruction memory 4.194.304
-------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity REGISTER_PC is
    generic (N_g:integer:=32);
    port (
        REGISTER_IN_RST_N  : in std_logic;
        REGISTER_IN_CLK    : in std_logic;
        REGISTER_IN_EN     : in std_logic;
        REGISTER_IN_D      : in std_logic_vector(N_g-1 downto 0);
        REGISTER_OUT_Q     : out std_logic_vector(N_g-1 downto 0)
    );
end entity;

architecture behavioral of REGISTER_PC is

    constant INITIAL_ADDRESS_c : std_logic_vector(N_g-1 downto 0) := X"00400000";
    begin

        process (REGISTER_IN_RST_N, REGISTER_IN_CLK )
        begin
            if(REGISTER_IN_RST_N='0') then
                REGISTER_OUT_Q      <= INITIAL_ADDRESS_c;
            elsif (REGISTER_IN_CLK'event and REGISTER_IN_CLK='1') then
                if (REGISTER_IN_EN='1') then
                    REGISTER_OUT_Q  <= REGISTER_IN_D;
                end if;
            end if;
        end process;
end architecture;
