-----------------------------------------
--Description: multiplier on 32 bit. the PP unit implements
--the sign extension for unsigned multiplication. The Dadda
-- unit is specific for the parallelism, but the structure can be
-- easily adapted for every parallelism, even or odd.
-- final adder is behavioural
-----------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.array_interface_pack.all;

entity MBEmult is
  port (
  MULT_A : in std_logic_vector(31 downto 0);
  MULT_B : in std_logic_vector(31 downto 0);
  MULT_Z : out std_logic_vector(63 downto 0)
  );
end entity;

architecture structural of MBEmult is

  component PPunit is
  generic(N_g:integer:=4);
  port(
      A_IN        : IN std_logic_vector (N_g-1 downto 0);
      B_IN        : IN std_logic_vector (N_g-1 downto 0);
      PP_array    : OUT array_in
  );
  end component;

  component dadda_tree_32 is
    port (
      PP_matrix_in : in array_in;
      VS_out       : out std_logic_vector(63 downto 0);
      VC_out       : out std_logic_vector(63 downto 0)
    );
  end component;

  component ADDER_NBIT is
      generic (N_g:integer:=8);
      port (
          ADDER_IN_A      : in std_logic_vector(N_g-1 downto 0);
          ADDER_IN_B      : in std_logic_vector(N_g-1 downto 0);
          ADDER_OUT_SUM   : out std_logic_vector(N_g-1 downto 0)
      );
  end component;

  signal pp_array : array_in;
  signal vs,vc : std_logic_vector(2*N-1 downto 0);

begin

  i_PPunit: PPunit generic map(32) port map(
  A_IN      => MULT_A,
  B_IN      => MULT_B,
  PP_array  => pp_array
  );

  i_dadda_tree: dadda_tree_32 port map(
  PP_matrix_in  => pp_array,
  VS_out        => vs,
  VC_out        => vc
  );

  i_adder: ADDER_NBIT generic map(64) port map(
  ADDER_IN_A    => vs,
  ADDER_IN_B    => vc,
  ADDER_OUT_SUM => MULT_Z
  );




end architecture;
