----------------------------------------------------
--Description: ALU. It includes an ALU/subtractor,
--an arithmetic right shifter, and and xor gates

--a 4 bit control signal is used to understand the 
--operation that has to be performed
-- 0010 addition
-- 0110 subtraction
-- 0001 xor
-- 0000 and
-- 0011 right arithmetic shift
-- 1110 set lower then

-------------------------------------------------
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port (
        ALU_IN_A          : in std_logic_vector(31 downto 0);
        ALU_IN_B          : in std_logic_vector(31 downto 0);
        ALU_IN_CONTROL    : in std_logic_vector(3 downto 0);
        ALU_OUT           : out std_logic_vector(31 downto 0);
        ALU_OUT_ZERO_FLAG : out std_logic
    );
end entity;

architecture behavioral of ALU is

    component ADDER_SUBTRACTOR is
        generic (N_g:integer:=8);
        port (
            ADD_SUB_IN_A          : in std_logic_vector(N_g-1 downto 0);
            ADD_SUB_IN_B          : in std_logic_vector(N_g-1 downto 0);
            ADD_SUB_IN_SUB_ADD_n  : in std_logic;
            ADD_SUB_IN_EN         : in std_logic;
            ADD_SUB_OUT_RES       : out std_logic_vector(N_g-1 downto 0)
        );
    end component;
    signal from_add_sub_to_mux: std_logic_vector (31 downto 0);

    signal slt_output         : std_logic_vector (31 downto 0);

    component BITWISE_AND is
        generic (N_g:integer:=8);
        port (
            AND_IN_A          : in std_logic_vector(N_g-1 downto 0);
            AND_IN_B          : in std_logic_vector(N_g-1 downto 0);
            AND_IN_EN         : in std_logic;
            AND_OUT_RES       : out std_logic_vector(N_g-1 downto 0)
        );
    end component;
    signal  from_and_to_mux: std_logic_vector(31 downto 0);

    component BITWISE_XOR is
        generic (N_g:integer:=8);
        port (
            XOR_IN_A          : in std_logic_vector(N_g-1 downto 0);
            XOR_IN_B          : in std_logic_vector(N_g-1 downto 0);
            XOR_IN_EN         : in std_logic;
            XOR_OUT_RES       : out std_logic_vector(N_g-1 downto 0)
        );
    end component;
    signal  from_xor_to_mux: std_logic_vector(31 downto 0);

    component ARITH_RIGHT_SHIFTER is
        generic (N_g:integer:=5);
        port (
            SHIFTER_IN_A          : in std_logic_vector(2**N_g-1 downto 0);
            SHIFTER_IN_EN         : in std_logic;
            SHIFTER_IN_SHAMT      : in std_logic_vector(N_g-1 downto 0);
            SHIFTER_OUT           : out std_logic_vector(2**N_g-1 downto 0)
        );
    end component;
    signal from_arithshifter_to_mux: std_logic_vector(31 downto 0);

    component MUX8TO1 is
        generic(N_g: integer:=4);
        port(
            MUX_IN_D0   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_D1   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_D2   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_D3   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_D4   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_D5   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_D6   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_D7   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_SEL  : IN std_logic_vector (2 downto 0);
            MUX_OUT     : OUT std_logic_vector (N_g-1 downto 0)
        );
    end component;
        signal mux_sel        : std_logic_vector (2 downto 0);
        signal from_mux_to_out: std_logic_vector (31 downto 0);

        signal adder_en, xor_en, and_en, shifter_en : std_logic;
    
    begin

        i_add_sub : ADDER_SUBTRACTOR 
            generic map(N_g=>32)
            port map(
                ADD_SUB_IN_A          => ALU_IN_A,
                ADD_SUB_IN_B          => ALU_IN_B,
                ADD_SUB_IN_SUB_ADD_n  => ALU_IN_CONTROL (2),
                ADD_SUB_IN_EN         => adder_en,
                ADD_SUB_OUT_RES       => from_add_sub_to_mux
            );

        --for the slt instruction (set lower then) a subtraction is performed
        --and then the sign bit of the result is placed as LSB of the ALU's output
        --the most significant bits are set to 0
        slt_output(0)           <= from_add_sub_to_mux(31);
        slt_output(31 downto 1) <= (others=>'0');

        i_and: BITWISE_AND 
            generic map(N_g=>32)
            port map(
                AND_IN_A          => ALU_IN_A,
                AND_IN_B          => ALU_IN_B,
                AND_IN_EN         => and_en,
                AND_OUT_RES       => from_and_to_mux
            );

        i_xor: BITWISE_XOR 
            generic map (N_g=>32)
            port map(
                XOR_IN_A          => ALU_IN_A,
                XOR_IN_B          => ALU_IN_B,
                XOR_IN_EN         => xor_en,
                XOR_OUT_RES       => from_xor_to_mux
            );

        i_shifter: ARITH_RIGHT_SHIFTER 
            generic map(N_g=>5)
            port map(
                SHIFTER_IN_A          => ALU_IN_A,
                SHIFTER_IN_EN         => shifter_en,
                SHIFTER_IN_SHAMT      => ALU_IN_B (4 downto 0),
                SHIFTER_OUT           => from_arithshifter_to_mux
            );
        
        --multiplexer selection signal evaluation
        mux_sel <=  ALU_IN_CONTROL(3) & ALU_IN_CONTROL(1 downto 0);
        i_mux: MUX8TO1
            generic map (N_g=>32)
            port map(
                MUX_IN_D0   => from_and_to_mux, 
                MUX_IN_D1   => from_xor_to_mux,
                MUX_IN_D2   => from_add_sub_to_mux,
                MUX_IN_D3   => from_arithshifter_to_mux,
                MUX_IN_D4   => (others=> '0'), --not used
                MUX_IN_D5   => (others=> '0'), --not used
                MUX_IN_D6   => slt_output,
                MUX_IN_D7   => (others=> '0'), --not used
                MUX_IN_SEL  => mux_sel,
                MUX_OUT     => from_mux_to_out
            );

        --enable generation
        process (mux_sel)
        begin
            case mux_sel is
                when "000"=> 
                    and_en      <='1';
                    xor_en      <='0';
                    adder_en    <='0';
                    shifter_en  <='0';
                when "001"=>
                    and_en      <='0';
                    xor_en      <='1';
                    adder_en    <='0';
                    shifter_en  <='0';
                when "010"|"110"=>
                    and_en      <='0';
                    xor_en      <='0';
                    adder_en    <='1';
                    shifter_en  <='0';
                when "011"=>
                    and_en      <='0';
                    xor_en      <='0';
                    adder_en    <='0';
                    shifter_en  <='1';
                when others=>
                    and_en      <='0';
                    xor_en      <='0';
                    adder_en    <='0';
                    shifter_en  <='0';
                end case;
        end process;
    
        --zero flag evaluation
        ALU_OUT_ZERO_FLAG   <= '1' when to_integer(signed(from_mux_to_out))=0 else '0';
        ALU_OUT             <= from_mux_to_out;

end architecture;  