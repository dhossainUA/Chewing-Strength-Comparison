%this script load the raw emg signal
%normalize the signal
%truncate manually carrot, apple, banana eating signal
%truncate first five chews of each bite 
%input: RAW EMG mat file
%output: Processed signal: pressure_carrot_subxx (contain 10 cell for 10 bites),
%pressure_apple_subxx (contain 10 cell for 10 bites), pressure_banana_subxx (contain 10 cell for 10 bites)

clc;clear all;close all;
p=cell2mat(struct2cell(load ('PRESSURE_SUB01.mat')));
ts = (0:numel(p)-1)/128;
figure;
plot(ts,p);
title('EMG Response');
xlabel('Time (Sec)')
ylabel('EMG response');

%%
filt=designfilt('lowpassiir', 'PassbandFrequency', 2.7, 'StopbandFrequency', 3, 'PassbandRipple', 1, 'StopbandAttenuation', 60, 'SampleRate', 128);
press=filtfilt(filt,p);
press= rmoutliers(press);
[XNorm, mu, stddev] = featureNormalize(press); %normalize

%truncation of  apple, banana, and carrot (manually)
%confirm the food order from record
figure;
plot(XNorm)
[x,y]=ginput(6);
a=XNorm(x(1,1):x(2,1)); %apple
b=XNorm(x(3,1):x(4,1)); %banana
c=XNorm(x(5,1):x(6,1)); %carrot

%%
%truncation of first five chews for first 10 bites of apple
figure;
plot(a)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
A{1}=a(x11:x12);

plot(a)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
A{2}=a(x11:x12);

plot(a)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
A{3}=a(x11:x12);

plot(a)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
A{4}=a(x11:x12);

plot(a)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
A{5}=a(x11:x12);

plot(a)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
A{6}=a(x11:x12);


plot(a)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
A{7}=a(x11:x12);

plot(a)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
A{8}=a(x11:x12);

plot(a)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
A{9}=a(x11:x12);

plot(a)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
A{10}=a(x11:x12);

save('pressure_apple_sub01.mat','A') %change filename

%%

%%
%truncation of first five chews for first 10 bites of carrot
figure;
plot(c)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
C{1}=c(x11:x12);


plot(c)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
C{2}=c(x11:x12);

plot(c)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
C{3}=c(x11:x12);

plot(c)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
C{4}=c(x11:x12);

plot(c)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
C{5}=c(x11:x12);

plot(c)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
C{6}=c(x11:x12);


plot(c)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
C{7}=c(x11:x12);

plot(c)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
C{8}=c(x11:x12);

plot(c)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
C{9}=c(x11:x12);

plot(c)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
C{10}=c(x11:x12);
save('pressure_carrot_sub01.mat','C')

%%

%%
%truncation of first five chews for first 10 bites of Banana
figure;
plot(b)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
B{1}=b(x11:x12);


plot(b)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
B{2}=b(x11:x12);

plot(b)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
B{3}=b(x11:x12);

plot(b)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
B{4}=b(x11:x12);

plot(b)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
B{5}=b(x11:x12);

plot(b)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
B{6}=b(x11:x12);


plot(b)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
B{7}=b(x11:x12);

plot(b)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
B{8}=b(x11:x12);

plot(b)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
B{9}=b(x11:x12);

plot(b)
x1=ginput();
x11=x1(1,1);
x12=x1(2,1);
B{10}=b(x11:x12);
save('pressure_banana_sub01.mat','B')


