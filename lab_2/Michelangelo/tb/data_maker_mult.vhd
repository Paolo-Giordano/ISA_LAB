library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_maker_mult is
  port (
    CLK  : in  std_logic;
    DATA_A : out std_logic_vector(31 downto 0);
	DATA_B : out std_logic_vector(31 downto 0));
end data_maker_mult;

architecture beh of data_maker_mult is


begin  -- beh


  process (CLK)
    file fp : text open read_mode is "./input_vectors.txt";
    variable ptr : line;
    variable val_A : std_logic_vector(31 downto 0);
	variable val_B : std_logic_vector(31 downto 0);
	variable space : character;

  begin  -- process
    if CLK'event and CLK = '1' then  -- rising clock edge
      if (not(endfile(fp))) then
        readline(fp, ptr);
        read(ptr, val_A);
		read(ptr, space);
		read(ptr, val_B);
      end if;
      DATA_A <= val_A;
	  DATA_B <= val_B;
    end if;
  end process;


end beh;
