library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.array_interface_pack.all;
use work.constant_pack.all;

entity tb_dadda is
end entity;

architecture behavioral of tb_dadda is

  --constant N : integer := 16;

  component MBE_mult is
    port (
    PP_matrix_in : in array_in;
    product_out : out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal pp_matrix : array_in;
  signal product_out : std_logic_vector(N-1 downto 0);

begin
  --N=4
  pp_matrix(0) <= "01100011";
  pp_matrix(0) <= "101100-1";
  pp_matrix(0) <= "0000-0--";

  --N=8
  --pp_matrix(0) <= "1111100000000000";
  --pp_matrix(1) <= "00000111100011-0";
  --pp_matrix(2) <= "-00000111000-1--";
  --pp_matrix(3) <= "---0000000-0----";
  --pp_matrix(4) <= "----0000-0------";

  DUT : MBE_mult port map (pp_matrix, product_out);

end architecture;
