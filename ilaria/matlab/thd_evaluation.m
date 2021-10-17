clear all

fp=fopen('../lab1_c/lab1_c/output_c.txt','r');

samples=fscanf(fp, '%d\n');
thd_res=thd(samples)

fclose(fp);