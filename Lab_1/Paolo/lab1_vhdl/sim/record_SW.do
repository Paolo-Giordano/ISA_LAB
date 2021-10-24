
vlib work

#compile all the vhdl files for testbench
vcom -93 -work ./work ../tb/*.vhd

#compile verilog netlist and testbench
vlog -work ./work ../netlist/filter.v
vlog -work ./work ../tb/tb_fir.v

#compile verilog source once and link the compiled library, linking also the delay file
vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_fir/UUT=../netlist/filter.sdf work.tb_fir

#value change dump file to write switching information
vcd file ../vcd/filter_syn.vcd

#monitor all the signal inside the UUT
vcd add /tb_fir/UUT/*

run 10 us
