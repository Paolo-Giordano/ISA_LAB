library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_fir is
end entity;

architecture tb of tb_fir is

  component FPmul IS
     PORT(
        FP_A : IN     std_logic_vector (31 DOWNTO 0);
        FP_B : IN     std_logic_vector (31 DOWNTO 0);
        clk  : IN     std_logic;
        FP_Z : OUT    std_logic_vector (31 DOWNTO 0)
     );
  end component;

  component clk_gen is
    port (
      END_SIM : in  std_logic;
      CLK     : out std_logic;
      DATA_EN : out std_logic;
      RST_n   : out std_logic);
  end component;

  component data_maker is
    port (
      CLK     : in  std_logic;
      RST_n   : in std_logic;
      DATA_EN : in std_logic;
      DATA_IN : out std_logic_vector(31 downto 0);
      END_SIM : out std_logic);
  end component;

  component data_sink is
    port (
      CLK     : in std_logic;
      RST_n   : in std_logic;
      DATA_EN : in std_logic;
      DIN     : in std_logic_vector(31 downto 0));
  end component;

  signal CLK_i,RST_n_i, DATA_EN_i, END_SIM_i : std_logic;
  signal DATA_IN_i, DATA_Z_i : std_logic_vector(31 downto 0);

begin

  i_CG_id: clk_gen port map(END_SIM_i,CLK_i,DATA_EN_i,RST_n_i);

  i_SM_id: data_maker port map(CLK_i,RST_n_i,DATA_EN_i,DATA_IN_i,END_SIM_i);

  i_UUT_id: FPmul port map(DATA_IN_i, DATA_IN_i,CLK_i,DATA_Z_i);

  i_DS_id: data_sink port map(CLK_i,RST_n_i,DATA_EN_i,DATA_Z_i);

end architecture;
