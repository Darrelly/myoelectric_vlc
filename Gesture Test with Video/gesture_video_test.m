% Animated plot of sEMG signals in real time
% Description: This script plots sEMG signals recorded by MyoWare sensors
% in real-time. The purpose of this script was visualize how changes in
% hand gestures affected the sEMG signals.
% Created By: Darrell Huang
% Date: 
% Edited:
%% Initialize connection to Arduino
a = arduino('/dev/cu.usbmodem1461', 'uno')

%% Reading Voltage (Test)
clc;
readVoltage(a,'A1')
readVoltage(a,'A2')
readVoltage(a,'A3')
readVoltage(a,'A4')

%% Stream Data
testname = "test3";
locations = [1 2 3 4];
voltage_1 = [];
voltage_2 = [];
voltage_3 = [];
voltage_4 = [];
t_1 = [];
t_2 = [];
t_3 = [];
t_4 = [];
i = 0;

total_time = 30; % 150;
tic
while toc < total_time;
    i = i + 1;
    voltage_1(i) = readVoltage(a,'A1'); 
    t_1(i) = toc;
    voltage_2(i) = readVoltage(a,'A2');
    t_2(i) = toc;  
    voltage_3(i) = readVoltage(a,'A3');
    t_3(i) = toc;
    voltage_4(i) = readVoltage(a,'A4');
    t_4(i) = toc;
    display(toc)
end

%% Save File, Calculate Sample Rate
filename = strcat(testname, '.mat')
save(filename, 't_1','voltage_1', 't_2','voltage_2', 't_3','voltage_3', 't_4','voltage_4')
fprintf('Acqured data for %s \n', testname)

sampleRate(t_1)
sampleRate(t_2)
sampleRate(t_3)
sampleRate(t_4)

%% Plotting Signals Together
load test1_15hz.mat
figure;
plot(t_1,voltage_1)
hold on
plot(t_2,voltage_2)
plot(t_3,voltage_3)
plot(t_4,voltage_4)

legend('1','2','3','4')

%% Subplots of Signals
subplot(4,1,1)
plot(t_1,voltage_1)
hold on
title('Position 1')

subplot(4,1,2)
plot(t_2,voltage_2)
title('Position 2')

subplot(4,1,3)
plot(t_3,voltage_3)
title('Position 3')

subplot(4,1,4)
plot(t_4,voltage_4)
title('Position 4')




%% Below are animated plots for specific tests
%
%
%
%
%
%% Animated Plot Test 1
clear all; clc; close all;
load test1_15hz.mat
%r = rateControl(15);
h1 = animatedline('Color','#0072BD');
h2 = animatedline('Color','#D95319');
h3 = animatedline('Color','#FFD700');
h4 = animatedline('Color','#7E2F8E');
legend('1','2','3','4', 'AutoUpdate', 'off')
axis([0,t_4(end),0,6])
title('Myoelectric Signal Capture Test 1');
xlh = xlabel('Time (sec)');
ylh = ylabel('Voltage (V)');
set(gca,'FontSize',15)
xticks(0:5:60)
ylh.Position(1) = ylh.Position(1) - 0.1;
xlh.Position(2) = xlh.Position(2) - 0.1;
%time(1)=0;
for i = 1:size(t_4,2)
    %time(i+1) = r.TotalElapsedTime;
    addpoints(h1,t_1(i),voltage_1(i));
    addpoints(h2,t_2(i),voltage_2(i));
    addpoints(h3,t_3(i),voltage_3(i));
    addpoints(h4,t_4(i),voltage_4(i));
    %fprintf('Frequency: %f\n',1/(time(i+1) - time(i)));
    %waitfor(r);
