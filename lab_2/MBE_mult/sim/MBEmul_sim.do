vlib work

set RES ps
set SIM_FILE work.tb_mult
set SIM_TIME 900
set SIM_UNIT ns
set TOP_ENTITY tb_mult

vcom -93 -work ./work ../src/array_interface_pack.vhd
vcom -93 -work ./work ../src/constant_pack.vhd
vcom -93 -work ./work ../src/*.vhd
vcom -93 -work ./work ../tb/*.vhd
vlog -work ./work ../tb/$TOP_ENTITY.v

#simulation -- resolution
vsim -t $RES $SIM_FILE

add wave *


# run simulation
run $SIM_TIME $SIM_UNIT

# quit from sim
quit -sim
quit



