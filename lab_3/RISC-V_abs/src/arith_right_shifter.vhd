--------------------------------------------------------
--Description: behavioral arithmetic right shifter, N is
--the parallelism of the input control signal SHAMT that
--tells how many shift in the right direction have to be
--performed, the parallelism of the shifted input is 2^N
--------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ARITH_RIGHT_SHIFTER is
    generic (N_g:integer:=5);
    port (
        SHIFTER_IN_A          : in std_logic_vector(2**N_g-1 downto 0);
        SHIFTER_IN_EN         : in std_logic;
        SHIFTER_IN_SHAMT      : in std_logic_vector(N_g-1 downto 0);
        SHIFTER_OUT           : out std_logic_vector(2**N_g-1 downto 0)
    );
end entity;

architecture behavioral of ARITH_RIGHT_SHIFTER is

    begin
        process (SHIFTER_IN_A, SHIFTER_IN_SHAMT,SHIFTER_IN_EN )
            --temporary variable where store shifted value
            variable tmp_shifter_out : std_logic_vector(2**N_g-1 downto 0);
        begin
            tmp_shifter_out := SHIFTER_IN_A;

            --for along SHIFTER_IN_SHAMT
            --shift of 1 position for bit 0, 2 positions for bit 1
            --4 positions for bit 3,...
            if (SHIFTER_IN_EN='1') then
                for i in 0 to N_g-1 loop
                if(SHIFTER_IN_SHAMT(i) = '1') then
                    tmp_shifter_out := (2**N_g-1 downto 2**N_g-1-2**i => tmp_shifter_out(2**N_g-1)) & tmp_shifter_out(2**N_g-2 downto 2**i);
                end if;
                end loop;
            else
            tmp_shifter_out := (others=>'0');
            end if;
            SHIFTER_OUT <= tmp_shifter_out;

        end process;
end architecture;
