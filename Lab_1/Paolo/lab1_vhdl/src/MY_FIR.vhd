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

  constant shift_input_c      : integer := 0;
  constant shift_output_mul_c : integer := 10 - shift_input_c;

  --input coefficient delayed
  type matrix_coeff is array (10 downto 0) of std_logic_vector(8 downto 0);

  signal coefficients, delayed_coefficients : matrix_coeff;
  -- delayed input, and shifted version
  signal delay_myfir_data_in   : std_logic_vector(8 downto 0);
  signal shifted_data_in       : std_logic_vector(8 - shift_input_c  downto 0);
  -- vin signal
  signal delayed_myfir_vin     : std_logic;
  signal final_delay_myfir_vin : std_logic;
  -- PIPE delay signals
  type matrix_pipe is array (9 downto 0) of std_logic_vector(8 - shift_input_c downto 0);
  signal pipe_delay : matrix_pipe;
  -- mult INPUT
  type matrix_mult is array (10 downto 0) of std_logic_vector(16 - shift_input_c downto 0);
  signal mult_output : matrix_mult;
  -- adder INPUT
  type matrix_adder is array (10 downto 0) of std_logic_vector(7 downto 0);
  signal from_mult_to_adder : matrix_adder;
  type matrix_adder_out is array (9 downto 0) of std_logic_vector(7 downto 0);
  signal adder_output : matrix_adder_out;
  --
  signal final_result           : std_logic_vector(6 downto 0);
  signal shifted_final_result   : std_logic_vector(8 downto 0);
  signal final_vout             : std_logic;
  begin
    --------   LOAD ALL THE COEFFICIENT BY REGISTER ------------
    coefficients(0)  <= MYFIR_IN_b0;
    coefficients(1)  <= MYFIR_IN_b1;
    coefficients(2)  <= MYFIR_IN_b2;
    coefficients(3)  <= MYFIR_IN_b3;
    coefficients(4)  <= MYFIR_IN_b4;
    coefficients(5)  <= MYFIR_IN_b5;
    coefficients(6)  <= MYFIR_IN_b6;
    coefficients(7)  <= MYFIR_IN_b7;
    coefficients(8)  <= MYFIR_IN_b8;
    coefficients(9)  <= MYFIR_IN_b9;
    coefficients(10) <= MYFIR_IN_b10;

    g_delayed_coeff: for i in 0 to 10 generate
    i_register: REGISTER_NBIT generic map(9) port map(
    REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
    REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
    REGISTER_NBIT_IN_EN     => '1',
    REGISTER_NBIT_IN_D      => coefficients(i),
    REGISTER_NBIT_OUT_Q     => delayed_coefficients(i)
    );
  end generate;

    --------------    LOAD INPUT DATA AND VIN   -----------------

    p_flip_flop_vin: process (MYFIR_IN_CLK, MYFIR_IN_RST_n)
    begin
      if (MYFIR_IN_RST_n = '0') then
        delayed_myfir_vin <= '0';
      elsif (MYFIR_IN_CLK'event and MYFIR_IN_CLK = '1') then
        delayed_myfir_vin <= MYFIR_IN_VIN;
      end if;
    end process;

    i_reg_in_data: REGISTER_NBIT generic map(9) port map(
    REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
    REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
    REGISTER_NBIT_IN_EN     => '1',
    REGISTER_NBIT_IN_D      => MYFIR_IN_DIN,
    REGISTER_NBIT_OUT_Q     => delay_myfir_data_in
    );

    -- shift the input signal = don't take the LSB's
    shifted_data_in <= delay_myfir_data_in(8 downto shift_input_c);

    ---------------   SHIFT REGISTER TO DELAY VIN AND BRING TO VOUT   -------------
    -- 10 is the depth of shifter, because thereare 10 stages
    i_delay_vin: SHIFT_REG_1bit generic map (10) port map(
    SHIFT_REG_IN_CLK    => MYFIR_IN_CLK,
    SHIFT_REG_IN_RST_N  => MYFIR_IN_RST_n,
    SHIFT_REG_IN        => delayed_myfir_vin,
    SHIFT_REG_OUT       => final_delay_myfir_vin
    );

    ------------       N STAGE OF PIPE    -----------------
    i_pipe_R1: REGISTER_NBIT generic map(9 - shift_input_c) port map(
    REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
    REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
    REGISTER_NBIT_IN_EN     => delayed_myfir_vin,
    REGISTER_NBIT_IN_D      => shifted_data_in,
    REGISTER_NBIT_OUT_Q     => pipe_delay(0)
    );

    g_pipe: for i in 1 to 9 generate
      i_pipe:  REGISTER_NBIT generic map(9 - shift_input_c) port map(
      REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
      REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
      REGISTER_NBIT_IN_EN     => delayed_myfir_vin,
      REGISTER_NBIT_IN_D      => pipe_delay(i-1),
      REGISTER_NBIT_OUT_Q     => pipe_delay(i)
      );
    end generate;

    ----------    multiplier stage   ---------------
    -- coefficient are on 9 bits, data input can be shifted up to 4 bits to respect the THD
    i_mult_0: MULTIPLIER_NBIT generic map (9, 9 - shift_input_c) port map(
    MULTIPLIER_IN_A        => delayed_coefficients(0),
    MULTIPLIER_IN_B        => shifted_data_in,
    MULTIPLIER_OUT_PRODUCT => mult_output(0)
    );

    g_multiplier: for i in 1 to 10 generate
      i_multiplier:MULTIPLIER_NBIT generic map (9, 9 - shift_input_c) port map(
      MULTIPLIER_IN_A        => delayed_coefficients(i),
      MULTIPLIER_IN_B        => pipe_delay(i-1),
      MULTIPLIER_OUT_PRODUCT => mult_output(i)
      );
    end generate;

    -------------------  ADDER STAGE  -------------

    -- the parallelism of the adder depends on the input shift and the mult out shift
    -- from a normal signed multiplication we obtain a result on 2*Nb_c-2 bit, then
    -- the total amount of shift is 10, where "shift_input_c" shifts are applied to the data input signal
    -- and "10 - shift_input_c" shifts are applied to the output of the multiplier
    -- considering that there are 10 serial sum, some overflow consideration are applied
    -- and we add 1 bit

    g_shifted_adder_input:for i in 0 to 11 generate
      from_mult_to_adder(i) <= mult_output(i)(16) & mult_output(i)(16 - shift_input_c downto shift_output_mul_c);
    end generate;

    i_adder_1: ADDER_NBIT generic map (8) port map(
    ADDER_IN_A    => from_mult_to_adder(0),
    ADDER_IN_B    => from_mult_to_adder(1),
    ADDER_OUT_SUM => adder_output(0)
    );

    g_adder_output: for i in 1 to 9 generate
      i_adder: ADDER_NBIT generic map (8) port map(
      ADDER_IN_A    => from_mult_to_adder(i+1),
      ADDER_IN_B    => adder_output(i-1),
      ADDER_OUT_SUM => adder_output(i)
      );
    end generate;

    -- saturation unit, for the worst case we can obtain a final sum that is bigger than the maximum
    -- represanteble value on 7 bits(signed). Saturate at the max or at the min value and the add
    -- 2 zeros on the right to bring the output on 9 bits

    Saturation_shift_unit: process(adder_output(9))
    begin
      if (adder_output(9)(7) = '1') then
        if (to_integer(signed(adder_output(9))) < -64)  then
          final_result <= std_logic_vector(to_signed(-64, 7));
  	  else
  		  final_result <= adder_output(9)(6 downto 0);
        end if;
      else
        if (to_integer(signed(adder_output(9))) > 63)  then
          final_result <= std_logic_vector(to_signed(63, 7));
  	  else
  		    final_result <= adder_output(9)(6 downto 0);
        end if;
      end if;
    end process;

    --the AND permits to bring in output directly a '0' when VIN = '0' and the data will be not valid
    shifted_final_result <= final_result & '0' & '0';
    final_vout <= delayed_myfir_vin and final_delay_myfir_vin;

    i_reg_out_data: REGISTER_NBIT generic map(9) port map(
    REGISTER_NBIT_IN_CLK    => MYFIR_IN_CLK,
    REGISTER_NBIT_IN_RST_N  => MYFIR_IN_RST_n,
    REGISTER_NBIT_IN_EN     => final_vout,
    REGISTER_NBIT_IN_D      => shifted_final_result,
    REGISTER_NBIT_OUT_Q     => MYFIR_OUT_DOUT
    );

    p_flip_flop_vout: process (MYFIR_IN_CLK, MYFIR_IN_RST_n)
    begin
      if (MYFIR_IN_RST_n = '0') then
        MYFIR_OUT_VOUT <= '0';
      elsif (MYFIR_IN_CLK'event and MYFIR_IN_CLK = '1') then
        MYFIR_OUT_VOUT <= final_vout;
      end if;
    end process;

  end architecture;
