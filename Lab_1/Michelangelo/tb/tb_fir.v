//`timescale 1ns

module tb_fir ();

   wire CLK_i;
   wire RST_n_i;
   wire [8:0] DIN_i;
   wire VIN_i;
   wire DATA_EN_i;
   wire [8:0] H0_i;
   wire [8:0] H1_i;
   wire [8:0] H2_i;
   wire [8:0] H3_i;
   wire [8:0] H4_i;
   wire [8:0] H5_i;
   wire [8:0] H6_i;
   wire [8:0] H7_i;
   wire [8:0] H8_i;
   wire [8:0] H9_i;
   wire [8:0] H10_i;
   wire [8:0] DOUT_i;
   wire VOUT_i;
   wire END_SIM_i;

   clk_gen CG(.END_SIM(END_SIM_i),
     .CLK(CLK_i),
     .DATA_EN(DATA_EN_i),
     .RST_n(RST_n_i));

   data_maker SM(.CLK(CLK_i),
	   .RST_n(RST_n_i),
     .DATA_EN(DATA_EN_i),
		 .VOUT(VIN_i),
		 .DOUT(DIN_i),
		 .H0(H0_i),
		 .H1(H1_i),
		 .H2(H2_i),
		 .H3(H3_i),
     .H4(H4_i),
		 .H5(H5_i),
		 .H6(H6_i),
		 .H7(H7_i),
     .H8(H8_i),
		 .H9(H9_i),
		 .H10(H10_i),
		 .END_SIM(END_SIM_i));

   myfir UUT(.MYFIR_IN_RST_n(RST_n_i),
       .MYFIR_IN_CLK(CLK_i),
       .MYFIR_IN_b0(H0_i),
	     .MYFIR_IN_b1(H1_i),
	     .MYFIR_IN_b2(H2_i),
	     .MYFIR_IN_b3(H3_i),
       .MYFIR_IN_b4(H4_i),
	     .MYFIR_IN_b5(H5_i),
	     .MYFIR_IN_b6(H6_i),
	     .MYFIR_IN_b7(H7_i),
       .MYFIR_IN_b8(H8_i),
	     .MYFIR_IN_b9(H9_i),
	     .MYFIR_IN_b10(H10_i),
	     .MYFIR_IN_VIN(VIN_i),
       .MYFIR_IN_DIN(DIN_i),
       .MYFIR_OUT_VOUT(VOUT_i),
       .MYFIR_OUT_DOUT(DOUT_i));

   data_sink DS(.CLK(CLK_i),
		.RST_n(RST_n_i),
		.VIN(VOUT_i),
		.DIN(DOUT_i));



endmodule
