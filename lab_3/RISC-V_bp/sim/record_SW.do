vlib work

set SIM_TIME 420
set SIM_UNIT ns


vlog -work ./work ../netlist/RISC_V.v

#tb files
vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/INSTRUCTION_MEMORY.vhd
vcom -93 -work ./work ../tb/DATA_MEMORY.vhd
vlog -work ./work ../tb/tb_RISC_V.v

#compile verilog source once and link the compiled library, linking also the delay file
vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_RISC_V/i_DUT=../netlist/RISC_V.sdf work.tb_RISC_V

#value change dump file to write switching information
vcd file ../vcd/RISC_V_syn.vcd

#monitor all the signal inside the DUT
vcd add /tb_RISC_V/i_DUT/*

#add wave 
add wave *
add wave sim:/tb_RISC_V/i_instr_mem/instr_label
add wave sim:/tb_RISC_V/i_data_mem/data_mem

# run simulation
run $SIM_TIME $SIM_UNIT

# quit from sim
quit -sim
quit
