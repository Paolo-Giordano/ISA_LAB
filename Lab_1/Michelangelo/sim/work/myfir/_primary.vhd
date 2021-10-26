library verilog;
use verilog.vl_types.all;
entity myfir is
    port(
        MYFIR_IN_RST_n  : in     vl_logic;
        MYFIR_IN_CLK    : in     vl_logic;
        MYFIR_IN_b0     : in     vl_logic_vector(8 downto 0);
        MYFIR_IN_b1     : in     vl_logic_vector(8 downto 0);
        MYFIR_IN_b2     : in     vl_logic_vector(8 downto 0);
        MYFIR_IN_b3     : in     vl_logic_vector(8 downto 0);
        MYFIR_IN_b4     : in     vl_logic_vector(8 downto 0);
        MYFIR_IN_b5     : in     vl_logic_vector(8 downto 0);
        MYFIR_IN_b6     : in     vl_logic_vector(8 downto 0);
        MYFIR_IN_b7     : in     vl_logic_vector(8 downto 0);
        MYFIR_IN_b8     : in     vl_logic_vector(8 downto 0);
        MYFIR_IN_b9     : in     vl_logic_vector(8 downto 0);
        MYFIR_IN_b10    : in     vl_logic_vector(8 downto 0);
        MYFIR_IN_VIN    : in     vl_logic;
        MYFIR_IN_DIN    : in     vl_logic_vector(8 downto 0);
        MYFIR_OUT_VOUT  : out    vl_logic;
        MYFIR_OUT_DOUT  : out    vl_logic_vector(8 downto 0)
    );
end myfir;
