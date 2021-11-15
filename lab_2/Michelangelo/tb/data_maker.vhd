library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_maker is
  port (
    CLK  : in  std_logic;
    --END_SIM : out std_logic;
    DATA : out std_logic_vector(31 downto 0));
end data_maker;

architecture beh of data_maker is

  --constant latency_c : integer := 4;
  --signal sEndSim : std_logic;
  --signal END_SIM_i : std_logic_vector(0 to latency_c-1) := (others => '0');

begin  -- beh


  process (CLK)
    file fp : text open read_mode is "./fp_samples.hex";
    variable ptr : line;
    variable val : std_logic_vector(31 downto 0);
  begin  -- process
    if CLK'event and CLK = '1' then  -- rising clock edge
      if (not(endfile(fp))) then
        readline(fp, ptr);
        hread(ptr, val);
      --  sEndSim <= '0';
      --else
      --  sEndSim <= '1';
      end if;
      DATA <= val;
    end if;
  end process;

  --process (CLK)
  --begin  -- process
  --  if CLK'event and CLK = '1' then  -- rising clock edge
  --    END_SIM_i(0) <= sEndSim;
  --    END_SIM_i(1 to latency_c-1) <= END_SIM_i(0 to latency_c-2);
  --  end if;
  --end process;

  --END_SIM <= END_SIM_i(latency_c-1);

end beh;
