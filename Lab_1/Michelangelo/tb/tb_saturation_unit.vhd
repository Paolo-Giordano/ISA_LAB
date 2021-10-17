library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_saturation_unit is
end tb_saturation_unit;

architecture beh of tb_saturation_unit is

  component saturation_unit is

    port(
      saturation_unit_in : in std_logic_vector(7 downto 0);
      saturation_unit_out : out std_logic_vector(8 downto 0)
    );
  end component;

    signal saturation_unit_in : std_logic_vector(7 downto 0);
    signal saturation_unit_out : std_logic_vector(8 downto 0);


begin

  saturation_unit_in <= "11010101", "10111111" after 5 ns, "11000000" after 10 ns,
                "11000000" after 15 ns, "10111111" after 20 ns;

  i_SAT_id: saturation_unit port map(saturation_unit_in,saturation_unit_out);


end architecture;
