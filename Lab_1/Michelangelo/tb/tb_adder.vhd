library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_adder is
end tb_adder;

architecture beh of tb_adder is

  component adder is

    generic (N : integer := 4);
    port(
      adder_in_A : in std_logic_vector(N-1 downto 0);
      adder_in_B : in std_logic_vector(N-1 downto 0);
      adder_out  : out std_logic_vector(N-1 downto 0)
    );
    end component;

    constant N : integer := 4;

    signal adder_in_A,adder_in_B : std_logic_vector(N-1 downto 0);
    signal adder_out : std_logic_vector(N-1 downto 0);


begin

  adder_in_A <= "0101", "0111" after 5 ns, "0000" after 10 ns;
  adder_in_B <=  "1010","0100" after 5 ns, "1001" after 10 ns;

  i_ADD_id: adder generic map (N)
                        port map(adder_in_A,adder_in_B,adder_out);


end architecture;
