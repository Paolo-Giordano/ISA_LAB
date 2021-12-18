------------------------------------------------------------
-- DESCRIPTION: Stage for the reduction of PP using the Dadda tree.
-- Implementation is specific for each parallelism since the
-- reduction stage are developed by hand.
-- PACKAGE: A support package generate by a python script
-- contains all the constant used to instantiate the FA/HA
-- and the nonprocess bits. Another package contains the N
-- parallelsim, the information about odd/even parallelism
-- (operations slightly change) and the declaration of the
--  matrix used between PPunit and dadda_tree unit.
-- Anyway, the first process for the matrix realloation in a
-- piramid shape is suitable for each odd/even parallelsim and
-- the reductions stage for different parallelism differ only
-- on the index of the constant.
------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use work.array_interface_pack.all;
use work.constant_pack.all;

entity dadda_tree_31 is
  port (
    PP_matrix_in : in array_in;
    VS_out       : out std_logic_vector(61 downto 0);
    VC_out       : out std_logic_vector(61 downto 0)
  );
end entity;

architecture structural of dadda_tree_31 is
  component HA is
      port (
          HA_IN_A     : in std_logic;
          HA_IN_B     : in std_logic;
          HA_OUT_S    : out std_logic;
          HA_OUT_COUT : out std_logic
      );
  end component;

  component FA  is
    port (
      FA_IN_A     : in std_logic;
      FA_IN_B     : in std_logic;
      FA_IN_CIN   : in std_logic;
      FA_OUT_S    : out std_logic;
      FA_OUT_COUT : out std_logic
    );
  end component;

  --matrix stage doesn't have all the same number of rows, but we use the same to improve regularity
  --in the further stage non all the rows will be used
  type stage_array is array (0 to integer(N/2)) of std_logic_vector(2*N downto 0);
  signal stage_0, stage_1, stage_2, stage_3, stage_4, stage_5, stage_6   : stage_array;


  begin

    matrix_reallocation: process(pp_matrix_in)

    variable levels     : integer;
    variable no_realloc : integer;
    variable N_couples  : integer;
    variable to_realloc : integer;
	variable to_shift   : integer;
    begin

	levels      := ((N/2)+1);                           --number of levels, corresponding to the rows of the matrix
	no_realloc  := N+3;                                 --numebr of bits that don't need to be reallocate
	N_couples   := (N+1-4-2)/2;                         --number of couples of columns that have the same height on the left side of the matrix to be reallocated. From the most left N columns, 6 colums are subtracted, then the +1 is used to obtain the correct value for even/odd parallelisms (integer rounds to the floor automatically)

	  --move the bits that doesn't need to be reallocate
    for i in levels-1 downto 0 loop
      stage_0(i)(no_realloc downto 0) <= PP_matrix_in(i)(no_realloc downto 0);
    end loop;

    if N > 4 then
      --the first column to be reallocate has to be shifted up of one position
      to_realloc := 1;                              --number of colums from the colums that don't need to be reallocate, (left side)
	  to_shift   := 1;                              --number of rows that every of these colums has to shift up

      for i in 0 to levels-1-to_shift loop
         stage_0(i)(no_realloc+to_realloc ) <= PP_matrix_in(i+to_shift)(no_realloc+to_realloc);
      end loop;

		  --for each couples of colums with the same height, shift up of the same quantity
		  --incrementing var to_realloc, we move in the next couple of colums where 1 additional shift up has to be done
      to_realloc := to_realloc+1;
		  to_shift := to_shift+1;
      for j in 0 to N_couples-1 loop
        for i in 0 to levels-1-to_shift loop
          stage_0(i)(no_realloc+to_realloc) 	<= PP_matrix_in(i+to_shift)(no_realloc+to_realloc);
          stage_0(i)(no_realloc+to_realloc+1) <= PP_matrix_in(i+to_shift)(no_realloc+to_realloc+1);
        end loop;
        to_realloc := to_realloc+2;
		    to_shift := to_shift+1;
      end loop;

		  --finally shift up the last colums, which is alone. In the case of odd parallelism is not perfomed cause the last row
      --has the same height of the second last and they are already instantiated in the previous loop for couples.
      if (N mod 2) = 0 then
        for i in 0 to levels-1-to_shift loop
          stage_0(i)(no_realloc+to_realloc)<= PP_matrix_in(i+to_shift)(no_realloc+to_realloc);
        end loop;
      end if;
    end if;
	  --add a final zero that will be useful in the reduction stage to don't exceed index
    for i in levels-1 downto 0 loop
      stage_0(i)(2*N) <= '0';
    end loop;
  end process;

    --stage 1
    g_stage_1 : for i in 0 to 2*N-1 generate

      --add the half adder if it is present, the input are the first two value of current column
      --the outputs are placed in the next matrix stage
      --for the sum value, we have to take into account how many value we have already added from
      --the previous column, that depends on the number of HA and FA in that column
      --the cout value will be put on the first row, colum+1 of the next stage
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
      --output: sum is placed in the same column of next stage matrix, considering all the value already
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

    --next stages follow the same configuration of the first, increment all the X in stage_X, N_HA_X, N_FA_X and n_unproc_X of 1 by hand.
    --stage 2
    g_stage_2 : for i in 0 to 2*N-1 generate

      g_HA: for j in 0 to N_HA_1(i+1)-1 generate
        i_HA: HA port map(
        HA_IN_A     => stage_1(0)(i),
        HA_IN_B     => stage_1(1)(i),
        HA_OUT_S    => stage_2( N_HA_1(i) + N_FA_1(i) )(i),
        HA_OUT_COUT => stage_2(0)(i+1)
        );
      end generate;

      g_FA: for j in 0 to N_FA_1(i+1)-1 generate
        i_FA: FA port map(
        FA_IN_A     => stage_1(3*j + 2*N_HA_1(i+1) + 0)(i),
        FA_IN_B     => stage_1(3*j + 2*N_HA_1(i+1) + 1)(i),
        FA_IN_CIN   => stage_1(3*j + 2*N_HA_1(i+1) + 2)(i),
        FA_OUT_S    => stage_2(N_HA_1(i) + N_FA_1(i) + N_HA_1(i+1) + j)(i),
        FA_OUT_COUT => stage_2(N_HA_1(i+1) + j)(i+1)
        );
      end generate;

      g_noproc: for j in 0 to N_noproc_1(i+1)-1 generate
        stage_2(N_HA_1(i) + N_FA_1(i) + N_HA_1(i+1) + N_FA_1(i+1) + j)(i) <= stage_1(2*N_HA_1(i+1) + 3*N_FA_1(i+1) + j)(i);
      end generate;
    end generate;


    --stage 3
    g_stage_3 : for i in 0 to 2*N-1 generate
      g_HA: for j in 0 to N_HA_2(i+1)-1 generate
        i_HA: HA port map(
        HA_IN_A     => stage_2(0)(i),
        HA_IN_B     => stage_2(1)(i),
        HA_OUT_S    => stage_3( N_HA_2(i) + N_FA_2(i) )(i),
        HA_OUT_COUT => stage_3(0)(i+1)
        );
      end generate;

      g_FA: for j in 0 to N_FA_2(i+1)-1 generate
        i_FA: FA port map(
        FA_IN_A     => stage_2(3*j + 2*N_HA_2(i+1) + 0)(i),
        FA_IN_B     => stage_2(3*j + 2*N_HA_2(i+1) + 1)(i),
        FA_IN_CIN   => stage_2(3*j + 2*N_HA_2(i+1) + 2)(i),
        FA_OUT_S    => stage_3(N_HA_2(i) + N_FA_2(i) + N_HA_2(i+1) + j)(i),
        FA_OUT_COUT => stage_3(N_HA_2(i+1) + j)(i+1)
        );
      end generate;

      g_noproc: for j in 0 to N_noproc_2(i+1)-1 generate
        stage_3(N_HA_2(i) + N_FA_2(i) + N_HA_2(i+1) + N_FA_2(i+1) + j)(i) <= stage_2(2*N_HA_2(i+1) + 3*N_FA_2(i+1) + j)(i);
      end generate;
    end generate;

    --stage 4
    g_stage_4 : for i in 0 to 2*N-1 generate
      g_HA: for j in 0 to N_HA_3(i+1)-1 generate
        i_HA: HA port map(
        HA_IN_A     => stage_3(0)(i),
        HA_IN_B     => stage_3(1)(i),
        HA_OUT_S    => stage_4( N_HA_3(i) + N_FA_3(i) )(i),
        HA_OUT_COUT => stage_4(0)(i+1)
        );
      end generate;

      g_FA: for j in 0 to N_FA_3(i+1)-1 generate
        i_FA: FA port map(
        FA_IN_A     => stage_3(3*j + 2*N_HA_3(i+1) + 0)(i),
        FA_IN_B     => stage_3(3*j + 2*N_HA_3(i+1) + 1)(i),
        FA_IN_CIN   => stage_3(3*j + 2*N_HA_3(i+1) + 2)(i),
        FA_OUT_S    => stage_4(N_HA_3(i) + N_FA_3(i) + N_HA_3(i+1) + j)(i),
        FA_OUT_COUT => stage_4(N_HA_3(i+1) + j)(i+1)
        );
      end generate;

      g_noproc: for j in 0 to N_noproc_3(i+1)-1 generate
        stage_4(N_HA_3(i) + N_FA_3(i) + N_HA_3(i+1) + N_FA_3(i+1) + j)(i) <= stage_3(2*N_HA_3(i+1) + 3*N_FA_3(i+1) + j)(i);
      end generate;
    end generate;

    --stage 5
    g_stage_5 : for i in 0 to 2*N-1 generate
      g_HA: for j in 0 to N_HA_4(i+1)-1 generate
        i_HA: HA port map(
        HA_IN_A     => stage_4(0)(i),
        HA_IN_B     => stage_4(1)(i),
        HA_OUT_S    => stage_5( N_HA_4(i) + N_FA_4(i) )(i),
        HA_OUT_COUT => stage_5(0)(i+1)
        );
      end generate;

      g_FA: for j in 0 to N_FA_4(i+1)-1 generate
        i_FA: FA port map(
        FA_IN_A     => stage_4(3*j + 2*N_HA_4(i+1) + 0)(i),
        FA_IN_B     => stage_4(3*j + 2*N_HA_4(i+1) + 1)(i),
        FA_IN_CIN   => stage_4(3*j + 2*N_HA_4(i+1) + 2)(i),
        FA_OUT_S    => stage_5(N_HA_4(i) + N_FA_4(i) + N_HA_4(i+1) + j)(i),
        FA_OUT_COUT => stage_5(N_HA_4(i+1) + j)(i+1)
        );
      end generate;

      g_noproc: for j in 0 to N_noproc_4(i+1)-1 generate
        stage_5(N_HA_4(i) + N_FA_4(i) + N_HA_4(i+1) + N_FA_4(i+1) + j)(i) <= stage_4(2*N_HA_4(i+1) + 3*N_FA_4(i+1) + j)(i);
      end generate;
    end generate;

    --stage 6
    g_stage_6 : for i in 0 to 2*N-1 generate
      g_HA: for j in 0 to N_HA_5(i+1)-1 generate
        i_HA: HA port map(
        HA_IN_A     => stage_5(0)(i),
        HA_IN_B     => stage_5(1)(i),
        HA_OUT_S    => stage_6( N_HA_5(i) + N_FA_5(i) )(i),
        HA_OUT_COUT => stage_6(0)(i+1)
        );
      end generate;

      g_FA: for j in 0 to N_FA_5(i+1)-1 generate
        i_FA: FA port map(
        FA_IN_A     => stage_5(3*j + 2*N_HA_5(i+1) + 0)(i),
        FA_IN_B     => stage_5(3*j + 2*N_HA_5(i+1) + 1)(i),
        FA_IN_CIN   => stage_5(3*j + 2*N_HA_5(i+1) + 2)(i),
        FA_OUT_S    => stage_6(N_HA_5(i) + N_FA_5(i) + N_HA_5(i+1) + j)(i),
        FA_OUT_COUT => stage_6(N_HA_5(i+1) + j)(i+1)
        );
      end generate;

      g_noproc: for j in 0 to N_noproc_5(i+1)-1 generate
        stage_6(N_HA_5(i) + N_FA_5(i) + N_HA_5(i+1) + N_FA_5(i+1) + j)(i) <= stage_5(2*N_HA_5(i+1) + 3*N_FA_5(i+1) + j)(i);
      end generate;
    end generate;

    --take the final value. since the initial matrix was not regular after the sign extension
    --it is added a '0' on the second position to avoid isolated value, in this way it is possible
    --to add the RCA without further operation
    VS_out <= stage_6(0)(61 downto 0);
    VC_out <= stage_6(1)(61 downto 2) & '0' & stage_6(1)(0);

end architecture;
