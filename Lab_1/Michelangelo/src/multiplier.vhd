library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is

  generic (N : integer := 4);
  port(
    multiplier_in_A : in std_logic_vector(N-1 downto 0);
    multiplier_in_B : in std_logic_vector(N-1 downto 0);
    multiplier_out  : out std_logic_vector(2*N-1 downto 0)
  );
  end multiplier;

architecture beh of multiplier is

begin

  MULT_proc: process(multiplier_in_A,multiplier_in_B)
  begin
    multiplier_out <= std_logic_vector( signed( multiplier_in_A ) * signed( multiplier_in_B ) );
  end process;

end architecture;
