%% Extract Features (from raw EMG)
% Created By: Darrell Huang
% Date: 
% Edited: 1/29/2020

function [mav, zero_crossings, waveform_length, slope_changes] = extract_feat(x) 
    
    mav = mean_abs_value(x);
    zero_crossings = zcross(x);
    waveform_length = wlength(x);
    slope_changes = schange(x);
    
    function mav = mean_abs_value(x) 
        mav = sum(abs(x))/length(x);
    end

    function zero_crossings = zcross(x)
        zero_crossings = 0;
        for k = 1:length(x)-1
            % qualitative threshold
            if ((x(k) > 498 && x(k+1) < 492) | ...
                (x(k) < 492 && x(k+1) > 498))
             
                zero_crossings = zero_crossings + 1;
            end
        end
    end

    function waveform_length = wlength(x)
        waveform_length = sum(abs(diff(x)));
    end

    function slope_changes = schange(x)
        slope_changes = 0;
        for k = 2:length(x)-1
            % qualitative threshold
            if ((x(k) - x(k-1) > 10 && x(k+1) - x(k) < -10) | ...
                (x(k) - x(k-1) < -10 && x(k+1) - x(k) > 10))
             
                slope_changes = slope_changes + 1;
            end
        end
    end
end