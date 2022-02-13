library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_data_memory is
end entity;

architecture behavioural of tb_data_memory  is

  component DATA_MEM is
    generic (R_g : integer := 8;   --number of line in the memory
             C_g : integer := 32);  --parallelsim of the word
    port (
    DM_IN_ADDR     : in std_logic_vector(C_g-1 downto 0);
    DM_IN_W_DATA   : in std_logic_vector(C_g-1 downto 0);
    DM_IN_MEMWRITE : in std_logic;
    DM_IN_MEMREAD  : in std_logic;
    DM_OUT_R_DATA  : out std_logic_vector(C_g-1 downto 0)
    );
  end component;

  constant R_c : integer := 8;
  constant C_c : integer := 32;

  signal address, write_data, data_out : std_logic_vector(C_c-1 downto 0);
  signal memread, memwrite             : std_logic;
begin
  signals_p: process
  begin
      memwrite <= '0';
      write_data <= std_logic_vector(to_unsigned(333,32));
      memread <= '1';
      address <= std_logic_vector(to_unsigned(0,32));
      wait for 5 ns;
      address <= std_logic_vector(to_unsigned(4,32));
      wait for 5 ns;
      address <= std_logic_vector(to_unsigned(24,32));
      wait for 5 ns;
      memwrite <= '1';
      memread <= '0';
      address <= std_logic_vector(to_unsigned(28,32));
      wait;
    end process;

  DUT: DATA_MEM generic map(R_c, C_c) port map(address, write_data, memwrite, memread, data_out);



end architecture;
