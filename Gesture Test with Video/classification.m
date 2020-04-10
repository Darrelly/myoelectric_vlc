%% Pattern Recognition
clear all; clc; close all;
load test1_15hz.mat;

sampleRate = 15;

% window size = 0.256 seconds
windowSize = 0.256;

% samples per window (based on sampling rate)
samplesPerWindow = floor(sampleRate*windowSize);

% number of windows
numWindows = min([size(t_1,2),size(t_2,2),size(t_3,2),size(t_4,2)]);
numWindows = floor(numWindows/samplesPerWindow);

t_curr = 1;
for i = 1:numWindows
    t_next = t_curr+samplesPerWindow
    window = t_curr:t_next-1;
    
    % (Feature Extraction: RMS) Calculate RMS of signal in time window
    rms_1(i) = rms(voltage_1(window))
    rms_2(i) = rms(voltage_2(window))
    rms_3(i) = rms(voltage_3(window))
    rms_4(i) = rms(voltage_4(window))
    
    % Shift window
    t_curr = t_next;
end


