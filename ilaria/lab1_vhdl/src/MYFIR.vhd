-------------------------------------------------
--Description: MYFIR filter with Inputs and ouput
--on 9 bits
-------------------------------------------------
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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
    component ADDER_NBIT is
        generic (N_g:integer:=8);
        port (
            ADDER_IN_A      : in std_logic_vector(N_g-1 downto 0);
            ADDER_IN_B      : in std_logic_vector(N_g-1 downto 0);
            ADDER_OUT_SUM   : out std_logic_vector(N_g-1 downto 0)
        );
    end component;

    component MULTIPLIER_NBIT is
        generic (N_g:integer:=8);
        port (
            MULTIPLIER_IN_A         : in std_logic_vector(N_g-1 downto 0);
            MULTIPLIER_IN_B         : in std_logic_vector(N_g-1 downto 0);
            MULTIPLIER_OUT_PRODUCT  : out std_logic_vector(2*N_g-2 downto 0)
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


    --the postfix d means signal delayed by the input register
    --evaluated stands for output qauntity at the input of an output register
    signal in_DIN_d, evaluated_DOUT     : std_logic_vector (8 downto 0);
    signal in_VIN_d, evaluated_VOUT     : std_logic;
    
    --filter coefficients are inserted in an array to manage easily them in generate loop
    type array_coeff is array (10 downto 0) of std_logic_vector (8 downto 0);
    signal b_coeff, b_coeff_d           : array_coeff;

    --array to connect the the registers of the delay line
    type array_delay_line is array (10 downto 0) of std_logic_vector (9 downto 0);
    signal delay_line                   : array_delay_line;

    --array with the outputs of the multipliers
    type array_products is array (10 downto 0) of std_logic_vector (16 downto 0);
    signal product                      : array_products;
    --array with the outputs of the adders plus at the index 0 one input of the first adder
    --to manage it easily inside generate loops
    type array_sums is array (10 downto 0) of std_logic_vector (7 downto 0);
    signal sum                          : array_sums;
    --array for the inputs of te adders that come from the multipliers, properly shifted and extended
    type array_addend_a is array (9 downto 0) of std_logic_vector (7 downto 0);
    signal from_multiplier_to_adder     : array_sums;

    --input saturation unit
    signal in_su                        : std_logic_vector(9 downto 0);

    begin

        --input register for DIN, always enabled 
        i_regIN_DIN : REGISTER_NBIT generic map(N_g=> 9) port map(
            REGISTER_IN_RST_N   => MYFIR_IN_RST_n,
            REGISTER_IN_CLK     => MYFIR_IN_CLK,
            REGISTER_IN_EN      => '1',
            REGISTER_IN_D       => MYFIR_IN_DIN,
            REGISTER_OUT_Q      => in_DIN_d
        );
        -- input FF for VIN, always enabled
        i_ffIN_VIN : FF port map(
            FF_IN_RST_N   => MYFIR_IN_RST_n,
            FF_IN_CLK     => MYFIR_IN_CLK,
            FF_IN_EN      => '1',
            FF_IN_D       => MYFIR_IN_VIN,
            FF_OUT_Q      => in_VIN_d
        );
        --input reg for the coefficients, always enabled
        g_reg_coeff: for i in 0 to 10 generate
        begin
            i_regIN_coeff: REGISTER_NBIT generic map(N_g=> 9) port map(
                REGISTER_IN_RST_N   => MYFIR_IN_RST_n,
                REGISTER_IN_CLK     => MYFIR_IN_CLK,
                REGISTER_IN_EN      => '1',
                REGISTER_IN_D       => b_coeff(i),
                REGISTER_OUT_Q      => b_coeff_d(i)
            ); 
        end generate;


        --delay line for DIN & VIN, enabled by the sampled VIN
        delay_line (0) <= in_DIN_d & in_VIN_d;
        g_delay_line: for i in 0 to 9 generate
        begin
            i_reg_DL: REGISTER_NBIT generic map(N_g=> 10) port map(
                REGISTER_IN_RST_N   => MYFIR_IN_RST_n,
                REGISTER_IN_CLK     => MYFIR_IN_CLK,
                REGISTER_IN_EN      => in_VIN_d,
                REGISTER_IN_D       => delay_line(i),
                REGISTER_OUT_Q      => delay_line(i+1)
            ); 
        end generate;

        g_multipliers: for i in 0 to 10 generate
        begin
            i_mult: MULTIPLIER_NBIT generic map (N_g=> 9) port map(
                    MULTIPLIER_IN_A         => delay_line(i)(9 downto 1),
                    MULTIPLIER_IN_B         => b_coeff_d(i),
                    MULTIPLIER_OUT_PRODUCT  => product(i)
                );
        end generate;

        --to get the input of the adders from the evaluated products only the 7 most
        --significant bits have to be considered
        sum (0) <= product(0)(16) & product(0)(16 downto 10);
        process(product)
        begin
            for i in 0 to 9 loop
                from_multiplier_to_adder(i)  <= product(i+1)(16) & product(i+1)(16 downto 10); 
            end loop;
        end process;
        g_adders: for i in 0 to 9 generate
        begin
            i_add: ADDER_NBIT generic map (N_g=> 8) port map(
                    ADDER_IN_A         => from_multiplier_to_adder(i),
                    ADDER_IN_B         => sum(i),
                    ADDER_OUT_SUM      => sum(i+1)
                );
        end generate;

        in_su <= sum(10) & "00";
        i_su: SATURATION_UNIT port map(
            SU_IN_DATA  => in_su,
            SU_OUT_DATA => evaluated_DOUT
        );

        evaluated_VOUT <= in_VIN_d and delay_line(10)(0);

        --output register for DOUT, enabled only if DOUT='1'
        i_regIN_DOUT : REGISTER_NBIT generic map(N_g=> 9) port map(
            REGISTER_IN_RST_N   => MYFIR_IN_RST_n,
            REGISTER_IN_CLK     => MYFIR_IN_CLK,
            REGISTER_IN_EN      => evaluated_VOUT,
            REGISTER_IN_D       => evaluated_DOUT,
            REGISTER_OUT_Q      => MYFIR_OUT_DOUT
        );
        -- output FF for VOUT, always enabled
        i_ffIN_VOUT : FF port map(
            FF_IN_RST_N   => MYFIR_IN_RST_n,
            FF_IN_CLK     => MYFIR_IN_CLK,
            FF_IN_EN      => '1',
            FF_IN_D       => evaluated_VOUT,
            FF_OUT_Q      => MYFIR_OUT_VOUT
        );

        b_coeff(10)<= MYFIR_IN_b10; 
        b_coeff(9) <= MYFIR_IN_b9;
        b_coeff(8) <= MYFIR_IN_b8;
        b_coeff(7) <= MYFIR_IN_b7;
        b_coeff(6) <= MYFIR_IN_b6;
        b_coeff(5) <= MYFIR_IN_b5;
        b_coeff(4) <= MYFIR_IN_b4;
        b_coeff(3) <= MYFIR_IN_b3;
        b_coeff(2) <= MYFIR_IN_b2;
        b_coeff(1) <= MYFIR_IN_b1;
        b_coeff(0) <= MYFIR_IN_b0;

end architecture;