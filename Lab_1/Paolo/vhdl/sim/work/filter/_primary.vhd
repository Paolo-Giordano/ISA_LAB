library verilog;
use verilog.vl_types.all;
entity filter is
    port(
        RST_n           : in     vl_logic;
        CLK             : in     vl_logic;
        b0              : in     vl_logic_vector(8 downto 0);
        b1              : in     vl_logic_vector(8 downto 0);
        b2              : in     vl_logic_vector(8 downto 0);
        b3              : in     vl_logic_vector(8 downto 0);
        b4              : in     vl_logic_vector(8 downto 0);
        b5              : in     vl_logic_vector(8 downto 0);
        b6              : in     vl_logic_vector(8 downto 0);
        b7              : in     vl_logic_vector(8 downto 0);
        b8              : in     vl_logic_vector(8 downto 0);
        b9              : in     vl_logic_vector(8 downto 0);
        b10             : in     vl_logic_vector(8 downto 0);
        VIN             : in     vl_logic;
        DIN             : in     vl_logic_vector(8 downto 0);
        VOUT            : out    vl_logic;
        DOUT            : out    vl_logic_vector(8 downto 0)
    );
end filter;
