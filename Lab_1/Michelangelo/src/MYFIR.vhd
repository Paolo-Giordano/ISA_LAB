library ieee;
use ieee.std_logic_1164.all;

entity MYFIR is
    port (
        MYFIR_IN_RST_n          : in std_logic;
        MYFIR_IN_CLK            : in std_logic;
        MYFIR_IN_b0             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b1             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b2             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b3             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b4             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b5             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b6             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b7             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b8             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b9             : in std_logic_vector(8 downto 0);
        MYFIR_IN_b10            : in std_logic_vector(8 downto 0);
        MYFIR_IN_VIN            : in std_logic;
        MYFIR_IN_DIN            : in std_logic_vector(8 downto 0);
        MYFIR_OUT_VOUT          : out std_logic;
        MYFIR_OUT_DOUT          : out std_logic_vector(8 downto 0)
    );
end entity;

architecture rtl of MYFIR is

    component adder is

    generic (N : integer := 4);
    port(
      adder_in_A : in std_logic_vector(N-1 downto 0);
      adder_in_B : in std_logic_vector(N-1 downto 0);
      adder_out  : out std_logic_vector(N-1 downto 0)
    );
    end component;

  component multiplier is
    generic (N : integer := 4);
    port(
      multiplier_in_A : in std_logic_vector(N-1 downto 0);
      multiplier_in_B : in std_logic_vector(N-1 downto 0);
      multiplier_out  : out std_logic_vector(2*N-1 downto 0)
    );
  end component;

  component saturation_unit is

    port(
      saturation_unit_in : in std_logic_vector(7 downto 0);
      saturation_unit_out : out std_logic_vector(8 downto 0)
    );
  end component;

  constant N_constants : integer := 11;
  type matrix_type is array(0 to N_constants-1) of std_logic_vector(17 downto 0);

  signal d_din,mult_out,adder_in,adder_out,coeffs : matrix_type;
  signal d_vin : std_logic_vector(0 to N_constants-1);
  signal and_out_reg_in : std_logic;
  signal sat_out_reg_in : std_logic_vector(8 downto 0);


begin

  --registers
  --------------------------------------------------------
  REGs_proc_proc: process(MYFIR_IN_RST_n,MYFIR_IN_CLK)
  begin
    if (MYFIR_IN_RST_n = '0') then
      --rst for VIN counter
      for i in 1 to N_constants-1 loop
        d_vin(i) <= '0';
      end loop;

    elsif MYFIR_IN_CLK'event and MYFIR_IN_CLK = '1' then
      --registers without en (in and out registers)
      d_vin(0) <= MYFIR_IN_VIN;
      d_din(0)(8 downto 0) <= MYFIR_IN_DIN;
      MYFIR_OUT_VOUT <= and_out_reg_in;

      --coeffs regs
      coeffs(0)(8 downto 0) <= MYFIR_IN_b0;
      coeffs(1)(8 downto 0) <= MYFIR_IN_b1;
      coeffs(2)(8 downto 0) <= MYFIR_IN_b2;
      coeffs(3)(8 downto 0) <= MYFIR_IN_b3;
      coeffs(4)(8 downto 0) <= MYFIR_IN_b4;
      coeffs(5)(8 downto 0) <= MYFIR_IN_b5;
      coeffs(6)(8 downto 0) <= MYFIR_IN_b6;
      coeffs(7)(8 downto 0) <= MYFIR_IN_b7;
      coeffs(8)(8 downto 0) <= MYFIR_IN_b8;
      coeffs(9)(8 downto 0) <= MYFIR_IN_b9;
      coeffs(10)(8 downto 0) <= MYFIR_IN_b10;


      --enabled REGs by d_vin
      if (d_vin(0) = '1') then
        for i in 0 to N_constants-2 loop
          --x[n-1],x[n-2],..
          d_din(i+1)(8 downto 0) <= d_din(i)(8 downto 0);
          --vin counter
          d_vin(i+1) <= d_vin(i);
        end loop;
      end if;

      if (and_out_reg_in = '1') then
        MYFIR_OUT_DOUT <= sat_out_reg_in;
      end if;

    end if;

  end process;

  --multipliers
  ----------------------------------------------------------
  i_MULTs_id: for i in 0 to N_constants - 1 generate
    i_MULT_id: multiplier generic map(9)
                          port map(
                              multiplier_in_A => d_din(i)(8 downto 0),
                              multiplier_in_B => coeffs(i)(8 downto 0),
                              multiplier_out => mult_out(i)
                          );
  end generate;

  MULT_OUT_TRUNCATION_proc: process(mult_out)
  begin

    for i in 0 to N_constants-1 loop
      adder_in(i)(7 downto 0) <= mult_out(i)(17 downto 10);
    end loop;

  end process;

  --adders
  ----------------------------------------------------------------------
  i_ADD0_id: adder generic map(8)
                   port map(
                      adder_in_A => adder_in(0)(7 downto 0),
                      adder_in_B => adder_in(1)(7 downto 0),
                      adder_out => adder_out(0)(7 downto 0)
                   );



  i_ADDs_id: for i in 0 to N_constants - 3 generate
    i_ADD_id: adder generic map(8)
                          port map(
                              adder_in_A => adder_out(i)(7 downto 0),
                              adder_in_B => adder_in(i+2)(7 downto 0),
                              adder_out => adder_out(i+1)(7 downto 0)
                          );
  end generate;

  --saturation saturation_unit
  ------------------------------------------------------------------------
  i_SAT_id: saturation_unit port map(
      saturation_unit_in => adder_out(9)(7 downto 0),
      saturation_unit_out => sat_out_reg_in
  );

  --Vout logic
  and_out_reg_in <= d_vin(0) and d_vin(N_constants-1);

end architecture;
