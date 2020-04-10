function rate = sampleRate(t)
    timeBetweenDataPoints = diff(t);
    averageTime = mean(timeBetweenDataPoints);
    dataRateHz = 1/averageTime;
    fprintf('Acquired one data point per %.3f seconds (%.f Hz)\n',...
        averageTime,dataRateHz)
end