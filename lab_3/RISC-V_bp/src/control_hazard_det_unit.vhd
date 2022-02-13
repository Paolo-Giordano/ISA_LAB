---------------------------------------------
-- DESCRIPTION: unit able to detect a branch
-- and flush the inserted instruction
--------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_hazard_det_unit is
  port (
  --input
  CHDU_CLK       : in std_logic;
  CHDU_IN_JUMP   : in std_logic;
  --output
  CHDU_OUT_FLUSH : out std_logic  --control multiplexer selector
  );
end entity;

architecture behavioural of control_hazard_det_unit is

  --delayed version of CHDU_IN_JUMP used for flushing 3 subsequential instructions
  signal flush_d1,flush_d2 : std_logic;

begin

  --shift register of two bit
  REG_p: process(CHDU_CLK) is
    begin
      if (CHDU_CLK'event and CHDU_CLK = '1') then
        flush_d1 <= CHDU_IN_JUMP;
        flush_d2 <= flush_d1;
      end if;
    end process;

  --flush the pipe for 3 subsequent clock cycles (put controls to 0)
  CHDU_OUT_FLUSH <= CHDU_IN_JUMP or flush_d1 or flush_d2;


end architecture;
