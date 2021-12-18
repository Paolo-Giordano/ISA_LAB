vlib work

set RES ns
set SIM_FILE work.tb_mult
set SIM_TIME 500
set SIM_UNIT ns
set TOP_ENTITY tb_mult

#compile in order cause every stage and final pipeline choose an architecture from work folder
vcom -93 -work ./work ../src/*pack*.vhd
vcom -93 -work ./work ../src/*round*.vhd
vcom -93 -work ./work ../src/*normalize*.vhd
vcom -93 -work ./work ../src/constant_pack.vhd
vcom -93 -work ./work ../src/array_interface_pack.vhd
vcom -93 -work ./work ../src/RecodingLogic.vhd
vcom -93 -work ./work ../src/mux8to1.vhd
vcom -93 -work ./work ../src/PPunit.vhd
vcom -93 -work ./work ../src/HA.vhd
vcom -93 -work ./work ../src/FA.vhd
vcom -93 -work ./work ../src/dadda_tree_32.vhd
vcom -93 -work ./work ../src/MBEmult.vhd
vcom -93 -work ./work ../src/ADDER_NBIT.vhd

vcom -93 -work ./work ../src/*stage*.vhd
vcom -93 -work ./work ../src/fpmul_pipeline.vhd

vcom -work ./work ../tb/*.vhd
vlog -work ./work ../tb/$TOP_ENTITY.v

#simulation -- resolution
vsim -t $RES $SIM_FILE

#add wave *

# run simulation
run $SIM_TIME $SIM_UNIT

# quit from sim
quit -sim
quit



