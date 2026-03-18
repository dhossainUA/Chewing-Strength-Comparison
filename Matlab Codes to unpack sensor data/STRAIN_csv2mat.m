%this script convert the raw strain data stored as csv file into mat file
AIM_data = strain_data_Acc('newsub1_0_2018_07_04_08_03.csv'); % change filename
s=AIM_data(:,1);
ts = (0:numel(s)-1)/1000;
figure;
plot(ts,s);
title('Strain Sensor Response');
xlabel('Time (Sec)')
ylabel('Strain response');
save('STRAIN_SUB01.mat','s'); %change filename