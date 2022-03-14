clear all; close all; clc;

%% Block1:  User Input
Baseline    = [30 70 120]; 
Freq        = 17e9;
Sector      = -90:0.1:90;
dPhiNoise   = [0 5];
ConingAngle = 0;
TestAOA     = 30;

%% Block2:  dPhase Generation & Processing
[dPhi_noisy_wrap, dPhi_true_wrap, dPhi_true_unwrap, dPhi_noisy_unwrap, Noise_m, AOAVect] = PI_SectorDeltaPhaseGenerator(Freq, Sector, Baseline, dPhiNoise, ConingAngle);
Len = length(AOAVect);

if (TestAOA >= 0)
    Ref = floor(Len/2) + floor(TestAOA/0.1) + 1;
else
    Ref = floor(TestAOA/0.1);
end
Test_dPhi_true_unwrap = dPhi_true_unwrap(Ref, :);
Test_dPhi_noisy_unwrap = dPhi_noisy_unwrap(Ref, :);
Test_dPhi_true_wrap = dPhi_true_wrap(Ref, :);
Test_dPhi_noisy_wrap = dPhi_noisy_wrap(Ref, :);

%% Block3:  Unwrapped Phase Plots
figure;
plot(AOAVect, dPhi_true_unwrap(:,1), '-', 'linewidth', 2, 'markersize', 2); grid on; hold on; datacursormode on;
plot(AOAVect, dPhi_true_unwrap(:,2), '-', 'linewidth', 2, 'markersize', 2); grid on; hold on;
plot(AOAVect, dPhi_true_unwrap(:,3), '-', 'linewidth', 2, 'markersize', 2, 'color', ([0 128 0])./256); grid on; hold on;
title(['Angle-of-Arrival Vs unwrapped dPhase (Noisefree), Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
xlabel('Angle-of-Arrival (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('dPhase (Deg)', 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [AOAVect(1) AOAVect(end)], 'xtick', AOAVect(1):15:AOAVect(end), 'ylim', [min(min(dPhi_noisy_unwrap)) max(max(dPhi_noisy_unwrap))], 'fontsize', 18);
legend('dPhase12', 'dPhase13', 'dPhase14', 'location', 'northwest');

figure;
plot(AOAVect, dPhi_noisy_unwrap(:,1), '-', 'linewidth', 2, 'markersize', 1); grid on; hold on; datacursormode on;
plot(AOAVect, dPhi_noisy_unwrap(:,2), '-', 'linewidth', 2, 'markersize', 1); grid on; hold on;
plot(AOAVect, dPhi_noisy_unwrap(:,3), '-', 'linewidth', 2, 'markersize', 1, 'color', ([0 128 0])./256); grid on; hold on;
title(['Angle-of-Arrival Vs unwrapped dPhase (Noisy), Gaussian, \mu=', num2str(dPhiNoise(1)), '^o, \sigma=', num2str(dPhiNoise(2)), '^o, Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
xlabel('Angle-of-Arrival (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('dPhase (Deg)', 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [AOAVect(1) AOAVect(end)], 'xtick', AOAVect(1):15:AOAVect(end), 'ylim', [min(min(dPhi_noisy_unwrap)) max(max(dPhi_noisy_unwrap))], 'fontsize', 18);
legend('dPhase12', 'dPhase13', 'dPhase14', 'location', 'northwest');

%% Block4:  Wrapped Phase Plots
figure;
plot(AOAVect, dPhi_true_wrap(:,1), '*b', 'markersize', 1.5); grid on; hold on; datacursormode on;
plot(AOAVect, dPhi_true_wrap(:,2), 'or', 'markersize', 1.5); grid on; hold on;
plot(AOAVect, dPhi_true_wrap(:,3), 'd', 'markersize', 1.5, 'color', ([0 128 0])./256); grid on; hold on;
title(['Angle-of-Arrival Vs wrapped dPhase (Noisefree), Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
xlabel('Angle-of-Arrival (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('dPhase (Deg)', 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [AOAVect(1) AOAVect(end)], 'xtick', AOAVect(1):15:AOAVect(end), 'ylim', [-180 180], 'ytick', -180:45:180, 'fontsize', 18);
legend('dPhase12', 'dPhase13', 'dPhase14', 'location', 'northeast');

figure;
plot(AOAVect, dPhi_noisy_wrap(:,1), '*b', 'markersize', 2); grid on; hold on; datacursormode on;
plot(AOAVect, dPhi_noisy_wrap(:,2), 'or', 'markersize', 2); grid on; hold on;
plot(AOAVect, dPhi_noisy_wrap(:,3), 'd', 'markersize', 2, 'color', ([0 128 0])./256); grid on; hold on;
title(['Angle-of-Arrival Vs wrapped dPhase (Noisy), Gaussian, \mu=', num2str(dPhiNoise(1)), '^o, \sigma=', num2str(dPhiNoise(2)), '^o, Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
xlabel('Angle-of-Arrival (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('dPhase (Deg)', 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [AOAVect(1) AOAVect(end)], 'xtick', AOAVect(1):15:AOAVect(end), 'ylim', [-180 180], 'ytick', -180:45:180, 'fontsize', 18);
legend('dPhase12', 'dPhase13', 'dPhase14', 'location', 'northeast');

%% Block5:  Unwrapped Phase Plots along with Test AOA & Test dPhase Demo
figure;
plot(AOAVect, dPhi_true_unwrap(:,1), '-', 'linewidth', 2, 'markersize', 2); grid on; hold on; datacursormode on;
plot(AOAVect, dPhi_true_unwrap(:,2), '-', 'linewidth', 2, 'markersize', 2); grid on; hold on;
plot(AOAVect, dPhi_true_unwrap(:,3), '-', 'linewidth', 2, 'markersize', 2, 'color', ([0 128 0])./256); grid on; hold on;
plot(AOAVect(Ref), Test_dPhi_true_unwrap(1), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
plot(AOAVect(Ref), Test_dPhi_true_unwrap(2), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
plot(AOAVect(Ref), Test_dPhi_true_unwrap(3), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
title(['Angle-of-Arrival Vs unwrapped dPhase (Noisefree), Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
xlabel('Angle-of-Arrival (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('dPhase (Deg)', 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [AOAVect(1) AOAVect(end)], 'xtick', AOAVect(1):15:AOAVect(end), 'ylim', [min(min(dPhi_noisy_unwrap)) max(max(dPhi_noisy_unwrap))], 'fontsize', 18);
legend('dPhase12', 'dPhase13', 'dPhase14', 'Test dPhase12', 'Test dPhase13', 'Test dPhase14','location', 'northwest');

figure;
plot(AOAVect, dPhi_noisy_unwrap(:,1), '-', 'linewidth', 1, 'markersize', 1); grid on; hold on; datacursormode on;
plot(AOAVect, dPhi_noisy_unwrap(:,2), '-', 'linewidth', 1, 'markersize', 1); grid on; hold on;
plot(AOAVect, dPhi_noisy_unwrap(:,3), '-', 'linewidth', 1, 'markersize', 1, 'color', ([0 128 0])./256); grid on; hold on;
plot(AOAVect(Ref), Test_dPhi_noisy_unwrap(1), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
plot(AOAVect(Ref), Test_dPhi_noisy_unwrap(2), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
plot(AOAVect(Ref), Test_dPhi_noisy_unwrap(3), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
title(['Angle-of-Arrival Vs unwrapped dPhase (Noisy), Gaussian, \mu=', num2str(dPhiNoise(1)), '^o, \sigma=', num2str(dPhiNoise(2)), '^o, Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
xlabel('Angle-of-Arrival (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('dPhase (Deg)', 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [AOAVect(1) AOAVect(end)], 'xtick', AOAVect(1):15:AOAVect(end), 'ylim', [min(min(dPhi_noisy_unwrap)) max(max(dPhi_noisy_unwrap))], 'fontsize', 18);
legend('dPhase12', 'dPhase13', 'dPhase14', 'Test dPhase12', 'Test dPhase13', 'Test dPhase14','location', 'northwest');

%% Block6:  Wrapped Phase Plots along with Test AOA & Test dPhase Demo
figure;
plot(AOAVect, dPhi_true_wrap(:,1), '*b', 'markersize', 1.5); grid on; hold on; datacursormode on;
plot(AOAVect, dPhi_true_wrap(:,2), 'or', 'markersize', 1.5); grid on; hold on;
plot(AOAVect, dPhi_true_wrap(:,3), 'd', 'markersize', 1.5, 'color', ([0 128 0])./256); grid on; hold on;
plot(AOAVect(Ref), Test_dPhi_true_wrap(1), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
plot(AOAVect(Ref), Test_dPhi_true_wrap(2), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
plot(AOAVect(Ref), Test_dPhi_true_wrap(3), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
title(['Angle-of-Arrival Vs wrapped dPhase (Noisefree), Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
xlabel('Angle-of-Arrival (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('dPhase (Deg)', 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [AOAVect(1) AOAVect(end)], 'xtick', AOAVect(1):15:AOAVect(end), 'ylim', [-180 180], 'ytick', -180:45:180, 'fontsize', 18);
legend('dPhase12', 'dPhase13', 'dPhase14', 'Test dPhase12', 'Test dPhase13', 'Test dPhase14','location', 'northwest');

figure;
plot(AOAVect, dPhi_noisy_wrap(:,1), '*b', 'markersize', 1); grid on; hold on; datacursormode on;
plot(AOAVect, dPhi_noisy_wrap(:,2), 'or', 'markersize', 1); grid on; hold on;
plot(AOAVect, dPhi_noisy_wrap(:,3), 'd', 'markersize', 1, 'color', ([0 128 0])./256); grid on; hold on;
plot(AOAVect(Ref), Test_dPhi_noisy_wrap(1), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
plot(AOAVect(Ref), Test_dPhi_noisy_wrap(2), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
plot(AOAVect(Ref), Test_dPhi_noisy_wrap(3), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
title(['Angle-of-Arrival Vs wrapped dPhase (Noisy), Gaussian, \mu=', num2str(dPhiNoise(1)), '^o, \sigma=', num2str(dPhiNoise(2)), '^o, Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
xlabel('Angle-of-Arrival (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('dPhase (Deg)', 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [AOAVect(1) AOAVect(end)], 'xtick', AOAVect(1):15:AOAVect(end), 'ylim', [-180 180], 'ytick', -180:45:180, 'fontsize', 18);
legend('dPhase12', 'dPhase13', 'dPhase14', 'Test dPhase12', 'Test dPhase13', 'Test dPhase14','location', 'northwest');

%% Block7:  Wrapped 3-D  Plots along with Test AOA & Test dPhase Demo
figure; 
plot3(dPhi_true_wrap(:,1), dPhi_true_wrap(:,2), dPhi_true_wrap(:,3), '*m', 'markersize', 3); grid on; hold on; datacursormode on;
plot3(Test_dPhi_true_wrap(1), Test_dPhi_true_wrap(2), Test_dPhi_true_wrap(3), '.b', 'markersize', 40); grid on; hold on; datacursormode on;
xlabel('dPhase12 (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('dPhase13 (Deg)', 'fontsize', 18, 'fontweight', 'bold');
zlabel('dPhase14 (Deg)', 'fontsize', 18, 'fontweight', 'bold');
title(['3-Dimensional dPhase Search Space (Noisefree), Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [-180 180], 'xtick', -180:45:180, 'ylim', [-180 180], 'ytick', -180:45:180, 'zlim', [-180 180], 'ztick', -180:45:180, 'fontsize', 16);
legend('Search Space', 'Test Point','location', 'northwest');

figure; 
plot3(dPhi_noisy_wrap(:,1), dPhi_noisy_wrap(:,2), dPhi_noisy_wrap(:,3), '*m', 'markersize', 3); grid on; hold on; datacursormode on;
plot3(Test_dPhi_noisy_wrap(1), Test_dPhi_noisy_wrap(2), Test_dPhi_noisy_wrap(3), '.b', 'markersize', 40); grid on; hold on; datacursormode on;
xlabel('dPhase12 (Deg)', 'fontsize', 18, 'fontweight', 'bold');
ylabel('dPhase13 (Deg)', 'fontsize', 18, 'fontweight', 'bold');
zlabel('dPhase14 (Deg)', 'fontsize', 18, 'fontweight', 'bold');
title(['3-Dimensional dPhase Search Space (Noisy), Gaussian, \mu=', num2str(dPhiNoise(1)), '^o, \sigma=', num2str(dPhiNoise(2)), '^o, Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
% title(['3-Dimensional dPhase Search Space (Noisefree), Freq = ', num2str(Freq*1e-9), ' GHz'], 'fontsize', 18, 'fontweight', 'bold');
set(gca, 'xlim', [-180 180], 'xtick', -180:45:180, 'ylim', [-180 180], 'ytick', -180:45:180, 'zlim', [-180 180], 'ztick', -180:45:180, 'fontsize', 16);
legend('Search Space', 'Test Point','location', 'northwest');
