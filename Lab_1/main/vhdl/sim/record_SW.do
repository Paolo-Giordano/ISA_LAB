set top_entity filter

#compile all the vhdl files for testbench
vcom -93 -work ./work ../tb/data_maker_new.vhd
vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/data_sink.vhd

#compile verilog netlist and testbench
vlog -work ./work ../netlist/$top_entity.v
vlog -work ./work ../tb/tb_fir.v

#compile verilog source once and link the compiled library, linking also the delay file
vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_fir/UUT=../netlist/$top_entity.sdf work.tb_fir

#value change dump file to write switching information
vcd file ../vcd/${top_entity}_syn.vcd

#monitor all the signal inside the UUT
vcd add /tb_fir/UUT/*

run 10 us
