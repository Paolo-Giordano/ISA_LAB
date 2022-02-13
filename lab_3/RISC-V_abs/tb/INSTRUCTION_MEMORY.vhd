-------------------------------------------------------------------
-- DESCRIPTION:
-- The instr memory is already initialized with the instruction
-- to calculate the min value of a vector
-- Memory starts from address 0 untill address R_g, which represent
-- the number of rows; The address of the PC from the assembly program
-- starts at 4.194.304, so it is necessary to subtract this value
-- to obtain the correct address.
-- since the PC is increased by 4 every time, to address
-- the next instruction it is necessary to divide the address value by 4
-- in this way PC=0 --> address 0, PC=4-->address 1 and so on.
-- obviusly, address must be multiple of 4
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use STD.Textio.all;
--22 instr normally, now 42 isntr with the nop

entity INSTR_MEM is
  generic (R_g : integer := 36;   --number of line in the memory
           C_g : integer := 32);  --parallelism of the word
  port (
  IM_IN_ADDR  : in std_logic_vector(C_g-1 downto 0);
  IM_OUT_DATA : out std_logic_vector(C_g-1 downto 0)
  );
end entity;

architecture behavioural of INSTR_MEM is
  --array for the memory
  type mem_array is array (0 to R_g-1) of std_logic_vector(C_g-1 downto 0);
  --label of the instruction, for debugging
  type instr_enum is (addi_andi_srai, auipc, lui, beq, lw, add_slt_xor_abs, jal, sw,not_recognised);

  --use an inpure function to read a text file and load mem's value
  --return the filled memory array
  --parameter : string name of the input file
  impure function loadMem( fileName : in string) return mem_array is
    file     memfile : text open read_mode is fileName;      --file with the data
    variable lbuf    : line;                                          --save row from the file
    variable i       : integer := 0;
    variable d_mem   : mem_array;                                     --memory array to return
    begin
      while not endfile(memfile) loop
        readline(memfile, lbuf);        --read data from file
        hread(lbuf,d_mem(i));           --convert from hex to bin and store data the array
        i := i+1;
      end loop;
    return d_mem;
  end function;

  signal rom          : mem_array := loadMem("instr_memory.txt");    --declare the array and initialize it
  signal instr_label  : instr_enum;                                  --label, used to debug
  signal out_data     : std_logic_vector(C_g-1 downto 0);

begin

  --convert the address from the PC in the corresponding address of the data memory
  p_address_mem : process(IM_IN_ADDR) is
    variable mem_offset      : unsigned (C_g-1 downto 0);
    variable correct_address : unsigned (C_g-1 downto 0);
    begin
      mem_offset      :=  X"00400000";                          --initial value of the PC, hex
      correct_address := unsigned(IM_IN_ADDR) - mem_offset;

      out_data        <= rom(to_integer(correct_address) / 4);

    end process;
      IM_OUT_DATA     <= out_data;


  --process to label the instruction, to easily understand the simulation
  p_label: process(out_data) is
    variable out_data_var : std_logic_vector(6 downto 0);
    begin
      out_data_var := out_data(6 downto 0);
      case(out_data_var) is
        when "0010011" => instr_label <= addi_andi_srai;
        when "0010111" => instr_label <= auipc;
        when "0110111" => instr_label <= lui;
        when "1100011" => instr_label <= beq;
        when "0000011" => instr_label <= lw;
        when "0110011" => instr_label <= add_slt_xor_abs;
        when "1101111" => instr_label <= jal;
        when "0100011" => instr_label <= sw;
        when others    => instr_label <= not_recognised;
      end case;
    end process;

end architecture;
