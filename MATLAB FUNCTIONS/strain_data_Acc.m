function [strain_data,acc_data_1kHz,time_stamps,push10hz] = strain_data_Acc(file)

% This code will unpack AIM data from file into 'AIM_data'
% To run a demo, place 'demo.csv' and 'unpack_AIM_data.m' in the same
% folder and run 
%       AIM_data = strain_data_Acc('sub3_0_2018_06_20_11_32.csv');
% Output:
%         AIM_data: col 1: strain sensor
%                   col 2: proximity data
%                   col 3: push button
%                   col 4: accelerometer: x-axis
%                   col 5: accelerometer: y-axis
%                   col 6: accelerometer: z-axis
% All output signal were resampled to 1000Hz

% Read csv file
data = csvread(file);

% Get strain sensor data
s_data = data(:,2:101);
strain_data = reshape(s_data',1,numel(s_data));
clear s_data

% Get proximity data
prox1 = data(:,132);
% Get push button data
push1 = data(:,134);
push10hz=push1;

% Get accelerometer data
x_data = data(:,102:111);
y_data = data(:,112:121);
z_data = data(:,122:131);
acc_data.x = reshape(x_data',1,numel(x_data));
acc_data.y = reshape(y_data',1,numel(y_data));
acc_data.z = reshape(z_data',1,numel(z_data));

% Get time stamps and look for possibe data loss
time_stamps = data(:,1);
time_stamp_diff1 = diff(data(:,1));

clear data

% Resample all data to 1000Hz
% Proximity (original fs = 10Hz)
prox = repmat(prox1,1,100);
prox = reshape(prox',1,numel(prox));

% Push (original fs = 10Hz)
push = repmat(push1,1,100);
push = reshape(push',1,numel(push));

% Accelerometer (original fs = 100Hz)
acc_x = repmat(acc_data.x,10,1);
acc_x = reshape(acc_x,1,numel(acc_x));
acc_y = repmat(acc_data.y,10,1);
acc_y = reshape(acc_y,1,numel(acc_y));
acc_z = repmat(acc_data.z,10,1);
acc_z = reshape(acc_z,1,numel(acc_z));

% figure(1)
% subplot(3,1,1)
% plot(strain_data); legend('Strain sensor'); xlabel('Samples')
% subplot(3,1,2)
% plot(prox,'g'); legend('Proximity sensor'); xlabel('Samples')
% subplot(9,1,7)
% plot(acc_x,'m'); legend('Accel - x'); xlabel('Samples')
% subplot(9,1,8)
% plot(acc_y,'m'); legend('Accel - y'); xlabel('Samples')
% subplot(9,1,9)
% plot(acc_z,'m'); legend('Accel - z'); xlabel('Samples')

strain_data = [strain_data' prox' push'];
acc_data_1kHz = [acc_x' acc_y' acc_z']; 

end

