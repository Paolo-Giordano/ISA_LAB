-----------------------------------------------------------------
-- DESCRIPTION:
-- The data memory is already initialized with a vector of 7 values
-- the min value is stored in the 10th address.
-- Memory starts from address 0 untill address R_g, which represent
-- the number of rows; The address of the memory from the assembly
-- program starts at 268.500.992, so it is necessary to subtract
-- this value to obtain the correct address.
-- since the PC is increased by 4 every time, to address
-- the next data it is necessary to divide the address value by 4
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use STD.Textio.all;

entity DATA_MEM is
  generic (R_g : integer := 8;    --number of line in the memory
           C_g : integer := 32);  --parallelism of the word
  port (
  DM_IN_ADDR     : in std_logic_vector(C_g-1 downto 0);
  DM_IN_W_DATA   : in std_logic_vector(C_g-1 downto 0);
  DM_IN_MEMWRITE : in std_logic;
  DM_IN_MEMREAD  : in std_logic;
  DM_OUT_R_DATA  : out std_logic_vector(C_g-1 downto 0)
  );
end entity;

architecture behavioural of DATA_MEM is

  type mem_array is array (0 to R_g-1) of std_logic_vector(C_g-1 downto 0);

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

    constant MEM_OFFSET_c : unsigned := X"10010000";

    signal correct_address : unsigned (C_g-1 downto 0);
    signal data_mem : mem_array:= loadMem("data_memory.txt");    --declare the array and initialize it

begin


  adjust_addr_p: process(DM_IN_ADDR)
    variable correct_address_v : unsigned(C_g-1 downto 0);
  begin
    correct_address_v := unsigned(DM_IN_ADDR) - MEM_OFFSET_c;
    if(to_integer(correct_address_v) >= 0 and to_integer(correct_address_v) <= 7*4) then
      correct_address <= correct_address_v;
    else
      correct_address <= (others => '0');
    end if;
  end process;


  rd_wr_mem_p: process(correct_address,DM_IN_W_DATA,DM_IN_MEMWRITE,DM_IN_MEMREAD,data_mem)
    begin

        DM_OUT_R_DATA <= (others => 'Z');
        if (DM_IN_MEMWRITE = '1') then
          data_mem(to_integer(correct_address) / 4)  <= DM_IN_W_DATA;
        elsif (DM_IN_MEMREAD = '1') then
          DM_OUT_R_DATA                              <= data_mem(to_integer(correct_address) / 4);
        end if;

    end process;

end architecture;
