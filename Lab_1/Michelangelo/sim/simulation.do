#
# simulation of MYFIR
# Script to simulate only
#

#variabili fisse (better to do another script for variable?)
set RES ps
set SIM_FILE work.tb_FLOAT_TO_INT_sync
#set PROJECT_FILE floatToInt.mpf

set SIM_TIME 900
set SIM_UNIT ns

#compilation (trucchetto)
project open floatToInt.mpf
project compileall

#simulation -- resolution
vsim -t $RES $SIM_FILE

# toggle leaf name <-> full name
#config wave -signalnamewidth 1

# all wave selected (we don't really need)
#add wave *

# run simulation
run $SIM_TIME $SIM_UNIT

# quit from sim
quit -sim
quit