--------------------------------------------------------
--Description: unit that generates the control signal 
--of the alu considering 2 bits produced by the control
--unit and the f3 field of the instruction (if present) 
--------------------------------------------------------
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALUcontrol is
    port (
        ALU_CONTROL_IN_ALUOP      : in std_logic_vector(1 downto 0);
        ALU_CONTROL_IN_FUNC4      : in std_logic_vector(3 downto 0);
        ALU_CONTROL_OUT           : out std_logic_vector(3 downto 0)
    );
end entity;

architecture behavioral of ALUcontrol is

    signal ALU_CONTROL_IN_F3: std_logic_vector(2 downto 0);
    begin
        ALU_CONTROL_IN_F3 <= ALU_CONTROL_IN_FUNC4(2 downto 0);
        process (ALU_CONTROL_IN_ALUOP,ALU_CONTROL_IN_F3)
        begin
            case ALU_CONTROL_IN_ALUOP is
                when "00" => -- LW and SW
                    ALU_CONTROL_OUT <= "0010"; --addition
                when "01" => --BEQ
                    ALU_CONTROL_OUT <= "0110"; --subtraction
                when "10" => 
                    if (ALU_CONTROL_IN_F3="000") then --ADD and ADDi
                        ALU_CONTROL_OUT <= "0010"; --addition
                    elsif (ALU_CONTROL_IN_F3="010") then --SLT
                        ALU_CONTROL_OUT <= "1110"; 
                    elsif (ALU_CONTROL_IN_F3="100") then --XOR
                        ALU_CONTROL_OUT <= "0001"; 
                    elsif (ALU_CONTROL_IN_F3="101") then 
                        if (ALU_CONTROL_IN_FUNC4(3)='1') then --SRAi
                            ALU_CONTROL_OUT <= "0011"; 
                        else --not possible in our cases
                            ALU_CONTROL_OUT <= "0000"; 
                        end if;
                    elsif (ALU_CONTROL_IN_F3="111") then --ANDi
                        ALU_CONTROL_OUT <= "0000";
                    else --never happens
                        ALU_CONTROL_OUT <= "0000";
                    end if;
                when others => --JAL and AUIPC 
                    ALU_CONTROL_OUT <= "0010"; --addition    
            end case;
        end process;
end architecture;