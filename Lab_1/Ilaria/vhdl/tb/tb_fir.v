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

   filter UUT(
	   	.CLK(CLK_i),
		.RST_n(RST_n_i),
		.DIN(DIN_i),
		.VIN(VIN_i),
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
		.DOUT(DOUT_i),
		.VOUT(VOUT_i));

   data_sink DS(.CLK(CLK_i),
		.RST_n(RST_n_i),
		.VIN(VOUT_i),
		.DIN(DOUT_i));   

endmodule

		   