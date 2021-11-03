-------------------------------------------------
--Description: my FIR filter with unfoldig N=3
-------------------------------------------------
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity filter_opt is
    port (
        RST_n          : in std_logic;
        CLK            : in std_logic;
        b0             : in std_logic_vector(8 downto 0);
        b1             : in std_logic_vector(8 downto 0);
        b2             : in std_logic_vector(8 downto 0);
        b3             : in std_logic_vector(8 downto 0);
        b4             : in std_logic_vector(8 downto 0);
        b5             : in std_logic_vector(8 downto 0);
        b6             : in std_logic_vector(8 downto 0);
        b7             : in std_logic_vector(8 downto 0);
        b8             : in std_logic_vector(8 downto 0);
        b9             : in std_logic_vector(8 downto 0);
        b10            : in std_logic_vector(8 downto 0);
        VIN            : in std_logic;
        DIN1           : in std_logic_vector(8 downto 0);
        DIN2           : in std_logic_vector(8 downto 0);
        DIN3           : in std_logic_vector(8 downto 0);
        VOUT           : out std_logic;
        DOUT1          : out std_logic_vector(8 downto 0);
        DOUT2          : out std_logic_vector(8 downto 0);
        DOUT3          : out std_logic_vector(8 downto 0)
    );
end entity;

