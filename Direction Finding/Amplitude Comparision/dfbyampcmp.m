%%TO FIND DIRECTION OF ARRIVAL USING AMPLITUDE COMPARISON METHOD
clear all;
close all;
clc;
AOA = 1:1:180;
L = length(AOA);
Pwr = gausswin(L,2);

P = 10*log(Pwr);
sp = -20;
FMat(:,1) = [P(46:180,1);sp.*ones(180,1);P(1:45,1)];%blue1
FMat(:,2) = [sp.*ones(45,1);P(1:180,1);sp.*ones(135,1)];%red2 %135=180-45
FMat(:,3) = [sp.*ones(135,1);P(1:180,1);sp.*ones(45,1)];%yellow3 %45=180-135
FMat(:,4) = [P(136:180,1);sp.*ones(180,1);P(1:135,1)];%purple4

figure;
plot(1:360,FMat);
xlabel('angle of arrival (in degrees)');
ylabel('power (in dbm)');
title('Amplitude Comparision with 4 Antennas');
legend('Antenna 1','Antenna 2','Antenna 3','Antenna 4');
axis([0 360 -20 0]);
grid on;
%% To find the antenna that is closest to the target
dif=0;
i=1;
%assuming target is coming at a certain randomly generated angle
aoa=randi([1 360])%random input angle
for c=1:4%traverse through 4 columns (4 antennas)
   n=FMat(aoa,c);
   if n ~= -20 %considering the only 2 antennas closest to target
       a(i)=c;
       dif = n - dif;
       i=i+1;
   end
end

if dif<0
    antenna = a(1);
    antenna2 = a(2);
elseif dif == 0
    Ans=sprintf('Target is equal distances from %d and %d',antenna,antenna2)
else
    antenna = a(2);
    antenna2 = a(1);
end
display(antenna)

%% To find the angle
power=(FMat(aoa,antenna));
yyy=FMat(:,antenna); 
index1=find(yyy == power);%gives two possible angles
%To identify the exact angle
if (antenna>antenna2 & ~(antenna==4 & antenna2 == 1)) | (antenna==1 & antenna2 ==4)
    angle=min(index1)
else
    angle=max(index1)
end
