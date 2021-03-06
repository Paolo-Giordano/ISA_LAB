
%% BE CAREFUL!
% if you run this file, the random sequence of vin will change and you will
% have to run again the C program and the vhdl to obtain coherent results

fs=10000; %% sampling frequency
f1=500;  %% first sinewave freq (in band)
f2=4500; %% second sinnewave freq (out band)
f3=1200; %% square root freq

p=1;
x_in=5;
y_in=8;
N=(2^p)*(mod(x_in,2)+1)+6*p; %% filter order
nb=mod(y_in,7)+8; %% number of bits

T=1/500; %% maximum period
tt=0:1/fs:10*T; %% time samples

x1=sin(2*pi*f1*tt); %% first sinewave
x2=sin(2*pi*f2*tt); %% second sinewave

%%%%    CHOOSE HERE between sinewave and worst case square wave  %%%%%%%
x=(x1+x2)/2; %% input signal
%x=square(2*pi*f3*tt,40);

[bi, bq]=myfir_design(N, nb); %% filter design

y=filter(bq, 1, x); %% apply filter

%% plots
figure
plot(tt,x1,'--d');
hold on
plot(tt,x2,'r--s');
plot(tt,x, 'g--+');
plot(tt, y, 'c--o');
xlabel('time [s]');
ylabel('amplitude');
legend('x1', 'x2', 'x', 'y')

%% quantize input and output
%moving to integer numbers represented on nb bits 
%x samples with value 1 can get overflow, so its corresponding value 
%is changed to 2^(nb-1)-1
%output range from -2^(nb-1) to 2^(nb-1)-1
xq=floor(x*2^(nb-1));
idx=find(xq==2^(nb-1));
xq(idx)=2^(nb-1)-1;

yq=floor(y*2^(nb-1));
idy=find(yq==2^(nb-1));
yq(idy)=2^(nb-1)-1;


%% save input and output
fp=fopen('samples.txt','w');

% CHANGE: matlab model generates VIN, its value is stored in the same line
% of DIN
% vin generated with '0' probability of 3% and '1'  of 97%
r1 = rand(1,length(xq));%array with values generated randomly in the range [0,1]
vin = zeros(1,length(xq));

%vin assumes the same value for 3 consecutive samples, this change is done
%to use the same C model to check the behavior of the filter with and without 
%unfolding with N=3
for i = 1:3:length(xq)
    if r1(i) > 0.97
        vin = 0;
    else
        vin = 1;
    end 
    fprintf(fp,'%d %d\n', xq(i), vin);
    fprintf(fp,'%d %d\n', xq(i+1), vin);
    fprintf(fp,'%d %d\n', xq(i+2), vin);
    
end ;

fp=fopen('resultsm.txt', 'w');
fprintf(fp, '%d\n', yq);
fclose(fp);


