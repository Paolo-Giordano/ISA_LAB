vlib work

set RES ps
set SIM_FILE work.tb_mult
set SIM_TIME 500
set SIM_UNIT ns
set TOP_ENTITY tb_mult

#compile also others src files!!!!!!
vcom -93 -work ./work ../src/MBEmul.vhd
vcom -93 -work ./work ../tb/*.vhd
vlog -work ./work ../tb/$TOP_ENTITY.v

#simulation -- resolution
vsim -t $RES $SIM_FILE

# run simulation
run $SIM_TIME $SIM_UNIT

# quit from sim
quit -sim
quit



