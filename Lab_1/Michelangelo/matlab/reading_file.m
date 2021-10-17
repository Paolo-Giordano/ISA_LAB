clc
clear all
close all

fp=fopen('../C/filter_model/resultsc.txt', 'r');
y = fscanf(fp,"%d");   
fclose(fp);
thd(y)
