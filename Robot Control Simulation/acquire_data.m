% Function for acquiring data from armband

function data_feat = acquire_data(serial_obj, segment_length, dataIn)
fopen(serial_obj);
% Gestures aka Classes
% gestures = ["relax", "extension", "flexion", "clockwise", "counter clockwise"];


% Collect data for segment_length
% loop = 1;
% while(1)
    
% clear serial portind = 1:size(data,1)
flushinput(serial_obj);

% clear past data
data = strings([0,0]);
data_feat = [];

tic
while toc < segment_length
    data = [data; fgets(serial_obj)];
end
fclose(serial_obj)
% housekeeping: measure processing time
% processing_begin(loop) = toc;

% parse data
data = parse_data(data, dataIn);

% Extract features from signals
[data_feat(1,1), data_feat(1,2),...
 data_feat(1,3), data_feat(1,4)] = extract_feat(data(:,1));

[data_feat(1,5), data_feat(1,6),...
 data_feat(1,7), data_feat(1,8)] = extract_feat(data(:,2));

[data_feat(1,9), data_feat(1,10),...
 data_feat(1,11),data_feat(1,12)] = extract_feat(data(:,3));

data_feat(1,13) = mean(data(:,4));
data_feat(1,14) = mean(data(:,5));
data_feat(1,15) = mean(data(:,6));

% [data_feat(1,13), data_feat(1,14),...
%  data_feat(1,15),data_feat(1,16)] = extract_feat(data(:,4));
% 
% data_feat(1,17) = mean(data(:,5));
% data_feat(1,18) = mean(data(:,6));
% data_feat(1,19) = mean(data(:,7));
%     
    
    % classify 
%     [prediction, score, cost] = predict(MdlLinear, data_feat);
    
%     % send command
%     send_command(prediction, XBeeObj)
    
    % housekeeping: measure processing time
    % processing_end(loop) = toc;
%     loop = loop+1;
% end

