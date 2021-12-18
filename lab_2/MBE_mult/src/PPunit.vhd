--------------------------------------------------------------------
--Description: unit to evaluate the partial products and to properly
--align them for the next stage
--------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.array_interface_pack.all;

entity PPunit is
generic(N_g:integer:=32);
port(
    A_IN        : IN std_logic_vector (N_g-1 downto 0);
    B_IN        : IN std_logic_vector (N_g-1 downto 0);
    PP_array    : OUT array_in
);
end entity;

architecture structural of PPunit is

    --component to evaluate the single partial product
    component RecodingLogic is
    generic (N:integer:=8);
    port(
        BITS_IN : IN std_logic_vector(2 downto 0);
        A_IN    : IN std_logic_vector(N downto 0);
        A2_IN   : IN std_logic_vector(N downto 0);
        NEGA_IN : IN std_logic_vector(N downto 0);
        NEGA2_IN: IN std_logic_vector(N downto 0);
        S_OUT   : OUT std_logic;
        PP_OUT  : OUT std_logic_vector(N downto 0)
    );
    end component;

    --A multiples
    signal A_Nbit, A2_Nbit, negA_Nbit, negA2_Nbit: std_logic_vector(N_g downto 0);
    --B has to be extended: one zero has to be added as LSB to emulate the dummy FF 
    --in theory if N is odd a single zero has to be inserted as MSB, otherwise 2 zeros -> 2 zeros are
    --always inserted and both considered or not depending on the case
    signal extendedB                             : std_logic_vector (N_g+2 downto 0);

    --number of partial products
	constant n_PP : integer:= N/2+1; 

    --array to store the PPs not aligned, one line per PP
    type PParray is array (n_PP-1 downto 0) of std_logic_vector (N_g downto 0);
    signal PP_evaluated: PParray;
    --vector to store the sign of all the PPs at the same index of the PP in the PParray
    signal S_vec       : std_logic_vector (n_PP-1 downto 0);
	

begin
    --A multiples evaluation
    A_Nbit <= "0" & A_IN;
    A2_Nbit <= A_IN & "0";
    process(A_IN)
        variable negA: std_logic_vector(N_g-1 downto 0);
        begin
        for i in 0 to N_g-1 loop
            negA(i) := not(A_IN(i));
        end loop;
        negA_Nbit <= "1" & negA;
        negA2_Nbit<= negA & "1";
    end process;

    --B extension
    extendedB           <= "00" & B_IN & "0"; 

    --MBE units to evaluate the PPs
    g_encoding: for i in 0 to n_PP-1 generate
    begin
        i_MBEunit: RecodingLogic generic map (N=> N_g)
            port map(
                BITS_IN => extendedB(2+2*i downto 2*i), --3 bits selected as input
                A_IN    => A_Nbit,
                A2_IN   => A2_Nbit,
                NEGA_IN => negA_Nbit,
                NEGA2_IN=> negA2_Nbit,
                S_OUT   => S_vec(i), --sign of the PP
                PP_OUT  => PP_evaluated(i) --selected PP
            );
    end generate;

    --built of the matrix that has to be passed to the dadda tree --> alignment of the PP, extension, all to compute
    --CA2 on the fly where necessary
    process (PP_evaluated,S_vec)
    begin
        for i in 0 to n_PP-1 loop
                if i=0 then --first row
                    PP_array(i)(N_g+3 downto 0)         <= not(S_vec(i)) & S_vec(i) & S_vec(i) & PP_evaluated(i);
                    PP_array(i+1)(2*i)                  <= S_vec(i); 
                elsif i=N_g/2 then --last row
                    if ((N mod 2) = 0) then --N even
                       PP_array(i)(N_g-1+2*i downto 2*i)<= PP_evaluated(i)(N_g-1 downto 0);
                    else --N odd
                        PP_array(i)(N_g+2*i downto 2*i) <= PP_evaluated(i);
                    end if;
                elsif i=N_g/2-1 then --last row-1
                    if ((N mod 2) = 0) then --N even
                        PP_array(i)(N_g+1+2*i downto 2*i)<= not(S_vec(i)) & PP_evaluated(i);
                        PP_array(i+1)(2*i)               <= S_vec(i);
                    else --N odd
                        PP_array(i)(N_g+2+2*i downto 2*i)<= "1" & not(S_vec(i)) & PP_evaluated(i);
                        PP_array(i+1)(2*i)               <= S_vec(i);
                    end if;
                else --others
                    PP_array(i)(N_g+2+2*i downto 2*i)    <= "1" & not(S_vec(i)) & PP_evaluated(i);
                    PP_array(i+1)(2*i)                   <= S_vec(i);
                end if;

        end loop;
    end process;


end architecture;
