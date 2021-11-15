----------------------------------------------------
-- Description : behavioural signed multiplier,
-- input on N1 and N2 bits, output on (N1+N2)-1 bits
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MBEmul is
  port (
  MULT_A         : in  std_logic_vector(31 downto 0);
  MULT_B         : in  std_logic_vector(31 downto 0);
  MULT_Z         : out std_logic_vector(63 downto 0)
  );
end entity;

architecture behavioural of MBEmul is

  signal unsigned_a       : unsigned (31 downto 0);
  signal unsigned_b       : unsigned (31 downto 0);
  signal unsigned_product : unsigned (63 downto 0);

begin

  unsigned_a <= unsigned(MULT_A);
  unsigned_b <= unsigned(MULT_B);
  unsigned_product <= unsigned_a * unsigned_b;
  MULT_Z  <= std_logic_vector(unsigned_product(63 downto 0));

end architecture;
