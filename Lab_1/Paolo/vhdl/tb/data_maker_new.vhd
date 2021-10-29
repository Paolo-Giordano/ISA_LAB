library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_maker is
  generic (N_g : integer := 9);
  port (
    CLK     : in  std_logic;
    RST_n   : in  std_logic;
    VOUT    : out std_logic;
    DOUT    : out std_logic_vector(N_g-1 downto 0);
    H0      : out std_logic_vector(N_g-1 downto 0);
    H1      : out std_logic_vector(N_g-1 downto 0);
    H2      : out std_logic_vector(N_g-1 downto 0);
    H3      : out std_logic_vector(N_g-1 downto 0);
    H4      : out std_logic_vector(N_g-1 downto 0);
    H5      : out std_logic_vector(N_g-1 downto 0);
    H6      : out std_logic_vector(N_g-1 downto 0);
    H7      : out std_logic_vector(N_g-1 downto 0);
    H8      : out std_logic_vector(N_g-1 downto 0);
    H9      : out std_logic_vector(N_g-1 downto 0);
    H10     : out std_logic_vector(N_g-1 downto 0);
    END_SIM : out std_logic);
end data_maker;

architecture beh of data_maker is

  constant tco : time := 1 ns;

  signal sEndSim : std_logic;
  signal END_SIM_i : std_logic_vector(0 to 10);

begin  -- beh

  H0  <= std_logic_vector(to_signed(-1, N_g));
  H1  <= std_logic_vector(to_signed(-4, N_g));
  H2  <= std_logic_vector(to_signed(-7, N_g));
  H3  <= std_logic_vector(to_signed(16, N_g));
  H4  <= std_logic_vector(to_signed(70, N_g));
  H5  <= std_logic_vector(to_signed(101, N_g));
  H6  <= std_logic_vector(to_signed(70, N_g));
  H7  <= std_logic_vector(to_signed(16, N_g));
  H8  <= std_logic_vector(to_signed(-7, N_g));
  H9  <= std_logic_vector(to_signed(-4, N_g));
  H10 <= std_logic_vector(to_signed(-1, N_g));


  process (CLK, RST_n)
    file fp_in : text open READ_MODE is "../../matlab/samples.txt";
    variable line_in : line;
    variable x : integer;
    variable vin : std_logic;
    variable space : character;
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      DOUT <= (others => '0') after tco;
      VOUT <= '0' after tco;
      sEndSim <= '0' after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      if not endfile(fp_in) then
        readline(fp_in, line_in);
        read(line_in, x);
        read(line_in, space);
        read(line_in, vin);
        DOUT <= std_logic_vector(to_signed(x, N_g)) after tco;
        VOUT <= vin after tco;
        sEndSim <= '0' after tco;
      else
        VOUT <= vin after tco;
        sEndSim <= '1' after tco;
      end if;
    end if;
  end process;

  process (CLK, RST_n)
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      END_SIM_i <= (others => '0') after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      END_SIM_i(0) <= sEndSim after tco;
      END_SIM_i(1 to 10) <= END_SIM_i(0 to 9) after tco;
    end if;
  end process;

  END_SIM <= END_SIM_i(10);

end beh;
