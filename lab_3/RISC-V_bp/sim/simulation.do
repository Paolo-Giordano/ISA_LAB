vlib work

set RES ps
set SIM_FILE work.tb_RISC_V
set SIM_TIME 1.2
set SIM_UNIT us
set TOP_ENTITY tb_RISC_V

#src files
vcom -93 -work ./work ../src/*

#tb files
vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/INSTRUCTION_MEMORY.vhd
vcom -93 -work ./work ../tb/DATA_MEMORY.vhd
vlog -work ./work ../tb/$TOP_ENTITY.v

#simulation -- resolution
vsim -t $RES $SIM_FILE

#add wave 
add wave *
add wave sim:/tb_RISC_V/i_instr_mem/instr_label
add wave sim:/tb_RISC_V/i_DUT/i_decode_stage/i_rf_id/registers
add wave sim:/tb_RISC_V/i_data_mem/data_mem

# run simulation
run $SIM_TIME $SIM_UNIT

# quit from sim
#quit -sim
#quit



