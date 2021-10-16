-----------------------------------
--Description :
----------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REGISTER_NBIT is
  generic (N_g : integer := 9);
  port (
  REGISTER_NBIT_IN_CLK    : in std_logic;
  REGISTER_NBIT_IN_RST_N  : in std_logic;
  REGISTER_NBIT_IN_EN     : in std_logic;
  REGISTER_NBIT_IN_D      : in std_logic_vector(N_g-1 downto 0);
  REGISTER_NBIT_OUT_Q     : out std_logic_vector(N_g-1 downto 0)
  );
end entity;

architecture behavioural of REGISTER_NBIT is


begin

  in_reg: process(REGISTER_NBIT_IN_CLK, REGISTER_NBIT_IN_RST_N)
  begin
    if (REGISTER_NBIT_IN_RST_N = '0') then
      REGISTER_NBIT_OUT_Q <= (others => '0');
    elsif (REGISTER_NBIT_IN_CLK'event and REGISTER_NBIT_IN_CLK = '1') then
      if (REGISTER_NBIT_IN_EN = '1') then
        REGISTER_NBIT_OUT_Q <= REGISTER_NBIT_IN_D;
      end if;
    end if;
  end process;


end architecture;
