%% Simulating Robot Control
% Description: MATLAB script to simulate myoelectric control. sEMG signals
% are read and classified using an LDA classifier. The classes are
% translated into commands that are executed by the simulated robot.
% Created by: Darrell Huang
% Date: 03/31/2020

%% Initial Calibration
run('sEMG_3_XBee_accel.m')

%% Begin Simulation
close all;
% Plot starting point 
figure('Color',[0.8 0.8 0.8]); set(gca, 'color', '#124D69')
% plot(0,0)
initial = 0;
arrow_length = 0.006;
ccw_theta = pi/180*10;
cw_theta = -pi/180*10;

axis equal
init_x = 0.5;
init_y = 0.5;
vector = [init_x; init_y];
unit = vector/norm(vector)*arrow_length*3;
next_vector = vector + unit;
arrow_x = [vector(1) next_vector(1)];
arrow_y = [vector(2) next_vector(2)];
i = 0;
segment_length = 0.256;
dataIn = 6;
data_feat = [];
while(i<100)

    data_feat = acquire_data(XBeeObj, segment_length, dataIn);

    [command, score, cost] = predict(MdlLinear, data_feat);
    
    % majority vote with 5 commands
    classification(i+1) = toc;
    commands(mod(i,4)+1,1) = convertCharsToStrings(command{1});
    switch string(mode(categorical(commands)))
        case "extension"
            % move forward, unit vector does not change
            vector = vector + unit;
            if ((vector(1)+unit(1) < 1) && (vector(1)+unit(1) > 0))
                arrow_x = [vector(1) vector(1)+unit(1)];
            end
            if ((vector(2)+unit(2) < 1) && (vector(2)+unit(2) > 0))
                arrow_y = [vector(2) vector(2)+unit(2)];
            end
        case "flexion"
            % move in reverse, unit vector does not change
            vector = vector - unit;
            if ((vector(1)+unit(1) < 1) && (vector(1)+unit(1) > 0))
                arrow_x = [vector(1) vector(1)+unit(1)];
            end
            if ((vector(2)+unit(2) < 1) && (vector(2)+unit(2) > 0))
                arrow_y = [vector(2) vector(2)+unit(2)];
            end
        case "pronation"    
            % perform rotation on the unit vector
            rotation = [cos(cw_theta) -sin(cw_theta); sin(cw_theta) cos(cw_theta)];
            unit = rotation*unit;
            if ((vector(1)+unit(1) < 1) && (vector(1)+unit(1) > 0))
                arrow_x = [vector(1) vector(1)+unit(1)];
            end
            if ((vector(2)+unit(2) < 1) && (vector(2)+unit(2) > 0))
                arrow_y = [vector(2) vector(2)+unit(2)];
            end
        case "supination"
            % perform rotation on the unit vector
            rotation = [cos(ccw_theta) -sin(ccw_theta); sin(ccw_theta) cos(ccw_theta)];
            unit = rotation*unit;
            if ((arrow_x(1)+unit(1) < 1) && (vector(1)+unit(1) > 0))
                arrow_x = [arrow_x(1) arrow_x(1)+unit(1)];
            end
            if ((arrow_y(1)+unit(2) < 1) && (arrow_y(1)+unit(2) > 0))
                arrow_y = [arrow_y(1) arrow_y(1)+unit(2)];
            end
        case "relax"
            vector = vector;
        otherwise
            vector = vector;
    end

    annotation('arrow',arrow_x,arrow_y,'Tag',num2str(i),'HeadWidth',20,'HeadLength',20,'Color','w');
    delete(findall(gcf,'Tag',num2str(i-1)))
    pause(0.001)
    i = i + 1;
end

