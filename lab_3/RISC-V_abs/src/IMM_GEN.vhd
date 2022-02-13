---------------------------------------------
--Description: generation of the immediate
--value - the behaviour depend on the
--instruction opcode
---------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IMM_GEN is
  port (
        --in
        IG_Instr     : in std_logic_vector(31 downto 0);
        --controls
        IG_Imm     : out std_logic_vector(31 downto 0)
        );
end entity;


architecture beh of IMM_GEN is

  signal instrOpcode : std_logic_vector(6 downto 0);



begin

  instrOpcode <= IG_Instr(6 downto 0);

  IMM_GEN_p: process(instrOpcode, IG_Instr) is

    begin

    case instrOpcode  is

      --addi,andi,srai,lw
      when "0010011" | "0000011" =>
        IG_Imm <= (31 downto 12 => IG_Instr(31)) & IG_Instr(31 downto 20);

      --sw
      when "0100011" =>
        IG_Imm <= (31 downto 12 => IG_Instr(31)) & IG_Instr(31 downto 25) & IG_Instr(11 downto 7);

      --beq
      when "1100011" =>
        IG_Imm <= (31 downto 11 => IG_Instr(31)) & IG_Instr(7) & IG_Instr(30 downto 25) & IG_Instr(11 downto 8) ;

      --jal
      when "1101111" =>
        IG_Imm <= (31 downto 19 => IG_Instr(31)) & IG_Instr(19 downto 12) & IG_Instr(20) & IG_Instr(30 downto 21) ;

      --lui,auipc
      when "0110111" | "0010111" =>
        IG_Imm <= IG_Instr(31 downto 12) & (11 downto 0 => '0');

      --dummy when others
      when others =>
        IG_Imm <= IG_Instr;

    end case;
  end process;


end architecture;
