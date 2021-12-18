library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_sink_mult is
  generic (N : integer := 64);
  port (
    CLK   : in std_logic;
    DIN   : in std_logic_vector(N-1 downto 0));
end data_sink_mult;

architecture beh of data_sink_mult is

begin  -- beh

  process (CLK)
    file res_fp : text open WRITE_MODE is "./dut_output.txt";
    variable line_out : line;
  begin  -- process
    if CLK'event and CLK = '1' then  -- rising clock edge
      write(line_out, DIN);
      writeline(res_fp, line_out);
    end if;
  end process;

end beh;
