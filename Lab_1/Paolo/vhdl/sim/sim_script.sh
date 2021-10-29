#!/bin/bash

#remove work folder and other files
rm -r ./work
rm results.txt transcipt vsim.wlf

#initialize Modelsim
source /software/scripts/init_msim6.2g

#create work folder
vlib work

#compile
vcom -93 -work ./work ../src/*.vhd
vcom -93 -work ./work ../tb/*.vhd
vlog -work ./work ../tb/*.v

#simulate script
vsim -c -do simulation.do

#check result 
diff ./results.txt ./../../c/outputC.txt

