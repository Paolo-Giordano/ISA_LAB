---------------------------------------------
--Description: register file with parametric
-- data width and depth.
-- it has 2 read port and a write port with
-- the possibility of a bypass between input
-- data and output datas to ensure trasparency
---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RF is
  generic (
        ADDR_WIDTH_g : integer := 5;
        DATA_WIDTH_g  : integer := 32);
  port(
      --RF_Clk
      RF_Clk : in std_logic;
      --write
      RF_RegWrite : in std_logic;
      RF_WriteAdd : in std_logic_vector(ADDR_WIDTH_g-1 downto 0);
      RF_WriteData : in std_logic_vector(DATA_WIDTH_g-1 downto 0);
      --read (reading always)
      RF_ReadAdd1 : in std_logic_vector(ADDR_WIDTH_g-1 downto 0);
      RF_ReadAdd2 : in std_logic_vector(ADDR_WIDTH_g-1 downto 0);

      RF_ReadData1 : out std_logic_vector(DATA_WIDTH_g-1 downto 0);
      RF_ReadData2 : out std_logic_vector(DATA_WIDTH_g-1 downto 0)
    );
  end entity;

  architecture beh of RF is

    type registerFile  is array (0 to 2**ADDR_WIDTH_g-1) of std_logic_vector (DATA_WIDTH_g-1 downto 0);
     signal registers : registerFile;

    begin


      WRITE_p: process(RF_Clk)
      begin
        if (RF_Clk'event and RF_Clk='1') then

          --writing only if enabled
          --ADD=0 can't be written
          if (RF_RegWrite='1' and to_integer(unsigned(RF_WriteAdd)) /= 0) then
            registers(to_integer(unsigned(RF_WriteAdd))) <= RF_WriteData;
          end if;

        end if;
      end process;

      --output multiplexer for register selection (always enabled)
      READ_p: process(RF_ReadAdd1,RF_ReadAdd2,registers,RF_RegWrite,RF_WriteAdd,RF_WriteData)
      begin
        --read port 1
        --comparator for register trasparency
        if (RF_ReadAdd1 = RF_WriteAdd and to_integer(unsigned(RF_ReadAdd1)) /= 0 and RF_RegWrite = '1') then
          RF_ReadData1 <= RF_WriteData;
        elsif (to_integer(unsigned(RF_ReadAdd1)) = 0) then
          RF_ReadData1 <= std_logic_vector(to_unsigned(0,DATA_WIDTH_g));
        else
          RF_ReadData1 <= registers(to_integer(unsigned(RF_ReadAdd1)));
        end if;

        --read port 2
        --comparator for register trasparency
        if (RF_ReadAdd2 = RF_WriteAdd and to_integer(unsigned(RF_ReadAdd2)) /= 0 and RF_RegWrite = '1') then
          RF_ReadData2 <= RF_WriteData;
        elsif (to_integer(unsigned(RF_ReadAdd2)) = 0) then
          RF_ReadData2 <= std_logic_vector(to_unsigned(0,DATA_WIDTH_g));
        else
          RF_ReadData2 <= registers(to_integer(unsigned(RF_ReadAdd2)));
        end if;

      end process;


  end architecture;
