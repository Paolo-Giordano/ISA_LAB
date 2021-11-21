----------------------------------------------------
-- Description : behavioural signed multiplier,
-- input on N1 and N2 bits, output on (N1+N2)-1 bits
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MULTIPLIER_NBIT is
  generic (N1_g : integer := 9;
           N2_g : integer := 9);
  port (
  MULTIPLIER_IN_A         : in std_logic_vector(N1_g-1 downto 0);
  MULTIPLIER_IN_B         : in std_logic_vector(N2_g-1 downto 0);
  MULTIPLIER_OUT_PRODUCT  : out std_logic_vector((N1_g + N2_g)-2 downto 0)
  );
end entity;

architecture behavioural of MULTIPLIER_NBIT is

  signal signed_a       : signed (N1_g-1 downto 0);
  signal signed_b       : signed (N2_g-1 downto 0);
  signal signed_product : signed (N1_g+N2_g-1 downto 0);

begin

  signed_a <= signed(MULTIPLIER_IN_A);
  signed_b <= signed(MULTIPLIER_IN_B);
  signed_product <= signed_a * signed_b;
  MULTIPLIER_OUT_PRODUCT <= std_logic_vector(signed_product((N1_g + N2_g)-2 downto 0));

end architecture;
