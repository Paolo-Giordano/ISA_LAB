library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_maker is
  port (
    CLK     : in  std_logic;
    RST_n   : in std_logic;
    DATA_EN : in std_logic;
    DATA_IN : out std_logic_vector(31 downto 0);
    END_SIM : out std_logic);
end data_maker;

architecture beh of data_maker is
  constant tco : time := 1 ns;

begin  -- beh

  process (CLK, RST_n)
    file fp : text open read_mode is "./fp_samples.hex";
    variable ptr : line;
    variable val : std_logic_vector(31 downto 0);
  begin  -- process
  if (RST_n = '0') then
    DATA_IN <= (others => '0') after tco;
    END_SIM <= '0' after tco;
  elsif CLK'event and CLK = '1' then  -- rising clock edge
      if (not(endfile(fp))) then
          readline(fp, ptr);
          hread(ptr, val);
          DATA_IN <= val after tco;
          END_SIM <= '0' after tco;
      else
        END_SIM <= '1' after 51 ns;   --we wait 5 or 6 pipe stage to keep writing the final value on output file
      end if;
    end if;
  end process;

end beh;
