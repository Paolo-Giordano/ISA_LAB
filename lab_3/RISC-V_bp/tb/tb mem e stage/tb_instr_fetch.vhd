library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_instr_fetch is
end entity;

architecture behavioural of tb_instr_fetch is

component instr_fetch is
  port (
  INSTR_FETCH_IN_PC_BRANCH : in std_logic_vector(31 downto 0);
  INSTR_FETCH_IN_PCSRC     : in std_logic;
  INSTR_FETCH_IN_RST_N     : in std_logic;
  INSTR_FETCH_IN_CLK       : in std_logic;
  INSTR_FETCH_IN_INSTR     : in std_logic_vector(31 downto 0);
  INSTR_FETCH_OUT_INSTR    : out std_logic_vector(31 downto 0);
  INSTR_FETCH_OUT_ADDR     : out std_logic_vector(31 downto 0)
  );
end component;

component INSTR_MEM is
  generic (R_g : integer := 30;   --number of line in the memory
           C_g : integer := 32);  --parallelism of the word
  port (
  IM_IN_ADDR  : in std_logic_vector(C_g-1 downto 0);
  IM_OUT_DATA : out std_logic_vector(C_g-1 downto 0)
  );
end component;

  constant R_c : integer := 30;
  constant C_c : integer := 32;

  signal addr, instr, instr_out : std_logic_vector(31 downto 0);
  signal rst_n, clk : std_logic;

begin

  process
  begin
    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
  end process;

  rst_n <= '0', '1'after 10 ns;

  MEM: INSTR_MEM generic map(R_c, C_c) port map(
    IM_IN_ADDR   => addr,
    IM_OUT_DATA  => instr
  );

  FETCH_STAGE: instr_fetch port map(
  INSTR_FETCH_IN_PC_BRANCH => std_logic_vector(to_unsigned(4,32)),
  INSTR_FETCH_IN_PCSRC     => '0',
  INSTR_FETCH_IN_RST_N     => rst_n,
  INSTR_FETCH_IN_CLK       => clk,
  INSTR_FETCH_OUT_ADDR     => addr,
  INSTR_FETCH_IN_INSTR     => instr,
  INSTR_FETCH_OUT_INSTR    => instr_out
  );
end architecture;
