#!/bin/bash

rm -rf ./work
rm results.txt

source /software/scripts/init_msim6.2g

vsim -c -do simulation.do 

../c/check_result.sh 
rm -rf ./work
rm -f transcript
rm -f vsim.wlf
