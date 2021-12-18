//`timescale 1ns

module tb_mult ();

   wire CLK_i;
   wire [31:0] DIN_A_i;
   wire [31:0] DIN_B_i;
   wire [63:0] DOUT_Z_i;
   //wire END_SIM_i;

   clk_gen CG(//.END_SIM(END_SIM_i),
     .CLK(CLK_i));

   data_maker_mult SM(.CLK(CLK_i),
		 .DATA_A(DIN_A_i),
		 .DATA_B(DIN_B_i));

   MBEmult UUT(
       .MULT_A(DIN_A_i),
       .MULT_B(DIN_B_i),
       .MULT_Z(DOUT_Z_i));

   data_sink_mult DS(.CLK(CLK_i),
		            .DIN(DOUT_Z_i));



endmodule
