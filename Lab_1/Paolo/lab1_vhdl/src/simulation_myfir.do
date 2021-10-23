#
# simulation of filter.vhd
#

#variabili fisse 
set RES ps
set SIM_FILE work.tb_fir
set SIM_TIME 100
set SIM_UNIT us


#compilation (trucchetto)
project open tb_filter.mpf
project compileall

#simulation -- resolution
vsim -t $RES $SIM_FILE

# toggle leaf name <-> full name
config wave -signalnamewidth 1

# all wave selected (we don't really need)
add wave *

# run simulation
run $SIM_TIME $SIM_UNIT

# quit from sim
#quit -sim

