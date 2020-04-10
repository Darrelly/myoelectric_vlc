%% eval_classperf function
% Created By: Darrell Huang
% Date: 
% Edited: 1/28/2020
% Description: Evaluating classifier performance. Returns the error rate.

function [ErrorRate, Correct] = eval_classperf(truelabels, prediction)
    totalSamples = length(truelabels);
    for i = 1:totalSamples
        Correct(i) = isequal(prediction{i}, truelabels{i});
    end
    ErrorRate = sum(Correct)/totalSamples;
end