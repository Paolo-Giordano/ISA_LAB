---------------------------------------------
--Description: instruction fetch stage
---------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_fetch is
  port (
  INSTR_FETCH_IN_PC_WRBRANCH : in std_logic_vector(31 downto 0);     --address to take in case of wrong branch
  INSTR_FETCH_IN_BRANCH      : in std_logic;                          --signal to detect if a jump has to be performed
  INSTR_FETCH_IN_RST_N       : in std_logic;                          --reset for PC
  INSTR_FETCH_IN_CLK         : in std_logic;                          --clock for PC
  INSTR_FETCH_IN_PC_EN       : in std_logic;                          --pc register enable
  INSTR_FETCH_IN_WRONGPRED   : in std_logic;                          --signal to understand if the branch prediction was wrong
  INSTR_FETCH_IN_WADD_PBTAB  : in std_logic_vector(31 downto 0);       --write address of the PB table
  INSTR_FETCH_IN_INSTR       : in std_logic_vector(31 downto 0);      --instruction from memory
  INSTR_FETCH_OUT_INSTR      : out std_logic_vector(31 downto 0);     --instruction for decode stage
  INSTR_FETCH_OUT_ADDR       : out std_logic_vector(31 downto 0);     --address for memory
  INSTR_FETCH_OUT_BRANCHPRED : out std_logic                         --branch prediction bit read from the BPtable
  );
end entity;

architecture structural of instr_fetch is

  component MUX2TO1 is
      generic(N_g: integer:=4);
      port(
          MUX_IN_D0   : IN std_logic_vector (N_g-1 downto 0);
          MUX_IN_D1   : IN std_logic_vector (N_g-1 downto 0);
          MUX_IN_SEL  : IN std_logic;
          MUX_OUT     : OUT std_logic_vector (N_g-1 downto 0)
      );
  end component;
  signal sel_mux_jumpornot : std_logic;

  component REGISTER_PC is
      generic (N_g:integer:=8);
      port (
          REGISTER_IN_RST_N  : in std_logic;
          REGISTER_IN_CLK    : in std_logic;
          REGISTER_IN_EN     : in std_logic;
          REGISTER_IN_D      : in std_logic_vector(N_g-1 downto 0);
          REGISTER_OUT_Q     : out std_logic_vector(N_g-1 downto 0)
      );
  end component;

  component ADDER is
      generic (N_g:integer:=8);
      port (
          ADDER_IN_A      : in std_logic_vector(N_g-1 downto 0);
          ADDER_IN_B      : in std_logic_vector(N_g-1 downto 0);
          ADDER_OUT_SUM   : out std_logic_vector(N_g-1 downto 0)
      );
  end component;

  signal from_mux_to_pc, from_muxjumpornot_to_muxpc, address_from_pc, from_add_to_mux : std_logic_vector(31 downto 0);

  component branch_prediction_table is
    generic (
          DATA_WIDTH_g  : integer := 33);
    port(
        --BPT_Clk
        BPT_Clk : in std_logic;
        BPT_Rst_n    : in std_logic;
        --write port
        BPT_EnWrite : in std_logic;
        BPT_WriteAdd : in std_logic_vector(31 downto 0);
        BPT_WriteData: in std_logic_vector(DATA_WIDTH_g-1 downto 0);
        --read port(reading always)
        BPT_ReadAdd  : in std_logic_vector(31 downto 0);
        BPT_ReadData : out std_logic_vector(DATA_WIDTH_g-1 downto 0)
      );
  end component;
  signal data_write_BPtable, data_read_BPtable : std_logic_vector(32 downto 0);

  --signal equal to '1' if a beq or jal instruction is read from the instruction memory
  signal beq_or_jal_inst: std_logic;

begin

  --mux to select PC+4 or the output of the BPtable
  i_mux_jump_or_not: MUX2TO1 generic map(32) port map(
    MUX_IN_D0   => from_add_to_mux,
    MUX_IN_D1   => data_read_BPtable(31 downto 0),
    MUX_IN_SEL  => sel_mux_jumpornot,
    MUX_OUT     => from_muxjumpornot_to_muxpc
  );
  sel_mux_jumpornot <= data_read_BPtable(32) and beq_or_jal_inst;
  --signal equal to '1' if a beq or jal instruction is read from the instruction memory
  beq_or_jal_inst <= '1' when (INSTR_FETCH_IN_INSTR(6 downto 0) ="1101111" or INSTR_FETCH_IN_INSTR(6 downto 0)="1100011") else '0';

  --mux to select between normal operation(0) and recovery because of a wrong branch prediction(1)
  i_mux_recovery_or_not: MUX2TO1 generic map(32) port map(
    MUX_IN_D0   => from_muxjumpornot_to_muxpc,
    MUX_IN_D1   => INSTR_FETCH_IN_PC_WRBRANCH,
    MUX_IN_SEL  => INSTR_FETCH_IN_WRONGPRED,
    MUX_OUT     => from_mux_to_pc
  );

  --Program counter
  i_PC: REGISTER_PC generic map(32) port map (
  REGISTER_IN_RST_N  => INSTR_FETCH_IN_RST_N,
  REGISTER_IN_CLK    => INSTR_FETCH_IN_CLK,
  REGISTER_IN_EN     => INSTR_FETCH_IN_PC_EN,
  REGISTER_IN_D      => from_mux_to_pc,
  REGISTER_OUT_Q     => address_from_pc
  );

  --perform PC+4
  i_ADD: ADDER generic map(32) port map (
    ADDER_IN_A      => address_from_pc,
    ADDER_IN_B      => std_logic_vector (to_unsigned(4, 32)),
    ADDER_OUT_SUM   => from_add_to_mux
  );

  data_write_BPtable <= INSTR_FETCH_IN_BRANCH & INSTR_FETCH_IN_PC_WRBRANCH;
  i_BPtable:branch_prediction_table
    generic map( DATA_WIDTH_g  =>33)
    port map(
        BPT_Clk       => INSTR_FETCH_IN_CLK,
        BPT_Rst_n     => INSTR_FETCH_IN_RST_N,
        BPT_EnWrite   => INSTR_FETCH_IN_WRONGPRED,
        BPT_WriteAdd  => INSTR_FETCH_IN_WADD_PBTAB,
        BPT_WriteData => data_write_BPtable,
        BPT_ReadAdd   => address_from_pc,
        BPT_ReadData  => data_read_BPtable
      );
  INSTR_FETCH_OUT_BRANCHPRED <= sel_mux_jumpornot;

  INSTR_FETCH_OUT_ADDR  <= address_from_pc;
  INSTR_FETCH_OUT_INSTR <= INSTR_FETCH_IN_INSTR;
end architecture;