architecture structural of filter_opt is
    component ADDER_NBIT is
        generic (N_g:integer:=8);
        port (
            ADDER_IN_A      : in std_logic_vector(N_g-1 downto 0);
            ADDER_IN_B      : in std_logic_vector(N_g-1 downto 0);
            ADDER_OUT_SUM   : out std_logic_vector(N_g-1 downto 0)
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

    component REGISTER_NBIT is
        generic (N_g:integer:=8);
        port (
            REGISTER_IN_RST_N  : in std_logic;
            REGISTER_IN_CLK    : in std_logic;
            REGISTER_IN_EN     : in std_logic;
            REGISTER_IN_D      : in std_logic_vector(N_g-1 downto 0);
            REGISTER_OUT_Q     : out std_logic_vector(N_g-1 downto 0)
        );
    end component;

    component FF is
        port (
            FF_IN_RST_N  : in std_logic;
            FF_IN_CLK    : in std_logic;
            FF_IN_EN     : in std_logic;
            FF_IN_D      : in std_logic;
            FF_OUT_Q     : out std_logic
        );
    end component;

    component SATURATION_UNIT is
        port (
            SU_IN_DATA  : in std_logic_vector (9 downto 0);
            SU_OUT_DATA : out std_logic_vector (8 downto 0)
        );
    end component;

    component SHIFT_REG_1bit is
        generic (N_g : integer := 2);    --N FF in series
        port (
            SHIFT_REG_IN_CLK    : in std_logic;
            SHIFT_REG_IN_RST_N  : in std_logic;
            SHIFT_REG_IN_EN     : in std_logic;
            SHIFT_REG_IN        : in std_logic;
            SHIFT_REG_OUT       : out std_logic
        );
    end component;

    --shift the input DIN before the multiplier
    constant shift_input_c      : integer := 0; --4 

    --the postfix d means signal delayed by the input register
    --evaluated stands for output quantity at the input of an output register
    signal in_DIN1_d, evaluated_DOUT1, in_DIN2_d, evaluated_DOUT2, in_DIN3_d, evaluated_DOUT3     : std_logic_vector (8 downto 0);
    signal in_VIN_d, evaluated_VOUT                                                               : std_logic;
    signal VIN_outDL                                                                              : std_logic;
    
    --filter coefficients are inserted in an array to manage them easily in generate loop
    type array_coeff is array (10 downto 0) of std_logic_vector (8 downto 0);
    signal b_coeff, b_coeff_d           : array_coeff;

    --array to connect the the registers of the delay lines
    type array_delay_line_3reg is array (3 downto 0) of std_logic_vector (8 - shift_input_c downto 0);
    signal delay_line1, delay_line2                   : array_delay_line_3reg;
    type array_delay_line_4reg is array (4 downto 0) of std_logic_vector (8 - shift_input_c downto 0);
    signal delay_line3				                  : array_delay_line_4reg;

    --to apply unfolding hardware is tripled, the number at the end of the names indicates the first, second or third
    --instantiation of the same HW
    --array with the inputs of the multipliers
    type array_inputmult is array (10 downto 0) of std_logic_vector (8 - shift_input_c downto 0);
    signal input_mult1,input_mult2,input_mult3   : array_inputmult;
    --array with the outputs of the multipliers
    type array_products is array (10 downto 0) of std_logic_vector (16 - shift_input_c downto 0);
    signal product1,product2,product3   : array_products;
    --array with the outputs of the adders plus at the index 0 one input of the first adder
    --to manage it easily inside generate loops
    type array_sums is array (10 downto 0) of std_logic_vector (7 downto 0);
    signal sum1, sum2, sum3             : array_sums;
    --array for the inputs of te adders that come from the multipliers, properly shifted and extended
    type array_addend_a is array (9 downto 0) of std_logic_vector (7 downto 0);
    signal from_multiplier_to_adder1,from_multiplier_to_adder2,from_multiplier_to_adder3     : array_sums;

    --input saturation unit
    signal in_su1, in_su2,in_su3        : std_logic_vector(9 downto 0);

    begin

        --input registers for DIN, always enabled 
        i_regIN_DIN1 : REGISTER_NBIT generic map(N_g=> 9) port map(
            REGISTER_IN_RST_N   => RST_n,
            REGISTER_IN_CLK     => CLK,
            REGISTER_IN_EN      => '1',
            REGISTER_IN_D       => DIN1,
            REGISTER_OUT_Q      => in_DIN1_d
        );
        i_regIN_DIN2 : REGISTER_NBIT generic map(N_g=> 9) port map(
            REGISTER_IN_RST_N   => RST_n,
            REGISTER_IN_CLK     => CLK,
            REGISTER_IN_EN      => '1',
            REGISTER_IN_D       => DIN2,
            REGISTER_OUT_Q      => in_DIN2_d
        );
        i_regIN_DIN3 : REGISTER_NBIT generic map(N_g=> 9) port map(
            REGISTER_IN_RST_N   => RST_n,
            REGISTER_IN_CLK     => CLK,
            REGISTER_IN_EN      => '1',
            REGISTER_IN_D       => DIN3,
            REGISTER_OUT_Q      => in_DIN3_d
        );
        -- input FF for VIN, always enabled
        i_ffIN_VIN : FF port map(
            FF_IN_RST_N   => RST_n,
            FF_IN_CLK     => CLK,
            FF_IN_EN      => '1',
            FF_IN_D       => VIN,
            FF_OUT_Q      => in_VIN_d
        );
        --input reg for the coefficients, always enabled
        g_reg_coeff: for i in 0 to 10 generate
        begin
            i_regIN_coeff: REGISTER_NBIT generic map(N_g=> 9) port map(
                REGISTER_IN_RST_N   => RST_n,
                REGISTER_IN_CLK     => CLK,
                REGISTER_IN_EN      => '1',
                REGISTER_IN_D       => b_coeff(i),
                REGISTER_OUT_Q      => b_coeff_d(i)
            ); 
        end generate;

        --shift register for VIN
        i_shift_reg: SHIFT_REG_1bit generic map(4) port map(
            SHIFT_REG_IN_CLK    => CLK,
            SHIFT_REG_IN_RST_N  => RST_n,
            SHIFT_REG_IN_EN     => in_VIN_d,
            SHIFT_REG_IN        => in_VIN_d,
            SHIFT_REG_OUT       => VIN_outDL
        );


        --delay lines for DIN shifted, enabled by the sampled VIN
        delay_line1 (0) <= in_DIN1_d( 8 downto shift_input_c);
        delay_line2 (0) <= in_DIN2_d( 8 downto shift_input_c);
        delay_line3 (0) <= in_DIN3_d( 8 downto shift_input_c);
        g_delay_lines: for i in 0 to 2 generate
        begin
            i_reg_DL1: REGISTER_NBIT generic map(N_g=> 9 - shift_input_c) port map(
                REGISTER_IN_RST_N   => RST_n,
                REGISTER_IN_CLK     => CLK,
                REGISTER_IN_EN      => in_VIN_d,
                REGISTER_IN_D       => delay_line1(i),
                REGISTER_OUT_Q      => delay_line1(i+1)
            );
            i_reg_DL2: REGISTER_NBIT generic map(N_g=> 9 - shift_input_c) port map(
                REGISTER_IN_RST_N   => RST_n,
                REGISTER_IN_CLK     => CLK,
                REGISTER_IN_EN      => in_VIN_d,
                REGISTER_IN_D       => delay_line2(i),
                REGISTER_OUT_Q      => delay_line2(i+1)
            );
        end generate;
        g_delay_line3: for i in 0 to 3 generate
        begin
            i_reg_DL3: REGISTER_NBIT generic map(N_g=> 9 - shift_input_c) port map(
                REGISTER_IN_RST_N   => RST_n,
                REGISTER_IN_CLK     => CLK,
                REGISTER_IN_EN      => in_VIN_d,
                REGISTER_IN_D       => delay_line3(i),
                REGISTER_OUT_Q      => delay_line3(i+1)
            );
        end generate;

        --connections delay lines to multipliers
        input_mult1 (0) <= delay_line1 (0);
        input_mult1 (1) <= delay_line3 (1);
        input_mult1 (2) <= delay_line2 (1);
        input_mult1 (3) <= delay_line1 (1);
        input_mult1 (4) <= delay_line3 (2);
        input_mult1 (5) <= delay_line2 (2);
        input_mult1 (6) <= delay_line1 (2);
        input_mult1 (7) <= delay_line3 (3);
        input_mult1 (8) <= delay_line2 (3);
        input_mult1 (9) <= delay_line1 (3);
        input_mult1 (10)<= delay_line3 (4);

        input_mult2 (0) <= delay_line2 (0);
        input_mult2 (1) <= delay_line1 (0);
        input_mult2 (2) <= delay_line3 (1);
        input_mult2 (3) <= delay_line2 (1);
        input_mult2 (4) <= delay_line1 (1);
        input_mult2 (5) <= delay_line3 (2);
        input_mult2 (6) <= delay_line2 (2);
        input_mult2 (7) <= delay_line1 (2);
        input_mult2 (8) <= delay_line3 (3);
        input_mult2 (9) <= delay_line2 (3);
        input_mult2 (10)<= delay_line1 (3);

        input_mult3 (0) <= delay_line3 (0);
        input_mult3 (1) <= delay_line2 (0);
        input_mult3 (2) <= delay_line1 (0);
        input_mult3 (3) <= delay_line3 (1);
        input_mult3 (4) <= delay_line2 (1);
        input_mult3 (5) <= delay_line1 (1);
        input_mult3 (6) <= delay_line3 (2);
        input_mult3 (7) <= delay_line2 (2);
        input_mult3 (8) <= delay_line1 (2);
        input_mult3 (9) <= delay_line3 (3);
        input_mult3 (10)<= delay_line2 (3);

        g_multipliers: for i in 0 to 10 generate
        begin
            i_mult1: MULTIPLIER_NBIT generic map (9 - shift_input_c, 9) port map(
                    MULTIPLIER_IN_A         => input_mult1(i),
                    MULTIPLIER_IN_B         => b_coeff_d(i),
                    MULTIPLIER_OUT_PRODUCT  => product1(i)
                );
            i_mult2: MULTIPLIER_NBIT generic map (9 - shift_input_c, 9) port map(
                    MULTIPLIER_IN_A         => input_mult2(i),
                    MULTIPLIER_IN_B         => b_coeff_d(i),
                    MULTIPLIER_OUT_PRODUCT  => product2(i)
                );
            i_mult3: MULTIPLIER_NBIT generic map (9 - shift_input_c, 9) port map(
                    MULTIPLIER_IN_A         => input_mult3(i),
                    MULTIPLIER_IN_B         => b_coeff_d(i),
                    MULTIPLIER_OUT_PRODUCT  => product3(i)
                );
        end generate;

        --to get the input of the adders from the evaluated products only the 7 most
        --significant bits have to be considered
        sum1 (0) <= product1(0)(16 - shift_input_c) & product1(0)(16 - shift_input_c downto 10 - shift_input_c);
        sum2 (0) <= product2(0)(16 - shift_input_c) & product2(0)(16 - shift_input_c downto 10 - shift_input_c);
        sum3 (0) <= product3(0)(16 - shift_input_c) & product3(0)(16 - shift_input_c downto 10 - shift_input_c);
        process(product1)
        begin
            for i in 0 to 9 loop
                from_multiplier_to_adder1(i)  <= product1(i+1)(16 - shift_input_c) & product1(i+1)(16 - shift_input_c downto 10 - shift_input_c);
                from_multiplier_to_adder2(i)  <= product2(i+1)(16 - shift_input_c) & product2(i+1)(16 - shift_input_c downto 10 - shift_input_c);
                from_multiplier_to_adder3(i)  <= product3(i+1)(16 - shift_input_c) & product3(i+1)(16 - shift_input_c downto 10 - shift_input_c);
            end loop;
        end process;
        g_adders: for i in 0 to 9 generate
        begin
            i_add1: ADDER_NBIT generic map (N_g=> 8) port map(
                    ADDER_IN_A         => from_multiplier_to_adder1(i),
                    ADDER_IN_B         => sum1(i),
                    ADDER_OUT_SUM      => sum1(i+1)
                );
            i_add2: ADDER_NBIT generic map (N_g=> 8) port map(
                    ADDER_IN_A         => from_multiplier_to_adder2(i),
                    ADDER_IN_B         => sum2(i),
                    ADDER_OUT_SUM      => sum2(i+1)
                );
            i_add3: ADDER_NBIT generic map (N_g=> 8) port map(
                    ADDER_IN_A         => from_multiplier_to_adder3(i),
                    ADDER_IN_B         => sum3(i),
                    ADDER_OUT_SUM      => sum3(i+1)
                );
        end generate;
        
        in_su1 <= sum1(10) & "00";
        i_su1: SATURATION_UNIT port map(
            SU_IN_DATA  => in_su1,
            SU_OUT_DATA => evaluated_DOUT1
        );
        in_su2 <= sum2(10) & "00";
        i_su2: SATURATION_UNIT port map(
            SU_IN_DATA  => in_su2,
            SU_OUT_DATA => evaluated_DOUT2
        );
        in_su3 <= sum3(10) & "00";
        i_su3: SATURATION_UNIT port map(
            SU_IN_DATA  => in_su3,
            SU_OUT_DATA => evaluated_DOUT3
        );

        evaluated_VOUT <= in_VIN_d and VIN_outDL;

        --output registers for DOUT, enabled only if VOUT='1'
        i_regIN_DOUT1 : REGISTER_NBIT generic map(N_g=> 9) port map(
            REGISTER_IN_RST_N   => RST_n,
            REGISTER_IN_CLK     => CLK,
            REGISTER_IN_EN      => evaluated_VOUT,
            REGISTER_IN_D       => evaluated_DOUT1,
            REGISTER_OUT_Q      => DOUT1
        );
        i_regIN_DOUT2 : REGISTER_NBIT generic map(N_g=> 9) port map(
            REGISTER_IN_RST_N   => RST_n,
            REGISTER_IN_CLK     => CLK,
            REGISTER_IN_EN      => evaluated_VOUT,
            REGISTER_IN_D       => evaluated_DOUT2,
            REGISTER_OUT_Q      => DOUT2
        );
        i_regIN_DOUT3 : REGISTER_NBIT generic map(N_g=> 9) port map(
            REGISTER_IN_RST_N   => RST_n,
            REGISTER_IN_CLK     => CLK,
            REGISTER_IN_EN      => evaluated_VOUT,
            REGISTER_IN_D       => evaluated_DOUT3,
            REGISTER_OUT_Q      => DOUT3
        );
        -- output FF for VOUT, always enabled
        i_ffIN_VOUT : FF port map(
            FF_IN_RST_N   => RST_n,
            FF_IN_CLK     => CLK,
            FF_IN_EN      => '1',
            FF_IN_D       => evaluated_VOUT,
            FF_OUT_Q      => VOUT
        );

        b_coeff(10)<= b10; 
        b_coeff(9) <= b9;
        b_coeff(8) <= b8;
        b_coeff(7) <= b7;
        b_coeff(6) <= b6;
        b_coeff(5) <= b5;
        b_coeff(4) <= b4;
        b_coeff(3) <= b3;
        b_coeff(2) <= b2;
        b_coeff(1) <= b1;
        b_coeff(0) <= b0;

end architecture;
