----------------------------------------------------------------
--Description: personalised branch prediction table
--4 rows one for each BEQ or JAL instruction, each row has 33 bits
--the MSB is the prediction, 1 to jump, 0 to go in sequence
--the 32 LB bits store the address in case of jump
--it is personalized because it has an internal decoder that
--starting from the address on 32 bits, addresses one of the four rows
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_prediction_table is
  generic (
        DATA_WIDTH_g  : integer := 33);
  port(
      --BPT_Clk
      BPT_Clk      : in std_logic;
      BPT_Rst_n    : in std_logic;
      --write port
      BPT_EnWrite  : in std_logic;
      BPT_WriteAdd : in std_logic_vector(31 downto 0);
      BPT_WriteData: in std_logic_vector(DATA_WIDTH_g-1 downto 0);
      --read port(reading always)
      BPT_ReadAdd  : in std_logic_vector(31 downto 0);
      BPT_ReadData : out std_logic_vector(DATA_WIDTH_g-1 downto 0)
    );
  end entity;

  architecture beh of branch_prediction_table is

    type table  is array (0 to 3) of std_logic_vector (DATA_WIDTH_g-1 downto 0);
    signal BP_table             : table;
    signal write_add, read_add  : std_logic_vector(1 downto 0);

    begin
        write_add <= "00" when BPT_WriteAdd = x"0040001C" else
                    "01" when BPT_WriteAdd = x"00400040" else
                    "10" when BPT_WriteAdd = x"00400048" else
                    "11";
        read_add <= "00" when BPT_ReadAdd = x"0040001C" else
                    "01" when BPT_ReadAdd = x"00400040" else
                    "10" when BPT_ReadAdd = x"00400048" else
                    "11";

        BPT_ReadData <= BP_table(to_integer(unsigned(read_add)));

        WRITE_p: process(BPT_Clk,BPT_Rst_n)
        begin
            if (BPT_Rst_n='0') then
                for i in 0 to 3 loop
                    BP_table(i)<= (others=>'0');
                end loop;
            else
                if (BPT_Clk'event and BPT_Clk='1') then
                --writing only if enabled
                if (BPT_EnWrite='1') then
                    BP_table(to_integer(unsigned(write_add))) <= BPT_WriteData;
                end if;
                end if;
            end if;
        end process;

  end architecture;
