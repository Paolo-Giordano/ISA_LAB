library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU is
  port (
        --in
        CU_Opcode     : in std_logic_vector(6 downto 0);
        --controls
        CU_jal        : out std_logic;
        CU_Branch     : out std_logic;
        CU_MemRead    : out std_logic;
        CU_MemWrite   : out std_logic;
        CU_MemToReg   : out std_logic;
        CU_RegWrite   : out std_logic;
        CU_AluSrc1    : out std_logic;
        CU_AluSrc2    : out std_logic_vector(1 downto 0);
        CU_ExecuteOut : out std_logic;
        CU_AluOp      : out std_logic_vector(1 downto 0)
        );
end entity;


architecture beh of CU is



begin

  CU_p: process(CU_Opcode) is

    begin
    --default values
    CU_jal        <= '0';
    CU_Branch     <= '0';
    CU_MemRead    <= '0';
    CU_MemWrite   <= '0';
    CU_MemToReg   <= '0';
    CU_RegWrite   <= '0';
    CU_AluSrc1    <= '0';
    CU_AluSrc2    <= "00";
    CU_ExecuteOut <= '0';
    CU_AluOp      <= "00";

    case CU_Opcode is
      --add,xor,slt
      when "0110011" =>
        CU_RegWrite <= '1';
        CU_AluOp    <= "10";

      --addi,andi,srai
      when "0010011" =>
        CU_RegWrite <= '1';
        CU_AluOp    <= "10";
        CU_AluSrc2  <= "01";

      --lw
      when "0000011" =>
        CU_MemRead  <= '1';
        CU_MemToReg <= '1';
        CU_RegWrite <= '1';
        CU_AluSrc2  <= "01";

      --sw
      when "0100011" =>
        CU_MemWrite <= '1';
        CU_AluSrc2  <= "01";


      --beq
      when "1100011" =>
        CU_Branch <= '1';
        CU_AluOp  <= "01";

      --jal
      when "1101111" =>
        CU_jal <= '1';
        CU_RegWrite <= '1';
        CU_AluSrc2  <= "10";
        CU_AluOp    <= "11";
        CU_AluSrc1  <= '1';

      --lui
      when "0110111" =>
        CU_RegWrite   <= '1';
        CU_ExecuteOut <= '1';

      --auipc
      when "0010111" =>
        CU_RegWrite <= '1';
        CU_AluSrc1  <= '1';
        CU_AluSrc2  <= "01";
        CU_AluOp    <= "11";
      --dummy when others
      when others => CU_RegWrite <= '0';
    end case;
  end process;


end architecture;
