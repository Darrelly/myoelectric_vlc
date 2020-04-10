%% Collecting Data from 4 sEMG Sensors through XBee
% Description: Collecting Raw EMG data from 4 sEMG sensors
% Created by: Darrell Huang
% Date: 3/10/2020
% Edited: 3/10/2020
% Take Note of: Sampling Frequency, Classification Accuracy
% Frequencies: 401, 401, 401, 401
clc; clear; close all;

% Clear serial ports
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

%% Serial Port - Direct Wired Connection to Micro
XBeeObj = serial('/dev/cu.usbserial-D306EC35','BaudRate',115200);
fopen(XBeeObj);

%% Collect Training and Testing Data
sensors = 4;

% Gestures aka Classes
gestures = ["relax", "extension", "flexion", "supination", "pronation"];

% segment_length = time of each segment, segments = total segments, g = number of gestures
segment_length = 0.032;
collection_time = 20;
g = length(gestures);
time = zeros(1, 1);
data = [];
labels = [];
samples_collected = [];
% loop for each gesture
for gest = 1:size(gestures,2)
    
    % prep for data capture
    class = strcat(gestures(gest));
    class_data = strings([1,1]);
  
    fprintf('Please hold arm in %s position \n\n', class)
    fprintf('Press any key to begin test for %s \n', class)
    pause;
    
    flushinput(XBeeObj)
    
    % keep track of sampling rate
    tic;
    ind = 1;
    while toc < collection_time
        class_data = [class_data; fgets(XBeeObj)];        
        time_temp(ind) = toc;
        ind = ind + 1;
    end
    
    samples_collected(gest) = size(class_data,1);
    data = [data; class_data];
    labels = [labels; repelem(class,samples_collected(gest))'];
    fprintf('Acqured data for %s \n\n\n\n', class);
end
fprintf('All training data acquired!')
avg_freq = 1/mean(diff(time_temp))

%% Parse data
for ind = 1:size(data,1)
    data(ind) = data{ind}(:,2:end-2);
end

%% Convert data from string to double

% Ensure we are looking at full string of data
dataIn = 4;
size_data = size(data,1);
ind = 1;
while ind < size_data
    if (length(strfind(data(ind),',')) ~= dataIn-1)
        data(ind) = [];
        labels(ind) = [];
        size_data = size(data,1);
    else
        ind = ind + 1;
    end
end

data = split(data,',');
data = double(data);

%% Split table into training and test (70% and 30%)

% just to save all data
all_data = data;
all_labels = labels;

training_data = [];
training_labels = [];
testing_data = [];
testing_labels = [];
for gest = 1:size(gestures,2)
    training_size = floor(samples_collected(gest)*0.7);
    
    % 70% train data
    training_data = [training_data; data(1:training_size, :)];
    training_labels = [training_labels; labels(1:training_size, :)];

    % erase array
    data(1:training_size, :) = [];
    labels(1:training_size, :) = [];

    % 30% test data
    ind = 1;
    temp_test_data = [];
    temp_test_labels = strings([1, 1]);
    while labels(1) == labels(2) && length(labels) > 2
        temp_test_data(ind,:) = data(1,:);
        temp_test_labels(ind,1) = labels(1);
        labels(1) = [];
        data(1,:) = [];
        ind = ind + 1;
    end
    temp_test_data(ind,:) = data(1,:);
    temp_test_labels(ind) = labels(1);
    
    testing_data = [testing_data; temp_test_data];
    testing_labels = [testing_labels; temp_test_labels];
end

%% Convert Arrays into Table. Add training labels.

% Training Data
training_table = array2table(training_data,...
    'VariableNames',{'sEMG1','sEMG2','sEMG3','sEMG4'});

training_table_labeled = addvars(training_table,training_labels);

% Save file
train_filename = nextname('sEMG_4_XBee_train_','01','.csv');
writetable(training_table_labeled,train_filename);

% Test Data
test_table = array2table(testing_data,...
    'VariableNames',{'sEMG1','sEMG2','sEMG3','sEMG4'});

testing_data_labeled = addvars(test_table,testing_labels);

% Save file
test_filename = nextname('sEMG_4_XBee_test_','01','.csv');
writetable(testing_data_labeled,test_filename);


%% Import Table 1
T1 = readtable(train_filename);

% initialize windowed data array
T1_windowed = [];

data_points = height(T1);
window = floor(avg_freq * segment_length); 

% s = sample (row of table)
s = 1;

% ind = row index for T1_windowed
ind = 1;

while s + window < data_points
    segment = s : s+window-1;
    % ensure everything within the time window belongs to the same gesture
    curr_label = T1.training_labels(s);
    if all(ismember(T1.training_labels(segment), curr_label))
        [T1_windowed(ind,1), T1_windowed(ind,2),...
         T1_windowed(ind,3), T1_windowed(ind,4)] = extract_feat([T1.sEMG1(segment)]);
        
        [T1_windowed(ind,5), T1_windowed(ind,6),...
         T1_windowed(ind,7), T1_windowed(ind,8)] = extract_feat([T1.sEMG2(segment)]);
     
        [T1_windowed(ind,9), T1_windowed(ind,10),...
         T1_windowed(ind,11),T1_windowed(ind,12)] = extract_feat([T1.sEMG3(segment)]);
         
        [T1_windowed(ind,13), T1_windowed(ind,14),...
         T1_windowed(ind,15),T1_windowed(ind,16)] = extract_feat([T1.sEMG4(segment)]);
         
%         T1_windowed(ind,17)    = mean([T1.x(segment)]);
%         T1_windowed(ind,18)    = mean([T1.y(segment)]);
%         T1_windowed(ind,19)    = mean([T1.z(segment)]);
        T1_labels(ind,1)       = curr_label;
        ind = ind + 1;
    end
    s = s + window;
end

% Use windowed data to train LDA classifier
T1_windowed_table = array2table(T1_windowed,...
    'VariableNames',{'MAV1','ZeroCross1','WLength1','SChange1',...
                     'MAV2','ZeroCross2','WLength2','SChange2'...
                     'MAV3','ZeroCross3','WLength3','SChange3'...
                     'MAV4','ZeroCross4','WLength4','SChange4'...
%                     ,'x','y','z'...
                    });

T1_windowed_labeled = addvars(T1_windowed_table,T1_labels);

MdlLinear = fitcdiscr(T1_windowed_labeled,'T1_labels',...
                      'DiscrimType','pseudolinear',...
                      'Prior','uniform')
                  
%% Test data with Test Data

% Read Test Data Table
T2 = readtable(test_filename);

% initialize windowed data array
T2_windowed = [];

data_points = height(T2);
window = floor(avg_freq * segment_length); 

% s = sample (row of table)
s = 1;

% ind = row index for T1_windowed
ind = 1;
while s + window < data_points
    segment = s:s+window-1;
    curr_label = T2.testing_labels(s);
    if all(ismember(T2.testing_labels(segment), curr_label))
        [T2_windowed(ind,1), T2_windowed(ind,2),...
         T2_windowed(ind,3), T2_windowed(ind,4)] = extract_feat([T2.sEMG1(segment)]);
       
        [T2_windowed(ind,5), T2_windowed(ind,6),...
         T2_windowed(ind,7), T2_windowed(ind,8)] = extract_feat([T2.sEMG2(segment)]);
     
        [T2_windowed(ind,9), T2_windowed(ind,10),...
         T2_windowed(ind,11),T2_windowed(ind,12)] = extract_feat([T2.sEMG3(segment)]);
         
        [T2_windowed(ind,13),T2_windowed(ind,14),...
         T2_windowed(ind,15),T2_windowed(ind,16)] = extract_feat([T2.sEMG4(segment)]);
         
%         T2_windowed(ind,17)    = mean([T2.x(segment)]);
%         T2_windowed(ind,18)    = mean([T2.y(segment)]);
%         T2_windowed(ind,19)    = mean([T2.z(segment)]);
        
        T2_labels(ind,1)       = curr_label;
        ind = ind + 1;
    end
    s = s + window;
end

T2_windowed_table = array2table(T2_windowed,...
    'VariableNames',{'MAV1','ZeroCross1','WLength1','SChange1',...
                     'MAV2','ZeroCross2','WLength2','SChange2'...
                     'MAV3','ZeroCross3','WLength3','SChange3'...
                     'MAV4','ZeroCross4','WLength4','SChange4'
%                     ,'x','y','z'...
                    });

T2_windowed_labeled = addvars(T2_windowed_table,T2_labels);


%% Predict with LDA
[prediction, score, cost] = predict(MdlLinear, T2_windowed_table);

figure;
cm = confusionchart(T2_labels,prediction, ...
    'ColumnSummary','column-normalized', ...
    'RowSummary','row-normalized');
cm.Title = 'Gesture Confusion Matrix';
cm.DiagonalColor ='#0072BD'	;
cm.OffDiagonalColor = 'red'
cm.FontColor = 	'black'
cm.FontSize = 30
[errorRate, correct] = eval_classperf(T2_labels, prediction);
