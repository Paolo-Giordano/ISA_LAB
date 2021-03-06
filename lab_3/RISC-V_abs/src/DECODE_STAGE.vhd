---------------------------------------------
--Description: decode stage
---------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DECODE_STAGE is
  port(
      --fetch stage input
      -----------------------------------------------------------------------------------------
      DEC_STAGE_IN_INSTR : in std_logic_vector(31 downto 0); --instruction fecthed from IM
      DEC_STAGE_IN_PC    : in std_logic_vector(31 downto 0); --program counter

      --cu output
      -----------------------------------------------------------------------------------------
      DEC_STAGE_OUT_JAL        : out std_logic;                     --signal to jump for jar operation
      DEC_STAGE_OUT_BRANCH     : out std_logic;                     --signal to dected if a branch is fetched
      DEC_STAGE_OUT_MEMREAD    : out std_logic;                     --control signal for the data memory
      DEC_STAGE_OUT_MEMWRITE   : out std_logic;                     --control signal for the data memory
      DEC_STAGE_OUT_MEMTOREG   : out std_logic;                     --control signal for the write back stage
      DEC_STAGE_OUT_REGWRITE   : out std_logic;                     --signal to write in the register file generated by CU
      DEC_STAGE_OUT_ALUSRC1    : out std_logic;                     --selection signal mux at the input of the ALU
      DEC_STAGE_OUT_ALUSRC2    : out std_logic_vector(1 downto 0);  --selection signal mux at the input of the ALU
      DEC_STAGE_OUT_ALURES     : out std_logic;                     --selection signal mux at the output of the ALU
      DEC_STAGE_OUT_ALUOP      : out std_logic_vector(1 downto 0);  --output CU for the ALUControl

      --RF signals
      -----------------------------------------------------------------------------------------
      --RF_Clk
      DEC_STAGE_IN_CLK       : in std_logic;                      -- clock of the register file
      --write
      DEC_STAGE_IN_REGWRITE  : in std_logic;                      --signal to write in the register file from WB stage
      DEC_STAGE_IN_WRITEADD  : in std_logic_vector(4 downto 0);   --write address
      DEC_STAGE_IN_WRITEDATA : in std_logic_vector(31 downto 0);  --write data
      --read
      DEC_STAGE_OUT_READDATA1 : out std_logic_vector(31 downto 0); --first output register file
      DEC_STAGE_OUT_READDATA2 : out std_logic_vector(31 downto 0); --second output register file

      --IMM_GEN
      ------------------------------------------------------------------------------------------
      DEC_STAGE_OUT_IMM : out std_logic_vector(31 downto 0);  --output immediate generation unit

      --hazard detection useful signals
      DEC_STAGE_IN_MEMREAD_ID_EX : in std_logic;
      DEC_STAGE_IN_RD_ID_EX      : in std_logic_vector(4 downto 0);
      DEC_OUT_PC_EN              : out std_logic;
      DEC_OUT_IF_ID_LOAD         : out std_logic;

      --others
      -------------------------------------------------------------------------------------------
      DEC_STAGE_OUT_FUNC4 : out std_logic_vector(3 downto 0); --field used for alu control
      DEC_STAGE_OUT_RS1   : out std_logic_vector(4 downto 0); --source1 register field
      DEC_STAGE_OUT_RS2   : out std_logic_vector(4 downto 0); --source2 register field
      DEC_STAGE_OUT_RD    : out std_logic_vector(4 downto 0); --destination register field
      DEC_STAGE_OUT_PC    : out std_logic_vector(31 downto 0) --program counter



  );
end entity;

architecture rtl of DECODE_STAGE is

  component data_hazard_det_unit is
    port (
    --input
    DHDU_IN_SRC1_IF_ID    : in std_logic_vector(4 downto 0);
    DHDU_IN_SRC2_IF_ID    : in std_logic_vector(4 downto 0);
    DHDU_IN_RD_ID_EX      : in std_logic_vector(4 downto 0);
    DHDU_IN_MEMREAD_ID_EX : in std_logic;
    --output
    DHDU_OUT_STALL        : out std_logic;
    DHDU_OUT_PC_EN        : out std_logic;
    DHDU_OUT_IF_ID_LOAD   : out std_logic
    );
  end component;

  component MUX2TO1 is
      generic(N_g: integer:= 4);
      port(
          MUX_IN_D0  : IN std_logic_vector (N_g-1 downto 0);
          MUX_IN_D1   : IN std_logic_vector (N_g-1 downto 0);
          MUX_IN_SEL  : IN std_logic;
          MUX_OUT     : OUT std_logic_vector (N_g-1 downto 0)
      );
  end component;


  component RF is
    generic (
          ADDR_WIDTH_g  : integer := 5;
          DATA_WIDTH_g  : integer := 32);
    port(
        --RF_Clk
        RF_Clk       : in std_logic;
        --write
        RF_RegWrite  : in std_logic;
        RF_WriteAdd  : in std_logic_vector(ADDR_WIDTH_g-1 downto 0);
        RF_WriteData : in std_logic_vector(DATA_WIDTH_g-1 downto 0);
        --read (reading always)
        RF_ReadAdd1  : in std_logic_vector(ADDR_WIDTH_g-1 downto 0);
        RF_ReadAdd2  : in std_logic_vector(ADDR_WIDTH_g-1 downto 0);

        RF_ReadData1 : out std_logic_vector(DATA_WIDTH_g-1 downto 0);
        RF_ReadData2 : out std_logic_vector(DATA_WIDTH_g-1 downto 0)
      );
    end component;

    component IMM_GEN is
      port (
            --in
            IG_Instr     : in std_logic_vector(31 downto 0);
            --controls
            IG_Imm       : out std_logic_vector(31 downto 0)
            );
    end component;

    component CU is
      port (
            --in
            CU_Opcode     : in std_logic_vector(6 downto 0);
            --controls
            CU_jal        : out std_logic;
            CU_Branch     : out std_logic;
            CU_MemRead    : out std_logic;
            CU_MemWrite   : out std_logic;
            CU_MemToReg   : out std_logic;
            CU_RegWrite   : out std_logic;
            CU_AluSrc1    : out std_logic;
            CU_AluSrc2    : out std_logic_vector(1 downto 0);
            CU_ExecuteOut : out std_logic;
            CU_AluOp      : out std_logic_vector(1 downto 0)
            );
    end component;

    --instruction fields
    signal readAdd1_i, readAdd2_i : std_logic_vector(4 downto 0);
    signal opcode_i : std_logic_vector(6 downto 0);

    --controls multiplexing
    signal CU_controls,ctrl_mux_out,zero_controls  : std_logic_vector(11 downto 0);
    signal ctrl_mux_sel : std_logic;


