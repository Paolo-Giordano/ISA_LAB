----------------------------------------------------------------
--Description: unit that selects a partial product considering
--3 bits of B
----------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity RecodingLogic is
generic (N:integer:=8);
port(
    BITS_IN : IN std_logic_vector(2 downto 0);
    A_IN    : IN std_logic_vector(N downto 0);
    A2_IN   : IN std_logic_vector(N downto 0);
    NEGA_IN : IN std_logic_vector(N downto 0);
    NEGA2_IN: IN std_logic_vector(N downto 0);
    S_OUT   : OUT std_logic;
    PP_OUT  : OUT std_logic_vector(N downto 0)
);
end entity;

architecture structural of RecodingLogic is

    component mux8to1 is
    generic(N: integer:=4);
    port(
        D0_IN   : IN std_logic_vector (N-1 downto 0);
        D1_IN   : IN std_logic_vector (N-1 downto 0);
        D2_IN   : IN std_logic_vector (N-1 downto 0);
        D3_IN   : IN std_logic_vector (N-1 downto 0);
        D4_IN   : IN std_logic_vector (N-1 downto 0);
        D5_IN   : IN std_logic_vector (N-1 downto 0);
        D6_IN   : IN std_logic_vector (N-1 downto 0);
        D7_IN   : IN std_logic_vector (N-1 downto 0);
        SEL_IN  : IN std_logic_vector (2 downto 0);
        D_OUT   : OUT std_logic_vector(N-1 downto 0)
    );
    end component;

    signal SEL_MUX: std_logic_vector (2 downto 0);

begin

    --multiplexer to select the partial product
    i_mux: mux8to1 generic map (N => N+1) port map(
        D0_IN   => (others => '0'),  --zero
        D1_IN   => A_IN,             --A
        D2_IN   => A2_IN,            --2*A
        D3_IN   => NEGA_IN,          --not(A)
        D4_IN   => NEGA2_IN,         --not(2*A)
        D5_IN   => (others => '0'),  --not used
        D6_IN   => (others => '0'),  --not used
        D7_IN   => (others => '0'),  --not used
        SEL_IN  => SEL_MUX,
        D_OUT   => PP_OUT
    );

    --Modified Booth Encoding table
    SEL_MUX <= "000" when (BITS_IN="000" or BITS_IN="111") else
               "001" when (BITS_IN="001" or BITS_IN="010") else
               "010" when BITS_IN="011"  else
               "100" when BITS_IN="100"  else
               "011";
    --evaluation of the sign bit of the partial product
    S_OUT   <= '0' when (BITS_IN="000" or BITS_IN="111" or BITS_IN="001" or BITS_IN="010" or BITS_IN="011") else '1';
end architecture;
