----------------------------------------------------
-- Description : Fir filter implemented with direct form
-- N = 10 number of stage
-- Nb = 9 input/output parallelism
-- applying an internal shift of the input data and of the
-- multiplier out to reduce the total area. The shift are
-- performed to guarantee  a maximun THD of -30 dB
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MYFIR is
    port (
        MYFIR_IN_RST_n          : in std_logic;
        MYFIR_IN_CLK            : in std_logic;
        MYFIR_IN_b0             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b1             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b2             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b3             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b4             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b5             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b6             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b7             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b8             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b9             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b10            : in std_logic_vector(8 downto 0);
        MYFIR_IN_VIN            : in std_logic;
        MYFIR_IN_DIN            : in std_logic_vector(8 downto 0);
        MYFIR_OUT_VOUT          : out std_logic;
        MYFIR_OUT_DOUT          : out std_logic_vector(8 downto 0)
    );
end entity;

architecture structural of MYFIR is

  component REGISTER_NBIT is
    generic (N_g : integer := 9);
    port (
    REGISTER_NBIT_IN_CLK    : in std_logic;
    REGISTER_NBIT_IN_RST_N  : in std_logic;
    REGISTER_NBIT_IN_EN     : in std_logic;
    REGISTER_NBIT_IN_D      : in std_logic_vector(N_g-1 downto 0);
    REGISTER_NBIT_OUT_Q     : out std_logic_vector(N_g-1 downto 0)
    );
  end component;

  component SHIFT_REG_1bit is
    generic (N_g : integer := 2);    --N FF in series
    port (
      SHIFT_REG_IN_CLK    : in std_logic;
      SHIFT_REG_IN_RST_N  : in std_logic;
      SHIFT_REG_IN        : in std_logic;
      SHIFT_REG_OUT       : out std_logic
    );
  end component;

  component ADDER_NBIT is
    generic (N_g : integer := 9);
    port (
    ADDER_IN_A    : in std_logic_vector(N_g -1 downto 0);
    ADDER_IN_B    : in std_logic_vector(N_g -1 downto 0);
    ADDER_OUT_SUM : out std_logic_vector(N_g -1 downto 0)
    );
  end component;

  component MULTIPLIER_NBIT is
    generic (N1_g : integer := 9;
             N2_g : integer := 9);
    port (
    MULTIPLIER_IN_A         : in std_logic_vector(N1_g-1 downto 0);
    MULTIPLIER_IN_B         : in std_logic_vector(N2_g-1 downto 0);
    MULTIPLIER_OUT_PRODUCT  : out std_logic_vector((N1_g + N2_g)-2 downto 0)
    );
  end component;

  constant Nb_c               : integer := 9;
  constant shift_input_c      : integer := 0;
  constant shift_output_mul_c : integer := 10 - shift_input_c;
  --delayed coefficient signals
  signal delay_myfir_b0, delay_myfir_b1, delay_myfir_b2 : std_logic_vector(Nb_c-1 downto 0);
  signal delay_myfir_b3, delay_myfir_b4, delay_myfir_b5 : std_logic_vector(Nb_c-1 downto 0);
  signal delay_myfir_b6, delay_myfir_b7, delay_myfir_b8 : std_logic_vector(Nb_c-1 downto 0);
  signal delay_myfir_b9, delay_myfir_b10                : std_logic_vector(Nb_c-1 downto 0);
  -- delayed input, VIN and data_in are collect togheter
  signal myfir_data_in, delay_myfir_data_in  : std_logic_vector(Nb_c downto 0);
  signal shifted_data_in                     : std_logic_vector(Nb_c - shift_input_c -1 downto 0);
  signal final_delay_myfir_vin               : std_logic;
  --PIPE delay signals
  signal pipe_delay_1, pipe_delay_2, pipe_delay_3                : std_logic_vector(Nb_c - shift_input_c-1 downto 0);
  signal pipe_delay_4, pipe_delay_5, pipe_delay_6                : std_logic_vector(Nb_c - shift_input_c-1 downto 0);
  signal pipe_delay_7, pipe_delay_8, pipe_delay_9, pipe_delay_10 : std_logic_vector(Nb_c - shift_input_c-1 downto 0);
  -- MULT output
  signal mult_out_0, mult_out_1, mult_out_2       : std_logic_vector(2*Nb_c - shift_input_c - 2 downto 0);
  signal mult_out_3, mult_out_4, mult_out_5       : std_logic_vector(2*Nb_c - shift_input_c - 2 downto 0);
  signal mult_out_6, mult_out_7, mult_out_8       : std_logic_vector(2*Nb_c - shift_input_c - 2 downto 0);
  signal mult_out_9, mult_out_10                  : std_logic_vector(2*Nb_c - shift_input_c - 2 downto 0);
  -- Adder output
  signal adder_out_1, adder_out_2, adder_out_3                : std_logic_vector(7 downto 0);
  signal adder_out_4, adder_out_5, adder_out_6                : std_logic_vector(7 downto 0);
  signal adder_out_7, adder_out_8, adder_out_9, adder_out_10  : std_logic_vector(7 downto 0);
  --
  signal final_resut            : std_logic_vector (6 downto 0);
  signal shifted_final_result  : std_logic_vector(Nb_c -1 downto 0);
  signal final_vout             : std_logic;
