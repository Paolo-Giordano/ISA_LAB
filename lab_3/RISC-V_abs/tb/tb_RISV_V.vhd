library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RISC_V is
end entity;

architecture behavioural of tb_RISC_V is

  component RISC_V is
      port(
          RISC_V_IN_RST_N         : in std_logic;
          RISC_V_IN_CLK           : in std_logic;
          RISC_V_IN_INSTR         : in std_logic_vector(31 downto 0);        --instruction raed from the code memory
          RISC_V_IN_RD_DATA       : in std_logic_vector(31 downto 0);        --data read from data memory
          RISC_V_OUT_PC           : out std_logic_vector(31 downto 0);       --program counter
          RISC_V_OUT_WR_DATA      : out std_logic_vector(31 downto 0);       --data written in the data memory
          RISC_V_OUT_WR_ADD       : out std_logic_vector(31 downto 0);       --address for the write in the data memory
          RISC_V_OUT_MEMWRITE     : out std_logic;                           --control signal of the data memory
          RISC_V_OUT_MEMREAD      : out std_logic                            --control signal of the data memory
      );
  end component;

  component DATA_MEM is
    generic (R_g : integer := 8;    --number of line in the memory
             C_g : integer := 32);  --parallelism of the word
    port (
    DM_IN_ADDR     : in std_logic_vector(C_g-1 downto 0);
    DM_IN_W_DATA   : in std_logic_vector(C_g-1 downto 0);
    DM_IN_MEMWRITE : in std_logic;
    DM_IN_MEMREAD  : in std_logic;
    DM_OUT_R_DATA  : out std_logic_vector(C_g-1 downto 0)
    );
  end component;

  component INSTR_MEM is
    generic (R_g : integer := 36;   --number of line in the memory
             C_g : integer := 32);  --parallelism of the word
    port (
    IM_IN_ADDR  : in std_logic_vector(C_g-1 downto 0);
    IM_OUT_DATA : out std_logic_vector(C_g-1 downto 0)
    );
  end component;

  component clk_gen is
    port (
      CLK     : out std_logic);
  end component;

  signal rst_n, clk                           : std_logic;
  signal memwrite, memread                    : std_logic;
  signal instr, rd_data, pc, wr_data, wr_addr : std_logic_vector(31 downto 0);

begin

  rst_n <= '0', '1' after 10 ns;

  i_clk : clk_gen port map(
  CLK => clk
  );

  i_data_mem : DATA_MEM generic map(8, 32) port map(
    DM_IN_ADDR     => wr_addr,
    DM_IN_W_DATA   => wr_data,
    DM_IN_MEMWRITE => memwrite,
    DM_IN_MEMREAD  => memread,
    DM_OUT_R_DATA  => rd_data
  );

  --instruction memory not smaller than 24 rows,
  --otherwise out of index error
  i_instr_mem : INSTR_MEM generic map(24, 32) port map(
    IM_IN_ADDR  => pc,
    IM_OUT_DATA => instr
  );

  i_DUT : RISC_V port map(
    RISC_V_IN_RST_N         => rst_n,
    RISC_V_IN_CLK           => clk,
    RISC_V_IN_INSTR         => instr,
    RISC_V_IN_RD_DATA       => rd_data,
    RISC_V_OUT_PC           => pc,
    RISC_V_OUT_WR_DATA      => wr_data,
    RISC_V_OUT_WR_ADD       => wr_addr,
    RISC_V_OUT_MEMWRITE     => memwrite,
    RISC_V_OUT_MEMREAD      => memread
  );

end architecture;
