%% Total harmonic distorsion and error
%the execution makes sense only if VIN is set always equal to 1
clear all
close all

p=1;
x_in=5;
y_in=8;
nb=mod(y_in,7)+8; %% number of bits

fp1 = fopen('./resultsm.txt', 'r');
fp2 = fopen('../c/outputC.txt','r');
fp3 = fopen('./samples.txt', 'r');

formatspec = '%d ';
samples_m = fscanf(fp1, formatspec);
samples_c = fscanf(fp2, formatspec);
vin = fscanf(fp3, '%*d %d\n');

%%calculate total harmonic distortion
thd_m=thd(samples_m);
thd_res=thd(samples_c);
thd_m=thd(samples_m)

%% error
valid_samples = 0;      %after the first 10 samples we have valid out

%take from matlab output only the data with vout valid
j=1;
for i = 1:1:length(vin)
    if(vin(i) == 1)
        valid_samples = valid_samples + 1;
    end
    
    if (valid_samples >= 11 && vin(i) == 1)
        mat_out_valid(j) = samples_m(i);
        j=j+1;
    end
end


%%relative error = |approx - exact| / Nbit 
for i = 1:1:length(samples_c)
    error(i) = abs(mat_out_valid(i) - samples_c(i)) / 2^(nb-1);
end
max_error = max(error)

plot( 1:1:length(samples_c), samples_c , 'r')
hold on
plot( 1:1:length(mat_out_valid), mat_out_valid , 'b--')
legend('C', 'm');


fclose(fp1);
fclose(fp2);
