---------------------------------------------
--Description: execution stage
---------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity EXECUTION_STAGE is
    port (
        EXEC_STAGE_IN_IMM_GEN         : in std_logic_vector(31 downto 0); --output immediate generation unit
        EXEC_STAGE_IN_PC              : in std_logic_vector(31 downto 0); --program counter
        EXEC_STAGE_IN_DATA1           : in std_logic_vector(31 downto 0); --first output register file
        EXEC_STAGE_IN_DATA2           : in std_logic_vector(31 downto 0); --second output register file
        EXEC_STAGE_IN_SHORT_BYPASS    : in std_logic_vector(31 downto 0); --prior ALU result (1 delay)
        EXEC_STAGE_IN_LONG_BYPASS     : in std_logic_vector(31 downto 0); --earlier ALU result (2 delay) or data memory value (1 delay)
        EXEC_STAGE_IN_ALUOP           : in std_logic_vector(1 downto 0);  --output CU for the ALUControl
        EXEC_STAGE_IN_FUNC4           : in std_logic_vector(3 downto 0);  --field used BY alu control
        EXEC_STAGE_IN_ALUSRC1         : in std_logic;                     -- selection signal mux at the input of the ALU
        EXEC_STAGE_IN_ALUSRC2         : in std_logic_vector(1 downto 0);  -- selection signal mux at the input of the ALU
        EXEC_STAGE_IN_ALURES          : in std_logic;                     -- selection signal mux at the output of the ALU
        EXEC_STAGE_IN_MEMREAD         : in std_logic;                     --control signal for the data memory
        EXEC_STAGE_IN_MEMWRITE        : in std_logic;                     --control signal for the data memory
        EXEC_STAGE_IN_MEMTOREG        : in std_logic;                     --control signal for the data memory
        EXEC_STAGE_IN_BRANCH          : in std_logic;                     --signal to dected if a BEQ is fetched
        EXEC_STAGE_IN_JAL             : in std_logic;                     --signal to jump for JAL op
        EXEC_STAGE_IN_REGWRITE        : in std_logic;                     --signal to write in the register file
        EXEC_STAGE_IN_REGWRITE_EX_MEM : in std_logic;                     --signal to write in the register file from ex_mem stage
        EXEC_STAGE_IN_REGWRITE_MEM_WB : in std_logic;                     --signal to write in the register file from mem_wb stage
        EXEC_STAGE_IN_SR1             : in std_logic_vector(4 downto 0);  --address of the source1 register
        EXEC_STAGE_IN_SR2             : in std_logic_vector(4 downto 0);  --address of the source2 register
        EXEC_STAGE_IN_RD              : in std_logic_vector(4 downto 0);  --address of the destination register
        EXEC_STAGE_IN_RD_EX_MEM       : in std_logic_vector(4 downto 0);  --address of the destination register from ex_mem stage
        EXEC_STAGE_IN_RD_MEM_WB       : in std_logic_vector(4 downto 0);  --address of the destination register from mem_wb stage
        EXEC_STAGE_OUT_ALU            : out std_logic_vector(31 downto 0);-- ALU output
        EXEC_STAGE_OUT_PC_BRANCH      : out std_logic_vector(31 downto 0);--PC evaluated in case of branch
        EXEC_STAGE_OUT_ZERO_FLAG      : out std_logic;                    --zero flag of the ALU
        EXEC_STAGE_OUT_SRC2           : out std_logic_vector(31 downto 0);--second output register file
        EXEC_STAGE_OUT_RD             : out std_logic_vector(4 downto 0); --address of the destination register
        EXEC_STAGE_OUT_MEMREAD        : out std_logic;                    --control signal for the data memory
        EXEC_STAGE_OUT_MEMWRITE       : out std_logic;                    --control signal for the data memory
        EXEC_STAGE_OUT_MEMTOREG       : out std_logic;                    --control signal for the data memory
        EXEC_STAGE_OUT_BRANCH         : out std_logic;                    --signal to dected if a BEQ is fetched
        EXEC_STAGE_OUT_JAL            : out std_logic;                    --signal to jump for JAL op
        EXEC_STAGE_OUT_REGWRITE       : out std_logic;                     --signal to write in the register file
        EXEC_STAGE_OUT_PC             : out std_logic_vector(31 downto 0); --program counter
        --control hazard detection unit
        EXEC_STAGE_IN_CLK             : in std_logic;                     --used by CHDU flip-flops
        EXEC_STAGE_IN_FLUSH           : in std_logic;                     --signal to flush the pipe
        EXEC_STAGE_IN_BRANCHPRED      : in std_logic;                     --signal to know if a jump is predicted or not
        EXEC_STAGE_OUT_BRANCHPRED     : out std_logic                     --signal to know if a jump is predicted or not
    );
