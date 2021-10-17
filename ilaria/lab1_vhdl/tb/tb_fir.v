//`timescale 1ns

module tb_fir ();

   wire CLK_i;
   wire RST_n_i;
   wire [8:0] DIN_i;
   wire VIN_i;
   wire [8:0] b0_i;
   wire [8:0] b1_i;
   wire [8:0] b2_i;
   wire [8:0] b3_i;
   wire [8:0] b4_i;
   wire [8:0] b5_i;
   wire [8:0] b6_i;
   wire [8:0] b7_i;
   wire [8:0] b8_i;
   wire [8:0] b9_i;
   wire [8:0] b10_i;
   wire [8:0] DOUT_i;
   wire VOUT_i;
   wire END_SIM_i;

   clk_gen CG(
	   	.END_SIM(END_SIM_i),
		.CLK(CLK_i),
		.RST_n(RST_n_i));

   data_maker SM(.CLK(CLK_i),
	    .RST_n(RST_n_i),
		.VOUT(VIN_i),
		.DOUT(DIN_i),
		.b0(b0_i),
		.b1(b1_i),
		.b2(b2_i),
		.b3(b3_i),
		.b4(b4_i),
		.b5(b5_i),
		.b6(b6_i),
		.b7(b7_i),
		.b8(b8_i),
		.b9(b9_i),
		.b10(b10_i),
		.END_SIM(END_SIM_i));

   MYFIR UUT(
	   	.MYFIR_IN_CLK(CLK_i),
		.MYFIR_IN_RST_n(RST_n_i),
		.MYFIR_IN_DIN(DIN_i),
		.MYFIR_IN_VIN(VIN_i),
		.MYFIR_IN_b0(b0_i),
		.MYFIR_IN_b1(b1_i),
		.MYFIR_IN_b2(b2_i),
		.MYFIR_IN_b3(b3_i),
		.MYFIR_IN_b4(b4_i),
		.MYFIR_IN_b5(b5_i),
		.MYFIR_IN_b6(b6_i),
		.MYFIR_IN_b7(b7_i),
		.MYFIR_IN_b8(b8_i),
		.MYFIR_IN_b9(b9_i),
		.MYFIR_IN_b10(b10_i),
		.MYFIR_OUT_DOUT(DOUT_i),
		.MYFIR_OUT_VOUT(VOUT_i));

   data_sink DS(.CLK(CLK_i),
		.RST_n(RST_n_i),
		.VIN(VOUT_i),
		.DIN(DOUT_i));   

endmodule

		   