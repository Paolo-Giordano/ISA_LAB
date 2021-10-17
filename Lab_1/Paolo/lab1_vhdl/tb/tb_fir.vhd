library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_fir is
end entity;

architecture tb of tb_fir is

  component MYFIR is
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
end component;

  component clk_gen is
  port (
    END_SIM : in  std_logic;
    CLK     : out std_logic;
    RST_n   : out std_logic);
  end component;

  component data_maker is
  generic (N_g : integer := 9);
  port (
    CLK     : in  std_logic;
    RST_n   : in  std_logic;
    VOUT    : out std_logic;
    DOUT    : out std_logic_vector(N_g-1 downto 0);
    H0      : out std_logic_vector(N_g-1 downto 0);
    H1      : out std_logic_vector(N_g-1 downto 0);
    H2      : out std_logic_vector(N_g-1 downto 0);
    H3      : out std_logic_vector(N_g-1 downto 0);
    H4      : out std_logic_vector(N_g-1 downto 0);
    H5      : out std_logic_vector(N_g-1 downto 0);
    H6      : out std_logic_vector(N_g-1 downto 0);
    H7      : out std_logic_vector(N_g-1 downto 0);
    H8      : out std_logic_vector(N_g-1 downto 0);
    H9      : out std_logic_vector(N_g-1 downto 0);
    H10     : out std_logic_vector(N_g-1 downto 0);
    END_SIM : out std_logic
    );
end component;

  component data_sink is
    port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    VIN   : in std_logic;
    DIN   : in std_logic_vector(8 downto 0));
  end component;

  signal CLK_i,RST_n_i,VIN_i,VOUT_i,END_SIM_i,DATA_EN_i : std_logic;
  signal DIN_i,DOUT_i : std_logic_vector(8 downto 0);
  signal H0_i,H1_i,H2_i,H3_i,H4_i,H5_i,H6_i,H7_i,H8_i,H9_i,H10_i : std_logic_vector(8 downto 0);


begin

  i_CG_id: clk_gen port map(END_SIM_i,CLK_i,RST_n_i);

  i_SM_id: data_maker port map(CLK_i,RST_n_i,VIN_i,DIN_i,H0_i,H1_i,H2_i,
                              H3_i,H4_i,H5_i,H6_i,H7_i,H8_i,H9_i,H10_i,END_SIM_i);

  i_UUT_id: MYFIR port map(RST_n_i,CLK_i,H0_i,H1_i,H2_i,H3_i,H4_i,H5_i,
                           H6_i,H7_i,H8_i,H9_i,H10_i,VIN_i,DIN_i,VOUT_i,DOUT_i);

  i_DS_id: data_sink port map(CLK_i,RST_n_i,VOUT_i,DOUT_i);

end architecture;
