%% Sending commands over XBee to m3pi
% By: Darrell Huang
% Created: 1/17/2020
% Edited: 1/24/2020
% Description: Sending an action and the magnitude of action to m3pi over
% an XBee communication channel. This is just a test script.

clc; clear;

% Clear serial ports
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
%%
% open correct serial port (may need to change name)
s = serial('/dev/tty.usbserial-D306EC35','BaudRate',115200);
fopen(s);

n = 20;
% Test forward
for i=1:n
    % action = [ STOP, FWD, BWD, CLK, CCLK ]
    % magnitude = 0.0 to 1.0
    action = num2str(1);
    i/n
    magnitude = num2str(i/n);
    command = ['a:' action ',m:' magnitude]
%     command = 'a:1,m:0.5';
    fprintf(s,command)
    pause(0.3);
end

% Test backward
for i=1:n
    % action := [ STOP, FWD, BWD, CLK, CCLK ]
    % magnitude := 0.0 to 1.0
    action = num2str(2);
    magnitude = num2str(i/n);
    command = ['a:' action ',m:' magnitude]
    fprintf(s,command)
    pause(0.3);
end

% Test clockwise
for i=1:n
    % action := [ STOP, FWD, BWD, CLK, CCLK ]
    % magnitude := 0.0 to 1.0
    action = num2str(3);
    magnitude = num2str(i/n);
    command = ['a:' action ',m:' magnitude]
    fprintf(s,command)
    pause(0.3);
end

% Test counterclockwise
for i=1:n
    % action := [ STOP, FWD, BWD, CLK, CCLK ]
    % magnitude := 0.0 to 1.0
    action = num2str(4);
    magnitude = num2str(i/n);
    command = ['a:' action ',m:' magnitude]
    fprintf(s,command)
    pause(0.3);
end

% Test stop
command = 'a:1,m:0.0';
fprintf(s,command)
fclose(s)
