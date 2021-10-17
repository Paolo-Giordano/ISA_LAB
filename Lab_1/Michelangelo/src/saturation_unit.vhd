library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity saturation_unit is

  port(
    saturation_unit_in : in std_logic_vector(7 downto 0);
    saturation_unit_out : out std_logic_vector(8 downto 0)
  );
end saturation_unit;

architecture beh of saturation_unit is

begin

  MUX_proc: process(saturation_unit_in)
  variable sign : std_logic;
  begin
    sign := saturation_unit_in(7);
    if ( saturation_unit_in(7) = saturation_unit_in(6) ) then
      --x4
      saturation_unit_out <= saturation_unit_in(7) & saturation_unit_in(5 downto 0) & "00";
    else
      --saturation
      saturation_unit_out(8) <= saturation_unit_in(7);
      saturation_unit_out(7 downto 0) <= (others => not saturation_unit_in(7));
    end if;
  end process;

end architecture;
