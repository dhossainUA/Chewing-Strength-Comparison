% Instruction: Put the .BIN file and MATLAB code in same folder and
% Change the file name in line 12 accordingly

clear all; clc;
close all;
fs = 128;   % Sampling Frequency
Folder = 'Output_Data';
folder = fullfile(pwd, Folder);%Save results
if(~isdir(folder))
    mkdir(folder);
end

% Filename is in Unix timestamp Format
FileName = '5B3019E6.BIN';  % Change the filename accordingly

fileID = fopen(FileName);
data = uint8(fread(fileID));
s = whos('data');
Nbytes = s.bytes;
SDCard_ByteSize = 8192*2; % 16 KB Buffer
NWrites_SDCard = Nbytes/SDCard_ByteSize;
NSamples_data = 2046;  % Number of samples per buffer (previous 906)

%% Code to check timestamp of stored data
% FileNameDemo = FileName;
% index = find(FileNameDemo=='.');
% FileNameDemo (index:end) = [];
% DataEndTime=datestr( datetime( hex2dec(FileNameDemo), 'ConvertFrom', 'posixtime' ));
% fprintf('Data Collected till:  %s\n',DataEndTime);

%%
fprintf('File contains %d bytes, %d writes to SD card\n\n', Nbytes, NWrites_SDCard);
fprintf('Total samples data: %d\n', NSamples_data*NWrites_SDCard);

t_data = NSamples_data*NWrites_SDCard*(1/fs);
hours = floor(t_data / 3600);
t_data = t_data - hours * 3600;
mins = floor(t_data / 60);
secs = t_data - mins * 60;
fprintf('Total time recorded data: %d:%d:%0.2f\n',hours, mins, secs);

%Extract Device Timestamp from saved value
AIM_Date = zeros(NWrites_SDCard,4);
AIM_Time = zeros(NWrites_SDCard,4);

%Data
AIM_Data = zeros(NSamples_data*NWrites_SDCard,5);

for write=1:NWrites_SDCard
    fprintf('Memory Block %d -> %d to %d, ',write, SDCard_ByteSize*(write-1)+1, SDCard_ByteSize*write);

    x = data(SDCard_ByteSize*(write-1)+1:SDCard_ByteSize*write);
    s = whos('x');
    Nbytes = s.bytes;
    fprintf('%d bytes\n', Nbytes);

    %Subsec (MiliSecond) data
    s0 = 1;         % Starting 'Byte Number' in Memory 
    sf = s0 + 1-1;  % Ending 'Byte Number' in Memory 
%   orignial Format : [s0 sf]
    SubsecBytes = x(s0:sf)'; % converted  in column
    ms = 1000-(double(SubsecBytes)*1000/256);
    
        %Blank data
        s0 = sf + 1;
        sf = s0 + 7-1;   % 7 Blank Padding data
        BlankBytes = x(s0:sf)';
        
%     %PushButton Data
%     s0 = sf+1;
%     sf = s0 + NSamples_data*1-1;
% %     [s0 sf]
%     PBBytes = x(s0:sf)';
%                 aux = [];
%        for i=1:2:numel(SensorBytes)
%            aux = [aux;SensorBytes(i:i+1)];
%        end
%        SensorBytes = aux;   
%     for k=1:size(PBBytes,1)
%         AIM_Data(k+(write-1)*NSamples_data,5) = double(typecast(uint8(PBBytes(k,:)), 'uint8'));
%     end   
                    
    %Pressure Sensor Data
    s0 = sf+1;
    sf = s0 + NSamples_data*2-1;
%   orignial Format : [s0 sf]
    SensorBytes = x(s0:sf)';
            aux = [];
        for i=1:2:numel(SensorBytes)
            aux = [aux;SensorBytes(i:i+1)];
        end
        SensorBytes = aux;    
    for k=1:size(SensorBytes,1)
        AIM_Data(k+(write-1)*NSamples_data,1) = double(typecast(uint8(SensorBytes(k,:)), 'uint16'));
    end   
    
    %AccX data
    s0 = sf+1;
    sf = s0 + NSamples_data*2-1;
%   orignial Format : [s0 sf]
    AccXBytes = x(s0:sf)';
   aux = [];
        for i=1:2:numel(AccXBytes)
            aux = [aux;AccXBytes(i:i+1)];
        end
        AccXBytes = aux;
    for k=1:size(AccXBytes,1)
        AIM_Data(k+(write-1)*NSamples_data,2) = double(typecast(uint8(AccXBytes(k,:)), 'int16'));
    end
    
    %AccY data
    s0 = sf+1;
    sf = s0 + NSamples_data*2-1;
