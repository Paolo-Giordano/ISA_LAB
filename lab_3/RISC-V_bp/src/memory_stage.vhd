---------------------------------------------
--Description: memory stage, the memory in not
--inserted in the design but added in the TB
---------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_stage is
  port (
      MEM_STAGE_IN_ZERO_F      : in std_logic;                        --zero flag from execution stage
      MEM_STAGE_IN_BRANCH      : in std_logic;                        --control branch from EU
      MEM_STAGE_IN_JAL         : in std_logic;                        --jump for jal from EU
      MEM_STAGE_IN_MEMWRITE    : in std_logic;                        --control write mem from EU
      MEM_STAGE_IN_MEMREAD     : in std_logic;                        --control read mem from EU
      MEM_STAGE_IN_REGWRITE    : in std_logic;                        --control write RF from EU
      MEM_STAGE_IN_MEMTOREG    : in std_logic;                        --control to decide what to write back in the register file
      MEM_STAGE_IN_ALU_RES     : in std_logic_vector(31 downto 0);    --result of the alu from the exec stage
      MEM_STAGE_IN_WR_DATA     : in std_logic_vector(31 downto 0);    --data to write in memory from execution stage
      MEM_STAGE_IN_RD_DATA     : in std_logic_vector(31 downto 0);    --data read from data memory
      MEM_STAGE_IN_PC_BRANCH   : in std_logic_vector(31 downto 0);    --address to jump for fetch stage
      MEM_STAGE_IN_RD          : in std_logic_vector(4 downto 0);     --destination register for the write back
      MEM_STAGE_IN_BRANCHPRED  : in std_logic;                        --signal with the branch prediction of the PBtable
      MEM_STAGE_OUT_BRANCH     : out std_logic;                       --control to decide if jump or not, for fetch stage
      MEM_STAGE_OUT_MEMWRITE   : out std_logic;                       --control write for data memory
      MEM_STAGE_OUT_MEMREAD    : out std_logic;                       --control read for data memory
      MEM_STAGE_OUT_REGWRITE   : out std_logic;                       --control write for RF
      MEM_STAGE_OUT_MEMTOREG   : out std_logic;                       --control to decide what to write back in the register file
      MEM_STAGE_OUT_ALU_RES    : out std_logic_vector(31 downto 0);   --result of the alu from the exec stage
      MEM_STAGE_OUT_WR_DATA    : out std_logic_vector(31 downto 0);   --data that has to written in the data memory
      MEM_STAGE_OUT_RD_DATA    : out std_logic_vector(31 downto 0);    --data read from the data memory
      MEM_STAGE_OUT_PC_WRBRANCH: out std_logic_vector(31 downto 0);   --address to jump in case of wrong branch prediction
      MEM_STAGE_OUT_RD         : out std_logic_vector(4 downto 0);    --destination register for the write back
      MEM_STAGE_OUT_WRONGPRED  : out std_logic                        --signal to understand if the branch prediction was wrong
  );
end entity;


architecture structural of memory_stage is
  signal branch: std_logic;
begin
   branch                  <= (MEM_STAGE_IN_ZERO_F and MEM_STAGE_IN_BRANCH) or MEM_STAGE_IN_JAL;
   MEM_STAGE_OUT_BRANCH    <= branch;
   MEM_STAGE_OUT_WRONGPRED <= branch xor MEM_STAGE_IN_BRANCHPRED;

   MEM_STAGE_OUT_MEMWRITE    <= MEM_STAGE_IN_MEMWRITE;
   MEM_STAGE_OUT_MEMREAD     <= MEM_STAGE_IN_MEMREAD;
   MEM_STAGE_OUT_REGWRITE    <= MEM_STAGE_IN_REGWRITE;
   MEM_STAGE_OUT_MEMTOREG    <= MEM_STAGE_IN_MEMTOREG;
   MEM_STAGE_OUT_ALU_RES     <= MEM_STAGE_IN_ALU_RES;
   MEM_STAGE_OUT_WR_DATA     <= MEM_STAGE_IN_WR_DATA;
   MEM_STAGE_OUT_RD_DATA     <= MEM_STAGE_IN_RD_DATA;
   MEM_STAGE_OUT_PC_WRBRANCH <= MEM_STAGE_IN_PC_BRANCH;
   MEM_STAGE_OUT_RD          <= MEM_STAGE_IN_RD;

end architecture;
