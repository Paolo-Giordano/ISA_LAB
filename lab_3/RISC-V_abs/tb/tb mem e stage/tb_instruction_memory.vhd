library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_instruction_memory is
end entity;

architecture behavioural of tb_instruction_memory  is

  component INSTR_MEM is
    generic (R_g : integer := 36;   --number of line in the memory
             C_g : integer := 32);  --parallelsim of the word
    port (
    IM_IN_ADDR  : in std_logic_vector(C_g-1 downto 0);
    IM_OUT_DATA : out std_logic_vector(C_g-1 downto 0)
    );
  end component;

  constant R_c : integer := 36;
  constant C_c : integer := 32;

  signal address  : std_logic_vector(C_c-1 downto 0);
  signal data_out : std_logic_vector(C_c-1 downto 0);

begin

  address <=  std_logic_vector(to_unsigned(0,32)), std_logic_vector(to_unsigned(4,32)) after 5 ns, std_logic_vector(to_unsigned(8,32)) after 10 ns,
               std_logic_vector(to_unsigned(12,32)) after 15 ns, std_logic_vector(to_unsigned(16,32)) after 20 ns, std_logic_vector(to_unsigned(20,32)) after 25 ns,
              std_logic_vector(to_unsigned(24,32)) after 30 ns, std_logic_vector(to_unsigned(28,32)) after 35 ns,
              std_logic_vector(to_unsigned(32,32)) after 37 ns, std_logic_vector(to_unsigned(36,32)) after 40 ns, std_logic_vector(to_unsigned(40,32)) after 45 ns,
              std_logic_vector(to_unsigned(44,32)) after 50 ns, std_logic_vector(to_unsigned(48,32)) after 55 ns, std_logic_vector(to_unsigned(52,32)) after 60 ns,
              std_logic_vector(to_unsigned(56,32)) after 65 ns, std_logic_vector(to_unsigned(60,32)) after 70 ns,
              std_logic_vector(to_unsigned(64,32)) after 75 ns, std_logic_vector(to_unsigned(68,32)) after 80 ns,
              std_logic_vector(to_unsigned(72,32)) after 85 ns, std_logic_vector(to_unsigned(76,32)) after 90 ns, std_logic_vector(to_unsigned(80,32)) after 95 ns,
              std_logic_vector(to_unsigned(84,32)) after 100 ns, std_logic_vector(to_unsigned(88,32)) after 105 ns, std_logic_vector(to_unsigned(92,32)) after 110 ns,
              std_logic_vector(to_unsigned(16,32)) after 115 ns, std_logic_vector(to_unsigned(100,32)) after 120 ns ,
              std_logic_vector(to_unsigned(104,32)) after 125 ns, std_logic_vector(to_unsigned(108,32)) after 130 ns,
              std_logic_vector(to_unsigned(112,32)) after 135 ns, std_logic_vector(to_unsigned(116,32)) after 140 ns, std_logic_vector(to_unsigned(120,32)) after 145 ns,
              std_logic_vector(to_unsigned(124,32)) after 150 ns, std_logic_vector(to_unsigned(128,32)) after 155 ns,
              std_logic_vector(to_unsigned(132,32)) after 160 ns,
             std_logic_vector(to_unsigned(136,32)) after 165 ns, std_logic_vector(to_unsigned(140,32)) after 170 ns;
  DUT: INSTR_MEM generic map(R_c, C_c) port map(address, data_out);

end architecture;
