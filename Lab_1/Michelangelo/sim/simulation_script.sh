#!/bin/bash

rm -r ./work
rm results.txt
rm transcript 
rm vsim.wlf

source /software/scripts/init_msim6.2g

vlib work

vcom -93 -work ./work ../src/*
vcom -93 -work ./work ../tb/*.vhd
vlog -work ./work ../tb/*.v

vsim -c -do simulation.do

echo "Difference between model results(c) and UUT:"
diff ./results.txt ../c/resultc.txt
