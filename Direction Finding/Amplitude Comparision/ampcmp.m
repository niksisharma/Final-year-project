clear all; close all; clc;

%% Block1:  User Input
Freq        = 12e9;
Sector      = (0.1:0.1:360)';
AmpNoise    = [0 0.015];
ConingAngle = 0;
TestAOA = randi(360)-180
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
Ref =(TestAOA*10)+1800;

Test_Powers = CDFMat_noisy(Ref,2:5);

i=1;
for c=1:4%traverse through 4 columns (4 antennas)
   Test_Power = Test_Powers(c);
   if Test_Power ~= min(Test_Powers)
       ThreeAntennas(i)=c;
       i=i+1;
   else
       op1 = sprintf('Eliminating antenna %d ',c);
   end
end
CDFMat_noisy(:,6) = CDFMat_noisy(:,(ThreeAntennas(1)+1))-CDFMat_noisy(:,(ThreeAntennas(2)+1));
CDFMat_noisy(:,7) = CDFMat_noisy(:,(ThreeAntennas(1)+1))-CDFMat_noisy(:,(ThreeAntennas(3)+1));
CDFMat_noisy(:,8) = CDFMat_noisy(:,(ThreeAntennas(2)+1))-CDFMat_noisy(:,(ThreeAntennas(3)+1));

r1 = Test_Powers((ThreeAntennas(1))) - Test_Powers((ThreeAntennas(2)));
r2 = Test_Powers((ThreeAntennas(1))) - Test_Powers((ThreeAntennas(3)));
r3 = Test_Powers((ThreeAntennas(2))) - Test_Powers((ThreeAntennas(3)));

if (r1>0) && (r2>0)
    ClosestAntenna = ThreeAntennas(1);
    if r3>0
        SecondClosestAntenna = ThreeAntennas(2);
    else
        SecondClosestAntenna = ThreeAntennas(3);
    end
elseif (r3>0)
    ClosestAntenna = ThreeAntennas(2);
    if r2>0
        SecondClosestAntenna = ThreeAntennas(1);
    else
        SecondClosestAntenna = ThreeAntennas(3);
    end
else
    ClosestAntenna = ThreeAntennas(3);
    if r2>0
        SecondClosestAntenna = ThreeAntennas(1);
    else
        SecondClosestAntenna = ThreeAntennas(2);
    end
end

%%
AOAVect = CDFMat_noisy(:,1);

figure
hold on;
plot(AOAVect,CDFMat_noisy(:,2:5));
xlabel('angle of arrival (in degrees)');
ylabel('power (in dbm)');
title('Amplitude Comparision with 4 Antennas');
legend('Antenna 3','Antenna 4','Antenna 1','Antenna 2');
axis([-180 180 -75 -60]);
grid on;

figure
hold on;
plot(AOAVect,CDFMat_noisy(:,2:5));
plot(TestAOA*ones(1,4), CDFMat_noisy(Ref,2:5), '.', 'linewidth', 2, 'markersize', 40); grid on; hold on; datacursormode on;
xlabel('angle of arrival (in degrees)');
ylabel('power (in dbm)');
title('Amplitude Comparision with 4 Antennas');
legend('Antenna 1','Antenna 2','Antenna 3','Antenna 4','Powers');
axis([-180 180 -75 -60]);
grid on;

%% Estimating AOA

Max_power = max([Test_Powers]);
y=CDFMat_noisy(:,ClosestAntenna+1);
% index=find(y == Max_power);
 index=find((y >= (Max_power-0.008)) & (y<=(Max_power+0.008)));
%To identify the exact angle
EstimatedRefs=(index);
min_dif = Max_power - CDFMat_noisy(EstimatedRefs(1),ClosestAntenna+1);
EstimatedRef = EstimatedRefs(1);
for j = 2:length(EstimatedRefs)
    if Max_power - CDFMat_noisy(EstimatedRefs(j),ClosestAntenna+1) < min_dif
        min_dif = Max_power - CDFMat_noisy(EstimatedRefs(j),ClosestAntenna+1);
        EstimatedRef = EstimatedRefs(j);
    end
end
 EstimatedAOA = (EstimatedRef - 1800)/10

if ClosestAntenna == 4 & EstimatedAOA > 100
    EstimatedAOA = 0 - EstimatedAOA
end
