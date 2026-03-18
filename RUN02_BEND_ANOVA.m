%%  ******* ANOVA ANALYSIS OF BEND SENSOR *********
% This script takes input as the processed bend sensor signal for every participant
% For each participant: bend_apple_subx, bend_banana_subx, bend_carrot_sub
% each mat file contains first five chews of a bite in a cell. 10 bite for each foood item
% calculates std for each bite
% ANOVA test
% Post-hoc Tukey's test if null hypotheis rejected

clc;clear;close all;
addpath ('Chewing_Strength_Final')
addpath(genpath(pwd));
y=[];
for ii = 1:15 % subjects processed data input file
 A=importdata (['bend_apple_sub' num2str(ii) '.mat']); %file contains pressure and pushbutton_data
  B=importdata (['bend_banana_sub' num2str(ii) '.mat']); %file contains pressure and pushbutton_data
   C=importdata (['bend_carrot_sub' num2str(ii) '.mat']); %file contains pressure and pushbutton_data
 
 for i=1:10
    s_a(i)=std(A{i}); %calculate std for apple
    s_b(i)=std(B{i}); %calculate std for banana
    s_c(i)=std(C{i}); %calculate  std for carrot 
    idx=1;
    idx=idx+1;
 end
 sa_dev{ii}=s_a;
 sb_dev{ii}=s_b;
 sc_dev{ii}=s_c;
end

SA=cell2mat(sa_dev)';
SB=cell2mat(sb_dev)';
SC=cell2mat(sc_dev)';
s_dev=[SC,SA,SB];

%% plot of the standard deviations for different foods 
figure;
plot(SC,'r','LineWidth',1);
hold on;
plot(SA,'g','LineWidth',1);
hold on;
plot(SB,'b','LineWidth',1);
legend('carrot','apple','banana');
xlabel(' Observation points')
ylabel('std');
title('Varitaion of std for different foods')

%% ANOVA Analysis
[~,~,stats]=anova1(s_dev);
boxplot(s_dev,'Labels',{'Carrot','Apple','Banana'})
title('Box plot of Flex data')

%% Post-hoc Tukey's test
n={'Carrot','Apple','Banana'};
[~,~,stats]=anova1(s_dev,n);
r=multcompare(stats,'alpha',.05,'ctype','hsd');

