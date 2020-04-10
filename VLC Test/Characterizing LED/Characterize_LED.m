R_bias = 100; %ohms
V_bias = [0:0.2:5]; %sweeping voltage input
V_LED = [0 .198 .398 .598 .798 .997 1.196 1.396 1.596 1.772 1.841 1.869 1.887 1.9 1.911 1.919 1.927 1.933 1.938 1.943 1.948 1.951 1.955 1.959 1.962 1.964]
% V_LED = [1.22 1.42 1.62 1.78 1.85 1.88 1.9 1.91 1.93 1.95 1.95 1.96]; % voltage across LED
I_LED = (V_bias - V_LED) / R_bias; % calculate current
plot(V_LED, I_LED)

% Linear Region is between 1.8V and 2V

