%% Collecting Bit Error Rate
%  Description: A script for experimentally determining bit error rate of
%  a visible light communication channel
 
%  Created by: Darrell Huang
%  Date: 3/24/2020
%  Edited: 3/24/2020

%% Clear all
clc; clear;

% Clear serial ports
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

%% Open Arduino Port
receiverObj = serialport('/dev/cu.usbmodem14401',2400)
transmitterObj = serialport('/dev/cu.usbmodem1433201',2400)

%% Set Parameters
confidence_level = 0.90;
specified_ber = 1e-9;
nbits = -log(1-confidence_level)/specified_ber;
nbytes = round(nbits/8);

%% Receive Bits
clc;
error = 0;
dropped = 0;
i = 0;
save = 1;
flush(transmitterObj);
flush(receiverObj);
rng(16);
tic
fileID = fopen('ber.txt','w');
fprintf(fileID,'%s %s %s\n','i','error','dropped');
while i<nbits
    send_bit = randi([100,255]);
    write(transmitterObj,send_bit,'uint8');
    received = char(readline(receiverObj));
    received = received(1:end-1);
    
    % convert from ascii to binary
    transmitted = dec2bin(int2str(send_bit),8);
    received = dec2bin(received,8);
    
    % most likely due to the newline character being read wrong
    % added to overall error rate after the normal error rate is calculated
    if (size(received) ~= size(transmitted))
        dropped = dropped + 1;
        continue
    end
    
    i = i + 24;
    error = error + nnz(transmitted-received);
    
    if i > 100000*save
        fprintf(fileID,'%d %d %d\n',i,error,dropped);
        save = save + 1;
    end
end
toc
fclose(fileID)
