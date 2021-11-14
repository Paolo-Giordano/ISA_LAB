library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.array_interface_pack.all;

entity MBE_mult is
  port (
  PP_matrix_in : in array_in;
  product_out : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture structural of MBE_mult is

  --constant N : integer := 16;

  component dadda_tree_4 is
    port (
      PP_matrix_in : in array_in;
      VS_out       : out std_logic_vector(N-1 downto 0);
      VC_out       : out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal vs,vc : std_logic_vector(N-1 downto 0);

begin

  i_dadda_tree: dadda_tree_4 port map(
  PP_matrix_in => PP_matrix_in,
  VS_out => vs,
  VC_out => vc
  );

  product_out <= std_logic_vector(unsigned(vs) + unsigned(vc));


end architecture;
