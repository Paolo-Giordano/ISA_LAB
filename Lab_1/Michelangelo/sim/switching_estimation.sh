#!/bin/bash

rm -r ./work
rm results.txt
rm transcript 
rm vsim.wlf
rm ../vcd/myfir_syn.vcd 

source /software/scripts/init_msim6.2g

vlib work

vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/data_*
vlog -work ./work ../netlist/*.v
vlog -work ./work ../tb/*.v

vsim -c -do simulation2.do

echo "Difference between model results(c) and UUT:"
diff ./results.txt ../c/resultc.txt
