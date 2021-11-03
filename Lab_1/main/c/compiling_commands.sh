#!/bin/bash

rm myfilter.o
rm myfilter

gcc -c myfilter.c
gcc myfilter.o -o myfilter
./myfilter ../matlab/samples.txt outputC.txt 

