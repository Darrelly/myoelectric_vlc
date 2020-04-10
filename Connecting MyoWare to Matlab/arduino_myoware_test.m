%% MyoWare Signal Analysis

%% Initialize connection to Arduino
% a = arduino('/dev/cu.usbmodem14401', 'micro')

%% Reading Voltage (Test)
clc;
readVoltage(a,'A1')
readVoltage(a,'A2')
readVoltage(a,'A3')
readVoltage(a,'A4')

%% Record Noise
% Initialize
voltage_1 = [];
voltage_2 = [];
voltage_3 = [];
voltage_4 = [];
t_1 = [];
t_2 = [];
t_3 = [];
t_4 = [];

tic
while toc < 10
    i = i + 1;
    voltage_1(i) = readVoltage(a,'A1');
    t_1(i) = toc;
    voltage_2(i) = readVoltage(a,'A2');
    t_2(i) = toc;
    voltage_3(i) = readVoltage(a,'A3');
    t_3(i) = toc;
    voltage_4(i) = readVoltage(a,'A4');
    t_4(i) = toc;
end

filename = strcat('noise', '.mat')
save(filename, 't_1','voltage_1', 't_2','voltage_2', 't_3','voltage_3', 't_4','voltage_4')
fprintf('Acqured data for %s \n', 'noise')

figure
plot(t_1,voltage_1)
figure
plot(t_2,voltage_2)
figure
plot(t_3,voltage_3)
figure
plot(t_4,voltage_4)
sampleRate(t_1)
sampleRate(t_2)
sampleRate(t_3)
sampleRate(t_4)

%% Stream Data (Test) 
t = [];
voltage = [];
i = 0;

tic
while toc < 10
    i = i + 1;
    voltage(i) = readVoltage(a,'A0');
    t(i) = toc;
end
plot(t,voltage)
sampleRate(t)
save 'test.mat' 't' 'voltage'

%% Stream Data (Visualize)
t = [];
voltage = [];
i = 0;
figure
hold on
h = animatedline;
tic
while toc < 10
    i = i + 1;
    voltage(i) = readVoltage(a,'A0');
    t(i) = toc;
    addpoints(h,t(i),voltage(i));
    drawnow    
end
sampleRate(t)

%% Stream Data (Experiment [Location, Gesture])
locations = [1 2 3 4];
gestures = ["relax", "extension", "flexion", "ulnar flexion", "radial flexion", "supination", "pronation", "open", "grasp"];
voltage_1 = [];
voltage_2 = [];
voltage_3 = [];
voltage_4 = [];
t_1 = [];
t_2 = [];
t_3 = [];
t_4 = [];
i = 0;
% for l = 1:size(locations,2)
    for g = 1:size(gestures,2)
        testname = strcat(gestures(g));
        fprintf('Press any key to begin test for %s \n', testname)
        pause;
        tic
        while toc < 30
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
        figure
        plot(t_1,voltage_1)
        title('Position 1')
        figure
        plot(t_2,voltage_2)
        title('Position 2')
        figure
        plot(t_3,voltage_3)
        title('Position 3')
        figure
        plot(t_4,voltage_4)
        title('Position 4')
        sampleRate(t_1)
        sampleRate(t_2)
        sampleRate(t_3)
        sampleRate(t_4)
        filename = strcat(testname, '.mat')
        save(filename, 't_1','voltage_1', 't_2','voltage_2', 't_3','voltage_3', 't_4','voltage_4')
        fprintf('Acqured data for %s \n', testname)
        
        % reset
        voltage_1 = [];
        voltage_2 = [];
        voltage_3 = [];
        voltage_4 = [];
        t_1 = [];
        t_2 = [];
        t_3 = [];
        t_4 = [];
%     end
end
fprintf('Tests complete')
%% Plot Results - Compare Signals from Different Sensors
close all;
trial = [1 2 3];
gestures = ["relax", "extension", "flexion", "ulnar flexion", "radial flexion", "supination", "pronation", "open", "grasp"];
for i=1:size(trial,2)
    for j = 1:size(gestures,2)
        testname = strcat('test',num2str(trial(i)),'_',gestures(j));
        filename = strcat('test',num2str(trial(i)),'/',gestures(j),'.mat');
        
        if isfile(filename)
             load(filename)
        else
             continue % File does not exist.
        end
        
        figure('Name',testname)
            subplot(4,1,1)
                plot(t_1,voltage_1)
                title('Position 1')
                xlabel('time')
                ylabel('voltage')
            subplot(4,1,2)
                plot(t_2,voltage_2)
                title('Position 2')
                xlabel('time')
                ylabel('voltage')
            subplot(4,1,3)
                plot(t_3,voltage_3)
                title('Position 3')
                xlabel('time')
                ylabel('voltage')
            subplot(4,1,4)
                plot(t_4,voltage_4)
                title('Position 4')
                xlabel('time')
                ylabel('voltage')
            hold off
    end
    fprintf('Press any key to continue plotting\n')
    pause;
end
fprintf('Complete') 

%% Plot Results - Compare Signals from Different Movements
% close all;
% trial = [1 2 3];
% gestures = ["relax", "extension", "flexion", "ulnar flexion", "radial flexion", "supination", "pronation", "open", "grasp"];
% positions = ["1", "2", "3", "4"];
% for i=1:size(trial,2)
%     for j = 1:size(positions,2)
%             for k = 1:size(gestures,2)
%                 time = strcat('t_',positions(j))
%                 voltage = strcat('voltage_')
%                 testname = strcat('test',num2str(trial(i)),'_position',positions(j),'_',gestures(k));
%                 filename = strcat('test',num2str(trial(i)),'/',gestures(k),'.mat');
%         
%                 if isfile(filename)
%                      load(filename)
%                 else
%                      continue % File does not exist.
%                 end
%                 
%                 figure('Name',testname)
%                     subplot(9,1,k)
%                         plot(t_1,voltage_1)
%                         title(gestures(j))
%                         xlabel('time')
%                         ylabel('voltage')
%     end
%     fprintf('Press any key to continue plotting\n')
%     pause;
% end
% fprintf('Complete') 


