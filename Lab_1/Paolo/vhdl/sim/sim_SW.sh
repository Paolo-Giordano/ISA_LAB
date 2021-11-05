#!/bin/bash

#remove work folder and other files
rm -r ./work
rm results.txt transcipt vsim.wlf

#initialize Modelsim
source /software/scripts/init_msim6.2g

#create work folder
vlib work

#simulate script
vsim -c -do record_SW.do



