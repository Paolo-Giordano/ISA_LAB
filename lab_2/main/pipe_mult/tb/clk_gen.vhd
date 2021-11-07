library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clk_gen is
  port (
    END_SIM : in  std_logic;
    CLK     : out std_logic;
    DATA_EN : out std_logic;
    RST_n   : out std_logic);
end clk_gen;

architecture beh of clk_gen is

  constant Ts : time := 10 ns;

  signal CLK_i : std_logic;

begin  -- beh

  process
  begin  -- process
    if (CLK_i = 'U') then
      CLK_i <= '0';
    else
      CLK_i <= not(CLK_i);
    end if;
    wait for Ts/2;
  end process;

  CLK <= CLK_i and not(END_SIM);

  process
  begin  -- process
    RST_n <= '0';
    wait for 3*Ts/2;
    RST_n <= '1';
    wait;
  end process;
	
  --used to enable the data sink to write data in the output file,
  --Since there are pipe stage, the output is delayed and we don't want to write all the initial 0
  process
  begin  -- process
    DATA_EN <= '0';
    wait for 14*Ts/2;    --70 ns
    DATA_EN <= '1';
    wait;
  end process;

end beh;