end entity;

architecture structural of EXECUTION_STAGE is

    component ALUcontrol is
        port (
            ALU_CONTROL_IN_ALUOP      : in std_logic_vector(1 downto 0);
            ALU_CONTROL_IN_FUNC4      : in std_logic_vector(3 downto 0);
            ALU_CONTROL_OUT           : out std_logic_vector(3 downto 0)
        );
    end component;
    signal from_ALUcontrol_to_ALU: std_logic_vector(3 downto 0);

    component ALU is
        port (
            ALU_IN_A            : in std_logic_vector(31 downto 0);
            ALU_IN_B            : in std_logic_vector(31 downto 0);
            ALU_IN_CONTROL      : in std_logic_vector(3 downto 0);
            ALU_OUT             : out std_logic_vector(31 downto 0);
            ALU_OUT_ZERO_FLAG   : out std_logic
        );
    end component;
    signal alu_src1, alu_src2, alu_output    : std_logic_vector(31 downto 0);

    component control_hazard_det_unit is
      port (
      --input
      CHDU_CLK       : in std_logic;
      CHDU_IN_JUMP   : in std_logic;
      --output
      CHDU_OUT_FLUSH : out std_logic
      );
    end component;

    signal ctrl_mux_sel    : std_logic;
    signal ctrl_from_ID_EX : std_logic_vector(6 downto 0);
    signal ctrl_mux_out    : std_logic_vector(6 downto 0);

    component forwarding_unit is
      port (
      FORW_IN_SRC1            : in std_logic_vector(4 downto 0);
      FORW_IN_SRC2            : in std_logic_vector(4 downto 0);
      FORW_IN_RD_EX_MEM       : in std_logic_vector(4 downto 0);
      FORW_IN_RD_MEM_WB       : in std_logic_vector(4 downto 0);
      FORW_IN_REGWRITE_EX_MEM : in std_logic;
      FORW_IN_REGWRITE_MEM_WB : in std_logic;
      FORW_OUT_CTRL_MUX1      : out std_logic_vector(1 downto 0);
      FORW_OUT_CTRL_MUX2      : out std_logic_vector(1 downto 0)
      );
    end component;
    signal selA_from_forwarding, selB_from_forwarding         : std_logic_vector(1 downto 0);

    component MUX2TO1 is
        generic(N_g: integer:=4);
        port(
            MUX_IN_D0   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_D1   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_SEL  : IN std_logic;
            MUX_OUT     : OUT std_logic_vector (N_g-1 downto 0)
        );
    end component;
    component MUX4TO1 is
        generic(N_g: integer:=4);
        port(
            MUX_IN_D0   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_D1   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_D2   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_D3   : IN std_logic_vector (N_g-1 downto 0);
            MUX_IN_SEL  : IN std_logic_vector (1 downto 0);
            MUX_OUT     : OUT std_logic_vector (N_g-1 downto 0)
        );
    end component;

    signal from_forwardA_to_aluSrc1, from_forwardB_to_aluSrc2 : std_logic_vector(31 downto 0);
    signal const_value_4                                      : std_logic_vector(31 downto 0);

    component ADDER is
        generic (N_g:integer:=8);
        port (
            ADDER_IN_A      : in std_logic_vector(N_g-1 downto 0);
            ADDER_IN_B      : in std_logic_vector(N_g-1 downto 0);
            ADDER_OUT_SUM   : out std_logic_vector(N_g-1 downto 0)
        );
    end component;
    signal immediate_value_x2, from_mux_to_pc_adder : std_logic_vector(31 downto 0);

    begin

        i_ALU_control : ALUcontrol
            port map(
                ALU_CONTROL_IN_ALUOP      =>EXEC_STAGE_IN_ALUOP,
                ALU_CONTROL_IN_FUNC4      =>EXEC_STAGE_IN_FUNC4,
                ALU_CONTROL_OUT           =>from_ALUcontrol_to_ALU
            );

        i_forwarding_unit: forwarding_unit port map(
        FORW_IN_SRC1            => EXEC_STAGE_IN_SR1,
        FORW_IN_SRC2            => EXEC_STAGE_IN_SR2,
        FORW_IN_RD_EX_MEM       => EXEC_STAGE_IN_RD_EX_MEM ,
        FORW_IN_RD_MEM_WB       => EXEC_STAGE_IN_RD_MEM_WB,
        FORW_IN_REGWRITE_EX_MEM => EXEC_STAGE_IN_REGWRITE_EX_MEM,
        FORW_IN_REGWRITE_MEM_WB => EXEC_STAGE_IN_REGWRITE_MEM_WB,
        FORW_OUT_CTRL_MUX1      => selA_from_forwarding,
        FORW_OUT_CTRL_MUX2      => selB_from_forwarding
        );
        --multiplexer A to select from register file or
        --from bypass (ALU output, write back output)
        i_mux_forwarding_A: MUX4TO1
            generic map(N_g=>32)
            port map(
                MUX_IN_D0   =>EXEC_STAGE_IN_DATA1,
                MUX_IN_D1   =>EXEC_STAGE_IN_SHORT_BYPASS,
                MUX_IN_D2   =>EXEC_STAGE_IN_LONG_BYPASS,
                MUX_IN_D3   =>(others=>'0'), --not used
                MUX_IN_SEL  =>selA_from_forwarding,
                MUX_OUT     =>from_forwardA_to_aluSrc1
            );
        --multiplexer B to select from register file or
        --from bypass (ALU output, write back output)
        i_mux_forwarding_B: MUX4TO1
            generic map(N_g=>32)
            port map(
                MUX_IN_D0   =>EXEC_STAGE_IN_DATA2,
                MUX_IN_D1   =>EXEC_STAGE_IN_SHORT_BYPASS,
                MUX_IN_D2   =>EXEC_STAGE_IN_LONG_BYPASS,
                MUX_IN_D3   =>(others=>'0'), --not used
                MUX_IN_SEL  =>selB_from_forwarding,
                MUX_OUT     =>from_forwardB_to_aluSrc2
            );

        --control hazard detection unit + multiplexer
        i_CHDU_id: control_hazard_det_unit
          port map (
          --input
          CHDU_CLK        => EXEC_STAGE_IN_CLK,
          CHDU_IN_JUMP    => EXEC_STAGE_IN_FLUSH   ,
          --output
          CHDU_OUT_FLUSH  => ctrl_mux_sel
          );

        ctrl_from_ID_EX <= EXEC_STAGE_IN_BRANCHPRED & EXEC_STAGE_IN_MEMREAD & EXEC_STAGE_IN_MEMWRITE & EXEC_STAGE_IN_MEMTOREG & EXEC_STAGE_IN_BRANCH & EXEC_STAGE_IN_JAL & EXEC_STAGE_IN_REGWRITE;
        i_CTRL_MUX_id: MUX2TO1
            generic map(N_g => 7)
            port map(
                MUX_IN_D0   =>ctrl_from_ID_EX,
                MUX_IN_D1   =>(others => '0'),
                MUX_IN_SEL  =>ctrl_mux_sel,
                MUX_OUT     =>ctrl_mux_out
            );




        --multiplexer to select the first input of the ALU
        --it can be the program counter or a value read from the register file
        i_ALU_src1: MUX2TO1
            generic map(N_g => 32)
            port map(
                MUX_IN_D0   =>from_forwardA_to_aluSrc1,
                MUX_IN_D1   =>EXEC_STAGE_IN_PC,
                MUX_IN_SEL  =>EXEC_STAGE_IN_ALUSRC1,
                MUX_OUT     =>alu_src1
            );

        const_value_4 <= std_logic_vector(to_signed(4,32));
        --multiplexer to select the second input of the ALU
        --it can be a value from the register file (0), the output of the immediate
        --generation unit (1) or the constant value +4 (2)
        i_ALU_src2: MUX4TO1
            generic map(N_g=>32)
            port map(
                MUX_IN_D0   =>from_forwardB_to_aluSrc2,
                MUX_IN_D1   =>EXEC_STAGE_IN_IMM_GEN,
                MUX_IN_D2   =>const_value_4,
                MUX_IN_D3   =>(others=>'0'), --not used
                MUX_IN_SEL  =>EXEC_STAGE_IN_ALUSRC2,
                MUX_OUT     =>alu_src2
            );
        i_ALU: ALU
            port map(
                ALU_IN_A          =>alu_src1,
                ALU_IN_B          =>alu_src2,
                ALU_IN_CONTROL    =>from_ALUcontrol_to_ALU,
                ALU_OUT           =>alu_output,
                ALU_OUT_ZERO_FLAG =>EXEC_STAGE_OUT_ZERO_FLAG
            );

        --multiplexer to select the output of the execution stage
        --it can be the result of the alu or the the output of the
        --immediate generation unit
        i_mux_ALU_res: MUX2TO1
            generic map(N_g => 32)
            port map(
                MUX_IN_D0   => alu_output,
                MUX_IN_D1   => EXEC_STAGE_IN_IMM_GEN,
                MUX_IN_SEL  => EXEC_STAGE_IN_ALURES,
                MUX_OUT     => EXEC_STAGE_OUT_ALU
            );

        --mux to evaluate then the value of PC in case of wrong branch prediction
        --if i had not to take the branch the next PC has to be PC+4, if i had to jump
        --the next value of the pc has to be PC+IMM*2
        i_mux_pc_adder:MUX2TO1
            generic map(N_g=> 32)
            port map(
                MUX_IN_D0   => immediate_value_x2,
                MUX_IN_D1   => std_logic_vector(to_unsigned(4,32)),
                MUX_IN_SEL  => EXEC_STAGE_IN_BRANCHPRED,
                MUX_OUT     => from_mux_to_pc_adder
            );

        --PC evaluation in case of branch
        immediate_value_x2 <= EXEC_STAGE_IN_IMM_GEN(30 downto 0) & "0";
        i_PC_adder: ADDER
            generic map(N_g=> 32)
            port map(
                ADDER_IN_A      =>EXEC_STAGE_IN_PC,
                ADDER_IN_B      =>from_mux_to_pc_adder,
                ADDER_OUT_SUM   =>EXEC_STAGE_OUT_PC_BRANCH
            );
        --direct connections input-output
        EXEC_STAGE_OUT_SRC2     <= EXEC_STAGE_IN_DATA2;
        EXEC_STAGE_OUT_BRANCHPRED<= ctrl_mux_out(6);
        EXEC_STAGE_OUT_MEMREAD  <= ctrl_mux_out(5);
        EXEC_STAGE_OUT_MEMWRITE <= ctrl_mux_out(4);
        EXEC_STAGE_OUT_MEMTOREG <= ctrl_mux_out(3);
        EXEC_STAGE_OUT_BRANCH   <= ctrl_mux_out(2) ;
        EXEC_STAGE_OUT_JAL      <= ctrl_mux_out(1);
        EXEC_STAGE_OUT_RD       <= EXEC_STAGE_IN_RD;
        EXEC_STAGE_OUT_REGWRITE <= ctrl_mux_out(0);

end architecture;
