#!/bin/bash

rm -rf ./work
rm results.txt


source /software/scripts/init_msim6.2g


vsim -c -do simulation_firopt.do

../../c/check_result.sh 1

rm -rf ./work
rm -f transcript
rm -f vsim.wlf
