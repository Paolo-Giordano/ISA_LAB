library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package array_interface_pack is
  constant N : integer := 8;
  type array_in is array (0 to 2) of std_logic_vector(N-1 downto 0);
end package;
