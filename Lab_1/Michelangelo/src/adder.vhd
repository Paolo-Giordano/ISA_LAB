library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is

  generic (N : integer := 4);
  port(
    adder_in_A : in std_logic_vector(N-1 downto 0);
    adder_in_B : in std_logic_vector(N-1 downto 0);
    adder_out  : out std_logic_vector(N-1 downto 0)
  );
  end adder;

architecture beh of adder is

begin

  MULT_proc: process(adder_in_A,adder_in_B)
  begin
    adder_out <= std_logic_vector( signed( adder_in_A ) + signed( adder_in_B ) );
  end process;

end architecture;
