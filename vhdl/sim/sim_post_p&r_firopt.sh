#!/bin/bash

#remove work folder and other files
rm -r ./work
rm results.txt transcipt vsim.wlf

#initialize Modelsim
source /software/scripts/init_msim6.2g

#simulate script
vsim -c -do postP\&Rsim_firopt.do



