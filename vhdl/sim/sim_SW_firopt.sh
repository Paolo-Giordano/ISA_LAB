#!/bin/bash

#remove work folder and other files
rm -rf ./work
rm -f results.txt transcipt vsim.wlf

#initialize Modelsim
source /software/scripts/init_msim6.2g

#create work folder
vlib work

#simulate script
vsim -c -do record_SW_firopt.do



