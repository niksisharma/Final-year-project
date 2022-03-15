clear all; close all; clc;

%% Block1:  User Input
Freq        = 12e9;
Sector      = (0.1:0.1:360)';
AmpNoise    = [0 0.015];
ConingAngle = 0;
TestAOA     = 17;
Sens        = -72;

%% Block2:  Amplitude profile generation over 360deg Azimuth
N = length(Sector);
Alpha = 2.16;
Temp = gausswin(1800, Alpha);

Lvl = 0.07;
AmpMat(:,1) = [Lvl.*ones(450,1); Temp; Lvl*ones(1350,1)];
AmpMat(:,2) = [Lvl.*ones(1350,1); Temp; Lvl*ones(450,1)];
AmpMat(:,3) = [Temp(1351:end,1); Lvl*ones(1800,1); Temp(1:1350,1)];
AmpMat(:,4) = [Temp(451:end,1); Lvl.*ones(1800,1); Temp(1:450,:)];
NoiseMat = AmpNoise(1) + AmpNoise(2).*randn(N,4);

AmpMat_true = 10*log10(AmpMat);
AmpMat_noisy = 10*log10(AmpMat + NoiseMat);
NoiseMat_dB = AmpMat_noisy - AmpMat_true;

CDFMat_true_0dBmRef = [(Sector-180) AmpMat_true];
CDFMat_true = [(Sector-180) (-60+AmpMat_true)];
CDFMat_noisy = [(Sector-180) (-60+AmpMat_noisy)];

%% Block3:  Amplitude plots
figure;
plot(CDFMat_true_0dBmRef(:,1), CDFMat_true_0dBmRef(:,2:5), '-', 'linewidth', 2, 'markersize', 2); grid on; hold on; datacursormode on;
title(['Angle-of-Arrival Vs Amplitude (Noisefree), Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
xlabel('Angle-of-Arrival (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('Signal Amp (dBm)', 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [-180 180], 'xtick', -180:45:180, 'ylim', [-10 0], 'ytick', -10:2:0, 'fontsize', 18);
legend('Antenna1 @-45^o   ..   ', 'Antenna2 @45^o   ..   ', 'Antenna3 @135^o   ..   ', 'Antenna4 @-135^o', 'location', 'southoutside', 'Orientation','horizontal');

figure;
plot(CDFMat_true(:,1), CDFMat_true(:,2:5), '-', 'linewidth', 2, 'markersize', 2); grid on; hold on; datacursormode on;
title(['Angle-of-Arrival Vs Amplitude (Noisefree), Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
xlabel('Angle-of-Arrival (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('Signal Amp (dBm)', 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [-180 180], 'xtick', -180:45:180, 'ylim', [-70 -59], 'ytick', -70:2:-59, 'fontsize', 18);
legend('Antenna1 @-45^o   ..   ', 'Antenna2 @45^o   ..   ', 'Antenna3 @135^o   ..   ', 'Antenna4 @-135^o', 'location', 'southoutside', 'Orientation','horizontal');

figure;
plot(CDFMat_noisy(:,1), CDFMat_noisy(:,2:5), '-', 'linewidth', 1, 'markersize', 2); grid on; hold on; datacursormode on;
title(['Angle-of-Arrival Vs Amplitude (Noisy), Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
xlabel('Angle-of-Arrival (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('Signal Amp (dBm)', 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [-180 180], 'xtick', -180:45:180, 'ylim', [Sens -59], 'ytick', Sens:2:-59, 'fontsize', 18);
legend('Antenna1 @-45^o   ..   ', 'Antenna2 @45^o   ..   ', 'Antenna3 @135^o   ..   ', 'Antenna4 @-135^o', 'location', 'southoutside', 'Orientation','horizontal');
