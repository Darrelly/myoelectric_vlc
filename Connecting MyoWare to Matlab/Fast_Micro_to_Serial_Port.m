%% Serial Port - Direct Wired Connection to Micro
clc; clear; 

arduinoObj = serialport('/dev/cu.usbmodem14401',500000)
flush(arduinoObj);
data = strings([5000 1]);
tic
for i=1:5000
    data(i) = readline(arduinoObj);
end
freq = 5000/toc
% 
%% Parse Data 
for ind = 1:size(data,1)
    data(ind) = data{ind}(:,2:end-1);
end

% Ensure data string is complete 
delimiters = 4;
n = size(data,1);
while ind <= n
    if (length(strfind(data(ind),',')) ~= delimiters-1)
        data(ind) = [];
        t(ind) = [];
        n = size(data,1);
    else
        ind = ind + 1;
    end
end
    
data = split(data,',');
data = double(data);
%% Plot Data
voltage_1 = data(:,1);
voltage_2 = data(:,2);
voltage_3 = data(:,3);
voltage_4 = data(:,4);
figure;
plot(voltage_1); hold on;
plot(voltage_2);
plot(voltage_3);
plot(voltage_4);
hold off;
title('sEMG Sensors')
legend('1','2','3','4')