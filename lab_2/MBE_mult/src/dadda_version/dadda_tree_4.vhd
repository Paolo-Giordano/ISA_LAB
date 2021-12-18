library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.array_interface_pack.all;
use work.constant_pack.all;

--caso N = 4

entity dadda_tree_4 is
  port (
    PP_matrix_in : in array_in;
    VS_out       : out std_logic_vector(7 downto 0);
    VC_out       : out std_logic_vector(7 downto 0)
  );
end entity;

architecture structural of dadda_tree_4 is

  component HA is
      port (
          HA_IN_A : in std_logic;
          HA_IN_B : in std_logic;
          HA_OUT_S : out std_logic;
          HA_OUT_COUT : out std_logic
      );
  end component;

  component FA  is
    port (
      FA_IN_A: in std_logic;
      FA_IN_B: in std_logic;
      FA_IN_CIN: in std_logic;
      FA_OUT_S: out std_logic;
      FA_OUT_COUT: out std_logic
    );
  end component;

  --signal
  type stage_array is array (0 to 2) of std_logic_vector(8 downto 0);
  signal stage_0, stage_1 : stage_array;
begin

  matrix_ext: for i in 0 to 2 generate
    stage_0(i) <= '0' & PP_matrix_in(i);
  end generate;

  --stage 1
  g_stage_1 : for i in 0 to 2*N-1 generate

    --add the half adder if it is present, the input are the first two value of current column
    --the output are placed in the next matrix stage
    --for the sum value, we have to take into account how many value we have already added from
    --the previous column, that depends on the number of HA and FA in that column
    g_HA: for j in 0 to N_HA_0(i+1)-1 generate
      i_HA: HA port map(
      HA_IN_A     => stage_0(0)(i),
      HA_IN_B     => stage_0(1)(i),
      HA_OUT_S    => stage_1( N_HA_0(i) + N_FA_0(i) )(i),
      HA_OUT_COUT => stage_1(0)(i+1)
      );
    end generate;

    --add full adders
    --input: 3 consecutive value in the corrisponding column, with a offset of 2 bit if an half adder is present
    --output: sum in placed in the same column of next stage matrix, considering all the value already
    --        placed from the previous HA and FA column(carry out) and the HA in this column if present
    --        cout in placed in next column, after the cout of the HA if it is present
    g_FA: for j in 0 to N_FA_0(i+1)-1 generate
      i_FA: FA port map(
      FA_IN_A     => stage_0(3*j + 2*N_HA_0(i+1) + 0)(i),
      FA_IN_B     => stage_0(3*j + 2*N_HA_0(i+1) + 1)(i),
      FA_IN_CIN   => stage_0(3*j + 2*N_HA_0(i+1) + 2)(i),
      FA_OUT_S    => stage_1(N_HA_0(i) + N_FA_0(i) + N_HA_0(i+1) + j)(i),
      FA_OUT_COUT => stage_1(N_HA_0(i+1) + j)(i+1)
      );
    end generate;

    --no processed bit are taken considering how many FA and HA are placed in the column of the matrix in this stage and
    -- are placed in the same column of the next stage matrix, considering how many value are already present from the carry out of previous column
    -- and the sum of the current column
    g_noproc: for j in 0 to N_noproc_0(i+1)-1 generate
      stage_1(N_HA_0(i) + N_FA_0(i) + N_HA_0(i+1) + N_FA_0(i+1) + j)(i) <= stage_0(2*N_HA_0(i+1) + 3*N_FA_0(i+1) + j)(i);
    end generate;

  end generate;

  VS_out <= stage_1(0)(7 downto 0);
  VC_out <= stage_1(1)(7 downto 2) & '0' & stage_1(0)(0);



end architecture;
