vlib work

set RES ps
set SIM_FILE work.tb_fir
set SIM_TIME 4
set SIM_UNIT us
set TOP_ENTITY tb_fir

vcom -93 -work ./work ../src/*
vcom -93 -work ./work ../tb/data_maker_new.vhd
vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/data_sink.vhd
vlog -work ./work ../tb/$TOP_ENTITY.v

#simulation -- resolution
vsim -t $RES $SIM_FILE

# toggle leaf name <-> full name
#config wave -signalnamewidth 1


# run simulation
run $SIM_TIME $SIM_UNIT

# quit from sim
quit -sim
quit



