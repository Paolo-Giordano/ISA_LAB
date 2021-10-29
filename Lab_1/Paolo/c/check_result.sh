#!/bin/bash

rm check_result.o
rm check_result

gcc -c check_result.c
gcc check_result.o -o check_result
./check_result ../vhdl/sim/results.txt outputC.txt 

