library ieee;
use ieee.std_logic_1164.all;

entity HA is
    port (
        HA_IN_A : in std_logic;
        HA_IN_B : in std_logic;
        HA_OUT_S : out std_logic;
        HA_OUT_COUT : out std_logic
    );
end HA;

architecture structure of ha is
begin
    HA_OUT_S <= HA_IN_A xor HA_IN_B;
    HA_OUT_COUT <= HA_IN_A and HA_IN_B;
end structure;
