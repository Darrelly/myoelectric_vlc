%% Parse Data
%  Description: Parse data received from Arduino Micro in the form of
%  <a,b,c,d,x,y,z>
%  Created by: Darrell Huang

function data = parse_data(pre_data, dataIn)    
    % parse data
    row = 1;
    size_data = size(pre_data,1);
    while row <= size_data
        pre_data(row) = pre_data{row}(2:end-2);
        if (length(strfind(pre_data(row),',')) ~= dataIn-1)
            pre_data(row) = [];
            size_data = size(pre_data,1);
        else
            row = row + 1;
        end
    end
    data = split(pre_data,',');
    data = double(data);
end