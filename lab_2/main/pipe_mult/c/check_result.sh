#!/bin/bash


gcc -c ../c/check_result.c
gcc check_result.o -o check_result

./check_result results.txt fp_prod.hex

rm -f check_result.o
rm -f check_result






