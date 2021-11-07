//`timescale 1ns

module tb_fir ();

   wire CLK_i;
   wire RST_n_i;
   wire DATA_EN_i;
   wire [31:0] DATA_IN_i;
   wire [31:0] DATA_OUT_i;
   wire END_SIM_i;

   clk_gen CG(.END_SIM(END_SIM_i),
  	    .CLK(CLK_i),
        .DATA_EN(DATA_EN_i),
	      .RST_n(RST_n_i));

   data_maker SM(.CLK(CLK_i),
	   .RST_n(RST_n_i),
     .DATA_EN(DATA_EN_i),
		 .DATA_A(DATA_IN_i),
		 .END_SIM(END_SIM_i));

   FPmul UUT(.CLK(CLK_i),
      .DATA_A(DATA_IN_i),
      .DATA_B(DATA_IN_i),
      .DATA_Z(DATA_OUT_i));

   data_sink DS(.CLK(CLK_i),
		.RST_n(RST_n_i),
		.DIN(DATA_OUT_i));

endmodule
