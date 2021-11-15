set folder firopt_inputshifted
set top_entity filter_opt

vlib work
#compile all the vhdl files for testbench
vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/data_maker_new_firopt.vhd
vcom -93 -work ./work ../tb/data_sink_firopt.vhd

#compile verilog netlist and testbench
vlog -work ./work ../innovus/${folder}/$top_entity.v
vlog -work ./work ../tb/tb_fir_opt.v

#compile verilog source once and link the compiled library, linking also the delay file
vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_fir/UUT=../innovus/${folder}/$top_entity.sdf work.tb_fir

#compile verilog source once and link the compiled library, linking also the delay file
vcd file ../vcd/${top_entity}_innovus.vcd

#monitor all the signal inside the UUT
vcd add /tb_fir/UUT/*
run 6 us
quit -sim

