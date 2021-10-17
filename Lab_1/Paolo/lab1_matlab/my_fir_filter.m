clc
clear all
close all

fs=10000; %% sampling frequency
f1=500;  %% first sinewave freq (in band)
f2=4500; %% second sinnewave freq (out band)

N=10; %% filter order
nb=9; %% number of bits

T=1/500; %% maximum period
tt=0:1/fs:10*T; %% time samples


x1=sin(2*pi*f1*tt); %% first sinewave
x2=sin(2*pi*f2*tt); %% second sinewave
r = randi([0,1],1,1000);
x=(x1+x2)/2; %% input signal
%x = [255,255,255,-256,-256,-256,-256,-256,255,255,255];
[bi, bq]=myfir_design(N, nb); %% filter design

y=filter(bq, 1, x); %% apply filter

%% plots
figure
%plot(tt,x1,'--d');
hold on
%plot(tt,x2,'r--s');
plot(tt,x, 'g--+');
plot(tt, y, 'c--o');

legend('x', 'y')

%% quantize input and output
xq=floor(x*2^(nb-1));
idx=find(xq==2^(nb-1));
xq(idx)=2^(nb-1)-1;

yq=floor(y*2^(nb-1));
idy=find(yq==2^(nb-1));
yq(idy)=2^(nb-1)-1;

%% save input and output
fp=fopen('samples.txt','w');
%%for vin, generate random value 0 with probability 10% and 1 with 90%
r1 = rand(1,201);
vin = zeros(1,201);
for i = 1:1:length(xq)
    if r1(i) > 0.9
        vin = 0;
    else
        vin = 1;
    end 
    fprintf(fp,'%d %d\n', xq(i), vin);
end 



fclose(fp);

fp=fopen('resultsm.txt', 'w');
fprintf(fp, '%s\n', yq);
fclose(fp);