end
xline(5, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(11.5, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(17, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(23, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(29, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(34, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(40, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(44, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(49, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(55, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
%% Animated Plot Test 2
clear all; clc; close all;
load test2_15hz.mat
%r = rateControl(15);
h1 = animatedline('Color','#0072BD');
h2 = animatedline('Color','#D95319');
h3 = animatedline('Color','#FFD700');
h4 = animatedline('Color','#7E2F8E');
legend('1','2','3','4', 'AutoUpdate', 'off')
axis([0,t_4(end),0,6])
xlabel('Time (sec)')
ylabel('Voltage (V)')
%time(1)=0;
for i = 1:size(t_4,2)
    %time(i+1) = r.TotalElapsedTime;
    addpoints(h1,t_1(i),voltage_1(i));
    addpoints(h2,t_2(i),voltage_2(i));
    addpoints(h3,t_3(i),voltage_3(i));
    addpoints(h4,t_4(i),voltage_4(i));
    %fprintf('Frequency: %f\n',1/(time(i+1) - time(i)));
    %waitfor(r);
end
xline(7, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(13, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(19, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(25, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(31, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(36, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(42, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(46.5, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(51, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(57, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')

%% Animated Plot Test 3
clear all; clc; close all;
load test3_14hz.mat
%r = rateControl(15);
h1 = animatedline('Color','#0072BD');
h2 = animatedline('Color','#D95319');
h3 = animatedline('Color','#FFD700');
h4 = animatedline('Color','#7E2F8E');
legend('1','2','3','4', 'AutoUpdate', 'off')
axis([0,t_4(end),0,6])
xlabel('Time (sec)')
ylabel('Voltage (V)')
%time(1)=0;
for i = 1:size(t_4,2)
    %time(i+1) = r.TotalElapsedTime;
    addpoints(h1,t_1(i),voltage_1(i));
    addpoints(h2,t_2(i),voltage_2(i));
    addpoints(h3,t_3(i),voltage_3(i));
    addpoints(h4,t_4(i),voltage_4(i));
    %fprintf('Frequency: %f\n',1/(time(i+1) - time(i)));
    %waitfor(r);
end
xline(7, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(13, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(19, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(25, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(31, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(36, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(41.5, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(46.5, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(51.5, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')
xline(57, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', '')





%% Below are LDA Classification tests for specific tests
%% LDA Classification for test1
load 'test1_15hz.mat';

movements = {'forward', 'backward'};

% Forward
forward_begin = 1; % forward gesture began at 1 second
forward_end = 5; % forward gesture ended at 5 seconds

forward_t_1 = t_1((t_1 > forward_begin) & (t_1 < forward_end));
forward_begin = find(t_1==min(forward_t_1));
forward_end = find(t_1==max(forward_t_1));
forward_t_1_voltage = voltage_1(forward_begin:forward_end);

forward_t_2_voltage = voltage_2(forward_begin:forward_end);

forward_t_3_voltage = voltage_3(forward_begin:forward_end);

forward_t_4_voltage = voltage_4(forward_begin:forward_end);

measurements = [forward_t_1_voltage' forward_t_2_voltage' forward_t_3_voltage' forward_t_4_voltage'];
movements = repelem({'forward'},forward_end-forward_begin+1,1)

% Backward
backward_begin = 6;
backward_end = 11.5;

backward_t_1 = t_1((t_1 > backward_begin) & (t_1 < backward_end));
backward_begin = find(t_1==min(backward_t_1));
backward_end = find(t_1==max(backward_t_1));
backward_t_1_voltage = voltage_1(backward_begin:backward_end);

backward_t_2_voltage = voltage_2(backward_begin:backward_end);

backward_t_3_voltage = voltage_3(backward_begin:backward_end);

backward_t_4_voltage = voltage_4(backward_begin:backward_end);

measurements = [measurements; backward_t_1_voltage' backward_t_2_voltage' backward_t_3_voltage' backward_t_4_voltage'];
movements = [movements; repelem({'backward'},backward_end-backward_begin+1,1)]

MdlLinear = fitcdiscr(measurements, movements)




% Turn Left
left_begin = 12.5;
left_end = 17;

% Turn Right
right_begin = 18;
right_end = 23;


% Stop
stop_begin = 24;
stop_begin = 29;
