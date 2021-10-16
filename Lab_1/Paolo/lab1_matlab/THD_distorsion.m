%% Total harmonic distorsion

clear all
close all

fp1=fopen('resultsm.txt', 'r');
fp2=fopen('outputC.txt', 'r');

formatSpec = '%d';
y_m = fscanf(fp1, formatSpec);
y_C = fscanf(fp2, formatSpec);

r_m=thd(y_m);
r_c=thd(y_C);
