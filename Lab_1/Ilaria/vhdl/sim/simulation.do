vlib work

set RES ps
set SIM_FILE work.tb_fir
set SIM_TIME 4
set SIM_UNIT us


#compilation 
project open MYFIR.mpf
project compileall

#simulation -- resolution
vsim -t $RES $SIM_FILE

# toggle leaf name <-> full name
#config wave -signalnamewidth 1


# run simulation
run $SIM_TIME $SIM_UNIT

# quit from sim
quit -sim
quit



