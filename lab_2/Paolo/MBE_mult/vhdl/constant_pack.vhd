library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


package constant_pack is


    type const_vec_2 is array (16 downto 0) of integer range 0 to 16;

    --reduction step 0
    constant N_HA_0       : const_vec_2 := (0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0);
    constant N_FA_0       : const_vec_2 := (0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    constant N_noproc_0   : const_vec_2 := (2, 3, 3, 2, 2, 2, 2, 2, 2, 3, 3, 4, 2, 3, 1, 2, 0);

    --reduction step 1
    constant N_HA_1       : const_vec_2 := (0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0);
    constant N_FA_1       : const_vec_2 := (0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0);
    constant N_noproc_1   : const_vec_2 := (2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 1, 2, 0);

    --reduction step 2
    constant N_HA_2       : const_vec_2 := (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0);
    constant N_FA_2       : const_vec_2 := (1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0);
    constant N_noproc_2   : const_vec_2 := (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 0);


end package;