%   orignial Format : [s0 sf]
    AccYBytes = x(s0:sf)';
         aux = [];
        for i=1:2:numel(AccYBytes)
            aux = [aux;AccYBytes(i:i+1)];
        end
        AccYBytes = aux;
    for k=1:size(AccYBytes,1)
        AIM_Data(k+(write-1)*NSamples_data,3) = double(typecast(uint8(AccYBytes(k,:)), 'int16'));
    end
    
    %AccZ data
    s0 = sf+1;
    sf = s0 + NSamples_data*2-1;
%   orignial Format : [s0 sf]
    AccZBytes = x(s0:sf)';
          aux = [];
        for i=1:2:numel(AccZBytes)
            aux = [aux;AccZBytes(i:i+1)];
        end
        AccZBytes = aux;
    for k=1:size(AccZBytes,1)
        AIM_Data(k+(write-1)*NSamples_data,4) = double(typecast(uint8(AccZBytes(k,:)), 'int16'));
    end

%Time data
%     s0 = sf + 1;
%     sf = s0 + 4-1;
% %   orignial Format : [s0 sf]
%     TimeBytes = x(s0:sf)';
%     Time = typecast(uint8(TimeBytes), 'uint32');
%     mask = bitor(uint32(3145728),uint32(983040));
%     hour = double(bitsra(bitand(Time,mask),16));
%     mask = bitor(uint32(28672),uint32(3840));
%     min = double(bitsra(bitand(Time,mask),8));
%     mask = bitor(uint32(112),uint32(15));
%     sec = double(bitand(Time,mask));
%     AIM_Time(write,:) = [hour, min, sec, ms];
%     
%     
% %Date data
%     s0 = sf + 1;
%     sf = s0 + 4-1;
% %   orignial Format : [s0 sf]
%     DateBytes = x(s0:sf)';
%     Date = typecast(uint8(DateBytes), 'uint32');
%     mask = bitor(uint32(15728640),uint32(983040));
%     year = double(bitsra(bitand(Date,mask),16));
%     mask = bitor(uint32(4096),uint32(3840));
%     month = double(bitsra(bitand(Date,mask),8));
%     mask = bitor(uint32(48),uint32(15));
%     day = double(bitand(Date,mask));
%     week_day = double(bitsra(bitand(Date,uint32(57344)),13));
%     AIM_Date(write,:) = [year, month, day, week_day];  
end



%Convert hour, miute, sec to readable values
% for i=1:3
%     x = AIM_Time(:,i);
%     value = uint8(x);
%     tmp = bitsra(bitand(value,uint8(240)),uint8(4))*10;
%     R = tmp + bitand(value,uint8(15));
%     AIM_Time(:,i) = double(R);
% end

%Convert year, month, and day to readable values
% for i=1:3
%     x = AIM_Date(:,i);
%     value = uint8(x);
%     tmp = bitsra(bitand(value,uint8(240)),uint8(4))*10;
%     R = tmp + bitand(value,uint8(15));
%     AIM_Date(:,i) = double(R);
% 
% end

fclose(fileID);
index = find(FileName=='.');
FileName(index+1:end) = 'mat';
file = fullfile(Folder,FileName);
save(file,'AIM_Date','AIM_Time','AIM_Data');

fig = 0;
% Deleting First few samples(There might be some spikes because of USB cable)
AIM_Data(1,:) = AIM_Data(3,:);
AIM_Data(2,:) = AIM_Data(3,:);

%% Plotting Pressure Sensor Values
fig = fig + 1;
figure(fig);

%Conversions
bend = AIM_Data(:,1);
%PressureData = AIM_Data(:,1); %Pressure Sensor original data
ts = (0:numel(bend)-1)/fs;
subplot(2,1,1);
plot(ts,bend); 
axis tight;
title('AIM BEND Sensor Responses standalone');
xlabel('Time(sec)');
ylabel('ADC');


%% Plotting PB
% fig = fig + 1;
% figure(fig);
% x = AIM_Data(:,5); %ADC
% ts = (0:numel(x)-1)/fs;
% 
% plot(ts,x); 
% title('PB States');
% xlabel('Time(sec)');
% ylabel('Digiatl_Value 0/1');
% axis([ts(1),ts(end),0,2]);

%% Plotting ACC

x = AIM_Data(:,2); %Accerelometer X data
y = AIM_Data(:,3); %Accerelometer Y data
z = AIM_Data(:,4); %Accerelometer Z data
ts = (0:numel(x)-1)/fs;

%Convert to gravitational (g) units from ADC units
gRange = 4;
adcBits = 12;
factor = gRange/(2^adcBits);
x = x*factor;
y = y*factor;
z = z*factor;

%fig = fig + 1;
%figure(fig);
subplot(2,1,2);
plot(ts,x,'k'); 
hold on;
plot(ts,y,'r'); 
plot(ts,z,'b'); 
xlabel('Time(sec)');
axis tight;
ylabel('Acceleration (g)');
legend('X','Y','Z');
title('AIM Accelerometer Signals');
legend('X','Y','Z');
title('AIM Accelerometer Signals');

%% save bend data
save('BEND_SUB11.mat','bend');

