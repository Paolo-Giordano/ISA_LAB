---------------------------------------------
-- DESCRIPTION: unit able to detect load-use
-- hazard and stall the pipe
--------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_hazard_det_unit is
  port (
  --input
  DHDU_IN_SRC1_IF_ID    : in std_logic_vector(4 downto 0);    --operand 1 address
  DHDU_IN_SRC2_IF_ID    : in std_logic_vector(4 downto 0);    --operand 2 address
  DHDU_IN_RD_ID_EX      : in std_logic_vector(4 downto 0);    --load destination reg
  DHDU_IN_MEMREAD_ID_EX : in std_logic;
  --output
  DHDU_OUT_STALL        : out std_logic;                      --control mux selector
  DHDU_OUT_PC_EN        : out std_logic;                      --program counter enable
  DHDU_OUT_IF_ID_LOAD   : out std_logic                       --IF/ID pipe enable
  );
end entity;

architecture behavioural of data_hazard_det_unit is

begin

  --combinational process for output evaluation
  process(DHDU_IN_SRC1_IF_ID,DHDU_IN_SRC2_IF_ID,DHDU_IN_RD_ID_EX,DHDU_IN_MEMREAD_ID_EX) is
    begin
      if ((DHDU_IN_MEMREAD_ID_EX = '1') and ((DHDU_IN_RD_ID_EX = DHDU_IN_SRC1_IF_ID) or (DHDU_IN_RD_ID_EX = DHDU_IN_SRC2_IF_ID))) then
        DHDU_OUT_STALL      <= '1'; --controls = '0'
        DHDU_OUT_PC_EN      <= '0'; --prevent update of pc
        DHDU_OUT_IF_ID_LOAD <= '0'; --prevent update of if/id pipe register
      else
        DHDU_OUT_STALL      <= '0';
        DHDU_OUT_PC_EN      <= '1';
        DHDU_OUT_IF_ID_LOAD <= '1';
      end if;
    end process;

end architecture;
