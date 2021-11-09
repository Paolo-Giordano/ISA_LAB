vlib work

set RES ps
set SIM_FILE work.tb_fpmult
set SIM_TIME 500
set SIM_UNIT ns
set TOP_ENTITY tb_fpmult

#compile in order cause every stage and final pipeline choose an architecture from work folder
vcom -93 -work ./work ../src/*pack*.vhd
vcom -93 -work ./work ../src/*round*.vhd
vcom -93 -work ./work ../src/*normalize*.vhd
vcom -93 -work ./work ../src/*stage*.vhd
vcom -93 -work ./work ../src/fpmul_pipeline.vhd
vcom -93 -work ./work ../tb/*.vhd
vlog -work ./work ../tb/$TOP_ENTITY.v

#simulation -- resolution
vsim -t $RES $SIM_FILE

# run simulation
run $SIM_TIME $SIM_UNIT

# quit from sim
quit -sim
quit