begin

  --register file
  readAdd1_i <= DEC_STAGE_IN_INSTR(19 downto 15);
  readAdd2_i <= DEC_STAGE_IN_INSTR(24 downto 20);
  i_RF_id: RF
    generic map (5,32)
    port map(
        --RF_Clk
        RF_Clk       => DEC_STAGE_IN_Clk,
        --write5
        RF_RegWrite  => DEC_STAGE_IN_REGWRITE,
        RF_WriteAdd  => DEC_STAGE_IN_WRITEADD,
        RF_WriteData => DEC_STAGE_IN_WRITEDATA,
        --read (reading always)
        RF_ReadAdd1  => readAdd1_i,
        RF_ReadAdd2  => readAdd2_i,

        RF_ReadData1 => DEC_STAGE_OUT_READDATA1,
        RF_ReadData2 => DEC_STAGE_OUT_READDATA2
      );

    --immediate generation unit
    i_IMM_GEN_id: IMM_GEN
      port  map (
            --in
            IG_Instr => DEC_STAGE_IN_INSTR,
            --controls
            IG_Imm   => DEC_STAGE_OUT_IMM
            );

    --data hazard detection unit
    i_DHDU_id: data_hazard_det_unit
      port map(
            --input
            DHDU_IN_SRC1_IF_ID    => DEC_STAGE_IN_INSTR(19 downto 15),
            DHDU_IN_SRC2_IF_ID    => DEC_STAGE_IN_INSTR(24 downto 20),
            DHDU_IN_RD_ID_EX      => DEC_STAGE_IN_RD_ID_EX,
            DHDU_IN_MEMREAD_ID_EX => DEC_STAGE_IN_MEMREAD_ID_EX,
            --output
            DHDU_OUT_STALL        => ctrl_mux_sel,
            DHDU_OUT_PC_EN        => DEC_OUT_PC_EN,
            DHDU_OUT_IF_ID_LOAD   => DEC_OUT_IF_ID_LOAD
      );

      
      zero_controls <= (others => '0');
      i_CTRL_MUX_id: MUX2TO1
          generic map(12)
          port map(
              MUX_IN_D0  => CU_controls,
              MUX_IN_D1  => zero_controls,
              MUX_IN_SEL => ctrl_mux_sel,
              MUX_OUT    => ctrl_mux_out
          );

      DEC_STAGE_OUT_JAL      <= ctrl_mux_out(11);
      DEC_STAGE_OUT_BRANCH   <= ctrl_mux_out(10);
      DEC_STAGE_OUT_MEMREAD  <= ctrl_mux_out(9);
      DEC_STAGE_OUT_MEMWRITE <= ctrl_mux_out(8);
      DEC_STAGE_OUT_MEMTOREG <= ctrl_mux_out(7);
      DEC_STAGE_OUT_REGWRITE <= ctrl_mux_out(6);
      DEC_STAGE_OUT_ALUSRC1  <= ctrl_mux_out(5);
      DEC_STAGE_OUT_ALUSRC2  <= ctrl_mux_out(4 downto 3);
      DEC_STAGE_OUT_ALURES   <= ctrl_mux_out(2);
      DEC_STAGE_OUT_ALUOP    <= ctrl_mux_out(1 downto 0);


    --control unit
    opcode_i <= DEC_STAGE_IN_INSTR(6 downto 0);
    i_CU_id: CU
      port map (
            --in
            CU_Opcode     => opcode_i,
            --controls
            CU_jal        => CU_controls(11),
            CU_Branch     => CU_controls(10),
            CU_MemRead    => CU_controls(9),
            CU_MemWrite   => CU_controls(8),
            CU_MemToReg   => CU_controls(7),
            CU_RegWrite   => CU_controls(6),
            CU_AluSrc1    => CU_controls(5),
            CU_AluSrc2    => CU_controls(4 downto 3),
            CU_ExecuteOut => CU_controls(2),
            CU_AluOp      => CU_controls(1 downto 0)
            );

      --instruction fiels decomposition
      DEC_STAGE_OUT_RS1   <= DEC_STAGE_IN_INSTR(19 downto 15);
      DEC_STAGE_OUT_RS2   <= DEC_STAGE_IN_INSTR(24 downto 20);
      DEC_STAGE_OUT_RD    <= DEC_STAGE_IN_INSTR(11 downto 7);
      DEC_STAGE_OUT_FUNC4 <= DEC_STAGE_IN_INSTR(30) & DEC_STAGE_IN_INSTR(14 downto 12);

      --PC assignement from input to output
      DEC_STAGE_OUT_PC <= DEC_STAGE_IN_PC;

end architecture;
