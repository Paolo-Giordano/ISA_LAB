---------------------------------------------
-- DESCRIPTION: forwarding unit to bypassing
-- perform short and long bypass
--------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwarding_unit is
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
end entity;

architecture behavioural of forwarding_unit is

begin

  p_forwardin: process( FORW_IN_SRC1, FORW_IN_SRC2, FORW_IN_RD_EX_MEM, FORW_IN_RD_MEM_WB, FORW_IN_REGWRITE_EX_MEM, FORW_IN_REGWRITE_MEM_WB) is
    begin
      --default value, select from register file
      FORW_OUT_CTRL_MUX1 <= "00";
      FORW_OUT_CTRL_MUX2 <= "00";

	--long bypass
      if ( (FORW_IN_SRC1 = FORW_IN_RD_MEM_WB) and (FORW_IN_REGWRITE_MEM_WB = '1') and not (FORW_IN_RD_MEM_WB = "00000")) then
          FORW_OUT_CTRL_MUX1 <= "10";
        end if;

      if ((FORW_IN_SRC2 = FORW_IN_RD_MEM_WB) and (FORW_IN_REGWRITE_MEM_WB = '1') and not (FORW_IN_RD_MEM_WB = "00000") ) then
          FORW_OUT_CTRL_MUX2 <= "10";
        end if;

	--short bypass
      if ( (FORW_IN_SRC1 = FORW_IN_RD_EX_MEM) and (FORW_IN_REGWRITE_EX_MEM = '1') and not (FORW_IN_RD_EX_MEM = "00000") ) then
          FORW_OUT_CTRL_MUX1 <= "01";
        end if;

      if ( (FORW_IN_SRC2 = FORW_IN_RD_EX_MEM) and (FORW_IN_REGWRITE_EX_MEM = '1') and not (FORW_IN_RD_EX_MEM = "00000")) then
          FORW_OUT_CTRL_MUX2 <= "01";
      end if;

    end process;

end architecture;
