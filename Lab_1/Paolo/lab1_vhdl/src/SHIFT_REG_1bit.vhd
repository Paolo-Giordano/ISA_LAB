-----------------------------------------------------
-- Project: IALU
-- Author: Paolo
-- Date: 23/09/2021
-- File: SHIFT_REG.vhd
-- Design: shift reg used to delay the enable signal
-- based on series of flip flop
-----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SHIFT_REG_1bit is
  generic (N_g : integer := 2);    --N FF in series
  port (
    SHIFT_REG_IN_CLK    : in std_logic;
    SHIFT_REG_IN_RST_N  : in std_logic;
    SHIFT_REG_IN        : in std_logic;
    SHIFT_REG_OUT       : out std_logic
  );
end entity;

architecture behavioural of SHIFT_REG_1bit is

  signal delayed_in : std_logic_vector(N_g-1 downto 0);

begin

   delay_en : process(SHIFT_REG_IN_CLK, SHIFT_REG_IN_RST_N)
   variable delay_in : std_logic_vector(N_g-1 downto 0);
  begin
    if (SHIFT_REG_IN_RST_N = '0') then
      delayed_in <= (others => '0');
    elsif (SHIFT_REG_IN_CLK'event and SHIFT_REG_IN_CLK = '1') then
      delay_in := delayed_in;
      for i in N_g-1 downto 1 loop
        delay_in(i) := delay_in(i-1);
      end loop;
      delay_in(0) := SHIFT_REG_IN;
      delayed_in <= delay_in;
    end if;
  end process;
  
  SHIFT_REG_OUT <= delayed_in(N_g-1);



end architecture;
