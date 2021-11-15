#!/bin/bash

rm -rf ./work
rm *.txt

source /software/scripts/init_msim6.2g

python3 ../python/suite_test.py 0

vsim -c -do MBEmul_sim.do

python3 ../python/suite_test.py 1

#../c/check_result.sh 
rm -rf ./work
rm -f transcript
rm -f vsim.wlf