begin

  --------   LOAD ALL THE COEFFICIENT BY REGISTER ------------
  coeff_b0: REGISTER_NBIT generic map(Nb_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => '1',
  REGISTER_NBIT_IN_D      => MYFIR_IN_b0,
  REGISTER_NBIT_OUT_Q     => delay_myfir_b0
  );

  coeff_b1: REGISTER_NBIT generic map(Nb_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => '1',
  REGISTER_NBIT_IN_D      => MYFIR_IN_b1,
  REGISTER_NBIT_OUT_Q     => delay_myfir_b1
  );

  coeff_b2: REGISTER_NBIT generic map(Nb_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => '1',
  REGISTER_NBIT_IN_D      => MYFIR_IN_b2,
  REGISTER_NBIT_OUT_Q     => delay_myfir_b2
  );

  coeff_b3: REGISTER_NBIT generic map(Nb_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => '1',
  REGISTER_NBIT_IN_D      => MYFIR_IN_b3,
  REGISTER_NBIT_OUT_Q     => delay_myfir_b3
  );

  coeff_b4: REGISTER_NBIT generic map(Nb_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => '1',
  REGISTER_NBIT_IN_D      => MYFIR_IN_b4,
  REGISTER_NBIT_OUT_Q     => delay_myfir_b4
  );

  coeff_b5: REGISTER_NBIT generic map(Nb_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => '1',
  REGISTER_NBIT_IN_D      => MYFIR_IN_b5,
  REGISTER_NBIT_OUT_Q     => delay_myfir_b5
  );

  coeff_b6: REGISTER_NBIT generic map(Nb_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => '1',
  REGISTER_NBIT_IN_D      => MYFIR_IN_b6,
  REGISTER_NBIT_OUT_Q     => delay_myfir_b6
  );

  coeff_b7: REGISTER_NBIT generic map(Nb_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => '1',
  REGISTER_NBIT_IN_D      => MYFIR_IN_b7,
  REGISTER_NBIT_OUT_Q     => delay_myfir_b7
  );

  coeff_b8: REGISTER_NBIT generic map(Nb_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => '1',
  REGISTER_NBIT_IN_D      => MYFIR_IN_b8,
  REGISTER_NBIT_OUT_Q     => delay_myfir_b8
  );

  coeff_b9: REGISTER_NBIT generic map(Nb_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => '1',
  REGISTER_NBIT_IN_D      => MYFIR_IN_b9,
  REGISTER_NBIT_OUT_Q     => delay_myfir_b9
  );

  coeff_b10: REGISTER_NBIT generic map(Nb_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => '1',
  REGISTER_NBIT_IN_D      => MYFIR_IN_b10,
  REGISTER_NBIT_OUT_Q     => delay_myfir_b10
  );


  --------------    LOAD INPUT DATA AND VIN   -----------------

  myfir_data_in <= MYFIR_IN_VIN & MYFIR_IN_DIN;

  reg_in_data: REGISTER_NBIT generic map(Nb_c + 1) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => '1',
  REGISTER_NBIT_IN_D      => myfir_data_in,
  REGISTER_NBIT_OUT_Q     => delay_myfir_data_in
  );

  -- shift the input signal = don't take the LSB's
  shifted_data_in <= delay_myfir_data_in(Nb_c -1 downto shift_input_c);

  ---------------   SHIFT REGISTER TO DELAY VIN AND BRING TO VOUT   -------------
  -- 10 is the depth of shifter
  delay_vin: SHIFT_REG_1bit generic map (10) port map(
  SHIFT_REG_IN_CLK    => MYFIR_IN_CLK,
  SHIFT_REG_IN_RST_N  => MYFIR_IN_RST_n,
  SHIFT_REG_IN        => delay_myfir_data_in(Nb_c),
  SHIFT_REG_OUT       => final_delay_myfir_vin
  );

  ------------       N STAGE OF PIPE    -----------------
  pipe_R1: REGISTER_NBIT generic map(Nb_c - shift_input_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => delay_myfir_data_in(Nb_c),
  REGISTER_NBIT_IN_D      => shifted_data_in,
  REGISTER_NBIT_OUT_Q     => pipe_delay_1
  );

  pipe_R2: REGISTER_NBIT generic map(Nb_c - shift_input_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => delay_myfir_data_in(Nb_c),
  REGISTER_NBIT_IN_D      => pipe_delay_1,
  REGISTER_NBIT_OUT_Q     => pipe_delay_2
  );

  pipe_R3: REGISTER_NBIT generic map(Nb_c - shift_input_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => delay_myfir_data_in(Nb_c),
  REGISTER_NBIT_IN_D      => pipe_delay_2,
  REGISTER_NBIT_OUT_Q     => pipe_delay_3
  );

  pipe_R4: REGISTER_NBIT generic map(Nb_c - shift_input_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => delay_myfir_data_in(Nb_c),
  REGISTER_NBIT_IN_D      => pipe_delay_3,
  REGISTER_NBIT_OUT_Q     => pipe_delay_4
  );

  pipe_R5: REGISTER_NBIT generic map(Nb_c - shift_input_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => delay_myfir_data_in(Nb_c),
  REGISTER_NBIT_IN_D      => pipe_delay_4,
  REGISTER_NBIT_OUT_Q     => pipe_delay_5
  );

  pipe_R6: REGISTER_NBIT generic map(Nb_c - shift_input_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => delay_myfir_data_in(Nb_c),
  REGISTER_NBIT_IN_D      => pipe_delay_5,
  REGISTER_NBIT_OUT_Q     => pipe_delay_6
  );

  pipe_R7: REGISTER_NBIT generic map(Nb_c - shift_input_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => delay_myfir_data_in(Nb_c),
  REGISTER_NBIT_IN_D      => pipe_delay_6,
  REGISTER_NBIT_OUT_Q     => pipe_delay_7
  );

  pipe_R8: REGISTER_NBIT generic map(Nb_c - shift_input_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => delay_myfir_data_in(Nb_c),
  REGISTER_NBIT_IN_D      => pipe_delay_7,
  REGISTER_NBIT_OUT_Q     => pipe_delay_8
  );

  pipe_R9: REGISTER_NBIT generic map(Nb_c - shift_input_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => delay_myfir_data_in(Nb_c),
  REGISTER_NBIT_IN_D      => pipe_delay_8,
  REGISTER_NBIT_OUT_Q     => pipe_delay_9
  );

  pipe_R10: REGISTER_NBIT generic map(Nb_c - shift_input_c) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => delay_myfir_data_in(Nb_c),
  REGISTER_NBIT_IN_D      => pipe_delay_9,
  REGISTER_NBIT_OUT_Q     => pipe_delay_10
  );


  ---------------   MULTIPLIER STAGE -----------
  -- coefficient are on 9 bits, data input can be shifted up to 4 bits to respect the THD
  mult_0: MULTIPLIER_NBIT generic map (Nb_c, Nb_c - shift_input_c) port map(
  MULTIPLIER_IN_A        => delay_myfir_b0,
  MULTIPLIER_IN_B        => shifted_data_in,
  MULTIPLIER_OUT_PRODUCT => mult_out_0
  );

  mult_1: MULTIPLIER_NBIT generic map (Nb_c, Nb_c - shift_input_c) port map(
  MULTIPLIER_IN_A        => delay_myfir_b1,
  MULTIPLIER_IN_B        => pipe_delay_1,
  MULTIPLIER_OUT_PRODUCT => mult_out_1
  );

  mult_2: MULTIPLIER_NBIT generic map (Nb_c, Nb_c - shift_input_c) port map(
  MULTIPLIER_IN_A        => delay_myfir_b2,
  MULTIPLIER_IN_B        => pipe_delay_2,
  MULTIPLIER_OUT_PRODUCT => mult_out_2
  );

  mult_3: MULTIPLIER_NBIT generic map (Nb_c, Nb_c - shift_input_c) port map(
  MULTIPLIER_IN_A        => delay_myfir_b3,
  MULTIPLIER_IN_B        => pipe_delay_3,
  MULTIPLIER_OUT_PRODUCT => mult_out_3
  );

  mult_4: MULTIPLIER_NBIT generic map (Nb_c, Nb_c - shift_input_c) port map(
  MULTIPLIER_IN_A        => delay_myfir_b4,
  MULTIPLIER_IN_B        => pipe_delay_4,
  MULTIPLIER_OUT_PRODUCT => mult_out_4
  );

  mult_5: MULTIPLIER_NBIT generic map (Nb_c, Nb_c - shift_input_c) port map(
  MULTIPLIER_IN_A        => delay_myfir_b5,
  MULTIPLIER_IN_B        => pipe_delay_5,
  MULTIPLIER_OUT_PRODUCT => mult_out_5
  );

  mult_6: MULTIPLIER_NBIT generic map (Nb_c, Nb_c - shift_input_c) port map(
  MULTIPLIER_IN_A        => delay_myfir_b6,
  MULTIPLIER_IN_B        => pipe_delay_6,
  MULTIPLIER_OUT_PRODUCT => mult_out_6
  );

  mult_7: MULTIPLIER_NBIT generic map (Nb_c, Nb_c - shift_input_c) port map(
  MULTIPLIER_IN_A        => delay_myfir_b7,
  MULTIPLIER_IN_B        => pipe_delay_7,
  MULTIPLIER_OUT_PRODUCT => mult_out_7
  );

  mult_8: MULTIPLIER_NBIT generic map (Nb_c, Nb_c - shift_input_c) port map(
  MULTIPLIER_IN_A        => delay_myfir_b8,
  MULTIPLIER_IN_B        => pipe_delay_8,
  MULTIPLIER_OUT_PRODUCT => mult_out_8
  );

  mult_9: MULTIPLIER_NBIT generic map (Nb_c, Nb_c - shift_input_c) port map(
  MULTIPLIER_IN_A        => delay_myfir_b9,
  MULTIPLIER_IN_B        => pipe_delay_9,
  MULTIPLIER_OUT_PRODUCT => mult_out_9
  );

  mult_10: MULTIPLIER_NBIT generic map (Nb_c, Nb_c - shift_input_c) port map(
  MULTIPLIER_IN_A        => delay_myfir_b10,
  MULTIPLIER_IN_B        => pipe_delay_10,
  MULTIPLIER_OUT_PRODUCT => mult_out_10
  );


  -------------------  ADDER STAGE  -------------

  -- the parallelism of the adder depends on the input shift and the mult out shift
  -- from a normal signed multiplication we obtain a result on 2*Nb_c-2 bit, then
  -- the total amount of shift is 10, where "shift_input_c" shifts are applied to the data input signal
  -- and "10 - shift_input_c" shifts are applied to the output of the multiplier
  -- considering that there are 10 serial sum, some overflow consideration are applied
  -- and we add 1 bit

  adder_1: ADDER_NBIT generic map (2*Nb_c - shift_input_c - 2 - shift_output_mul_c + 1 ) port map(
  ADDER_IN_A    => mult_out_0( 2*Nb_c - shift_input_c - 2 downto shift_output_mul_c - 1 ),
  ADDER_IN_B    => mult_out_1( 2*Nb_c - shift_input_c - 2 downto shift_output_mul_c - 1 ),
  ADDER_OUT_SUM => adder_out_1
  );

  adder_2: ADDER_NBIT generic map (2*Nb_c - shift_input_c - 2 - shift_output_mul_c + 1 ) port map(
  ADDER_IN_A    => mult_out_2( 2*Nb_c - shift_input_c - 2 downto shift_output_mul_c - 1 ),
  ADDER_IN_B    => adder_out_1,
  ADDER_OUT_SUM => adder_out_2
  );

  adder_3: ADDER_NBIT generic map (2*Nb_c - shift_input_c - 2 - shift_output_mul_c + 1 ) port map(
  ADDER_IN_A    => mult_out_3( 2*Nb_c - shift_input_c - 2 downto shift_output_mul_c - 1 ),
  ADDER_IN_B    => adder_out_2,
  ADDER_OUT_SUM => adder_out_3
  );

  adder_4: ADDER_NBIT generic map (2*Nb_c - shift_input_c - 2 - shift_output_mul_c + 1 ) port map(
  ADDER_IN_A    => mult_out_4( 2*Nb_c - shift_input_c - 2 downto shift_output_mul_c - 1 ),
  ADDER_IN_B    => adder_out_3,
  ADDER_OUT_SUM => adder_out_4
  );

  adder_5: ADDER_NBIT generic map (2*Nb_c - shift_input_c - 2 - shift_output_mul_c + 1 ) port map(
  ADDER_IN_A    => mult_out_5( 2*Nb_c - shift_input_c - 2 downto shift_output_mul_c - 1 ),
  ADDER_IN_B    => adder_out_4,
  ADDER_OUT_SUM => adder_out_5
  );

  adder_6: ADDER_NBIT generic map (2*Nb_c - shift_input_c - 2 - shift_output_mul_c + 1 ) port map(
  ADDER_IN_A    => mult_out_6( 2*Nb_c - shift_input_c - 2 downto shift_output_mul_c - 1 ),
  ADDER_IN_B    => adder_out_5,
  ADDER_OUT_SUM => adder_out_6
  );

  adder_7: ADDER_NBIT generic map (2*Nb_c - shift_input_c - 2 - shift_output_mul_c + 1 ) port map(
  ADDER_IN_A    => mult_out_7( 2*Nb_c - shift_input_c - 2 downto shift_output_mul_c - 1 ),
  ADDER_IN_B    => adder_out_6,
  ADDER_OUT_SUM => adder_out_7
  );

  adder_8: ADDER_NBIT generic map (2*Nb_c - shift_input_c - 2 - shift_output_mul_c + 1 ) port map(
  ADDER_IN_A    => mult_out_8( 2*Nb_c - shift_input_c - 2 downto shift_output_mul_c - 1 ),
  ADDER_IN_B    => adder_out_7,
  ADDER_OUT_SUM => adder_out_8
  );

  adder_9: ADDER_NBIT generic map (2*Nb_c - shift_input_c - 2 - shift_output_mul_c + 1 ) port map(
  ADDER_IN_A    => mult_out_9( 2*Nb_c - shift_input_c - 2 downto shift_output_mul_c - 1 ),
  ADDER_IN_B    => adder_out_8,
  ADDER_OUT_SUM => adder_out_9
  );

  adder_10: ADDER_NBIT generic map (2*Nb_c - shift_input_c - 2 - shift_output_mul_c + 1 ) port map(
  ADDER_IN_A    => mult_out_10( 2*Nb_c - shift_input_c - 2 downto shift_output_mul_c - 1 ),
  ADDER_IN_B    => adder_out_9,
  ADDER_OUT_SUM => adder_out_10
  );

  -- saturation unit, for the worst case we can obtain a final sum that is bigger than the maximum
  -- represanteble value on 7 bits(signed). Saturate at the max or at the min value and the add
  -- 2 zeros on the right to bring the output on 9 bits

  Saturatin_shift_unit: process(adder_out_10)
  begin
    if (adder_out_10(7) = '1') then
      if (to_integer(signed(adder_out_10)) < -64)  then
        final_resut <= std_logic_vector(to_signed(-64, 7));
      end if;
    else
      if (to_integer(signed(adder_out_10)) > 63)  then
        final_resut <= std_logic_vector(to_signed(63, 7));
      end if;
    end if;
  end process;

  --the AND permits to bring in output directly a '0' when VIN = '0' and the data will be not valid
  shifted_final_result <= final_resut & '0' & '0';
  final_vout <= delay_myfir_data_in(Nb_c) and final_delay_myfir_vin;

  reg_out_data: REGISTER_NBIT generic map(Nb_c ) port map(
  REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
  REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
  REGISTER_NBIT_IN_EN     => final_vout,
  REGISTER_NBIT_IN_D      => final_resut,
  REGISTER_NBIT_OUT_Q     => MYFIR_OUT_DOUT
  );

  flip_flop_vout: process (MYFIR_IN_CLK, MYFIR_IN_RST_n)
  begin
    if (MYFIR_IN_RST_n = '0') then
      MYFIR_OUT_VOUT <= '0';
    elsif (MYFIR_IN_CLK'event and MYFIR_IN_CLK = '1') then
      MYFIR_OUT_VOUT <= final_vout;
    end if;
  end process;



end architecture;
