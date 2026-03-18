clc;clear all;close all;
addpath('Chewing_Strength_Final') 
e=dlmread('opensignals_98D331B2C165_2018-06-24_17-02-46.txt'); %change the filename
f=e(:,6);
ts = (0:numel(f)-1)/1000;
figure;
plot(ts,f);
title('EMG Response');
xlabel('Time (Sec)')
ylabel('EMG response');
save('EMG_SUB15','f'); %change the filename
