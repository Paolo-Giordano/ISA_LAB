library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

package array_interface_pack is
  constant N       : integer := 32;
  --array to pass the partial products among sub-components of the system
  --the number of PPs is integer(N/2 +1)
  type array_in is array (0 to integer(N/2)) of std_logic_vector(2*N-1 downto 0);

end package;
