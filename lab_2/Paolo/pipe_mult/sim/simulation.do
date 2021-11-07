vlib work

set RES ps
set SIM_FILE work.tb_mult
set SIM_TIME 4
set SIM_UNIT us
set TOP_ENTITY tb_mult

vcom -93 -work ./work ../src/*vhd
vcom -93 -work ./work ../tb/*.vhd
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



