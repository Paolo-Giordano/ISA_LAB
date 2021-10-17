#!/bin/bash

rm myfilter.o
rm myfilter

gcc -c myfilter.c
gcc myfilter.o -o myfilter
./myfilter ../../matlab/samples.txt output_c.txt 1 ../../lab1_vhdl/sim/results.txt 

