library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_multiplier is
end tb_multiplier;

architecture beh of tb_multiplier is

  component multiplier is

    generic (N : integer := 4);
    port(
      multiplier_in_A : in std_logic_vector(N-1 downto 0);
      multiplier_in_B : in std_logic_vector(N-1 downto 0);
      multiplier_out  : out std_logic_vector(2*N-1 downto 0)
    );
    end component;

    constant N : integer := 4;

    signal multiplier_in_A,multiplier_in_B : std_logic_vector(N-1 downto 0);
    signal multiplier_out : std_logic_vector(2*N-1 downto 0);


begin

  multiplier_in_A <= "0101", "0111" after 5 ns, "0000" after 10 ns;
  multiplier_in_B <=  "1010","1000" after 5 ns, "1001" after 10 ns;

  i_MULT_id: multiplier generic map (N)
                        port map(multiplier_in_A,multiplier_in_B,multiplier_out);


end architecture;
