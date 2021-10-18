#!/bin/bash

rm myfilter.o
rm myfilter

gcc -c myfilter.c
gcc myfilter.o -o myfilter
./myfilter ../lab1_matlab/samples.txt output_c.txt ../lab1_vhdl/sim/results.txt

