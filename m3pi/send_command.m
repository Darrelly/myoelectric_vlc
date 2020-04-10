%% Send command to m3pi
% Created by: Darrell Huang
% Date: 2/21/2020
% Edited: 2/21/2020
% Description: Send action and magnitude (optional) to m3pi

function status = send_command(action, serialObj)
    gestures = ["relax", "extension", "flexion", "clockwise", "counter clockwise"];
    action = num2str(find(contains(gestures,action)));
    command = ['a:' action ',m:0.5']
    fprintf(serialObj,command)
    pause(0.3);
end
