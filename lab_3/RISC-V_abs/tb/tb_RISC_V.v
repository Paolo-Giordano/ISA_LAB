`timescale 1ns/1ps

module tb_RISC_V ();

//dut signals
wire clk;
wire rst_n;
wire memwrite;
wire memwritememread;
wire [31:0] instr;
wire [31:0] rd_data;
wire [31:0] pc;
wire [31:0] wr_addr;
wire [31:0] wr_data;

integer i;

//DUT instance
RISC_V i_DUT(
  .RISC_V_IN_CLK(clk),
  .RISC_V_IN_RST_N(rst_n),
  .RISC_V_IN_INSTR(instr),
  .RISC_V_IN_RD_DATA(rd_data),
  .RISC_V_OUT_PC(pc),
  .RISC_V_OUT_WR_ADD(wr_addr),
  .RISC_V_OUT_WR_DATA(wr_data),
  .RISC_V_OUT_MEMWRITE(memwrite),
  .RISC_V_OUT_MEMREAD(memwritememread));

//instruction memory instance
INSTR_MEM #(
  .R_g(24),
  .C_g(32)
  ) i_instr_mem
  (
  .IM_IN_ADDR(pc),
  .IM_OUT_DATA(instr));

//data memory instance
DATA_MEM #(
  .R_g(8),
  .C_g(32)
  ) i_data_mem
  (
  .DM_IN_ADDR(wr_addr),
  .DM_IN_W_DATA(wr_data),
  .DM_IN_MEMWRITE(memwrite),
  .DM_IN_MEMREAD(memwritememread),
  .DM_OUT_R_DATA(rd_data));


clk_gen CG(.CLK(clk),
		   .RST(rst_n));
//clock generation
//always #5 clk = ~clk;

/*
initial begin
  for( i = 0; i < 31; i = i+1) begin
    $monitor("TIME=%0t - Reg[%0d] = %0h",$time,i,tb_risc_V.i_DUT.i_decode_stage.i_RF_id.registers[i]);
  end
end
*/




endmodule
