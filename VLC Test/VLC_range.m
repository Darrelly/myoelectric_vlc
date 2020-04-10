%% Determining range of VLC
% Description: Measures SNR and current output of the receiving at
% different distances from the transmitter



distance = [5 10 15 20 25 30 35 40]; % centimeters
voltage = [2.89 1.3 .6 .408 .354 .305 .278 .266];
current = [2.89/100 1.3/100 .600/100 .408/100 .354/100 .305/100 .278/100 .266/100]; % 100 ohm resistor
% voltage = []; % after transimpedance amp

signal_dB = [54 52 51 45 42 40 36 35];
noise_dB = 20;
snr_dB = signal_dB - noise_dB;
mdl = fitlm(distance,snr_dB);

figure;
plot(distance,1000*current,'-o','MarkerSize',7,...
                      'MarkerEdgeColor',[0.9290, 0.6940, 0.1250],...
                      'MarkerFaceColor',[0.9290, 0.6940, 0.1250],...
                      'LineWidth',5,'Color',[0, 0.4470, 0.7410])
title('VLC Test: Current vs Distance','FontSize',24)
xlabel('Distance (cm)','FontSize',20)
ylabel('Current (mA)','FontSize',20)

figure;
plot(distance,snr_dB,'-o','MarkerSize',7,...
                      'MarkerEdgeColor',[0.9290, 0.6940, 0.1250],...
                      'MarkerFaceColor',[0.9290, 0.6940, 0.1250],...
                      'LineWidth',5,'Color',[0.6350, 0.0780, 0.1840])
% hold on;
% plot(mdl,'LineWidth',3);
title('VLC Test: Signal-to-Noise Ratio vs Distance','FontSize',24)
xlabel('Distance (cm)','FontSize',20)
ylabel('SNR (dB)','FontSize',20)