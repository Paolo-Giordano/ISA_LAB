#!/bin/bash


gcc -c ../../c/myfilter.c 
gcc myfilter.o -o myfilter
./myfilter ../../matlab/samples.txt ../../c/outputC.txt 

gcc -c ../../c/check_result.c
gcc check_result.o -o check_result
./check_result results.txt ../../c/outputC.txt $1

rm -f check_result.o
rm -f check_result
rm -f myfilter.o
rm -f myfilter





