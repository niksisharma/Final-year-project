clear all; close all; clc;

%%
Fs = 1450e6;
F = 12e9;
CDFMat = load('CDFMat.csv');
phi = 0;

%% Signal generation
for i = 1:1
    Pwr = CDFMat(i,2:5);
    P = 10.^(Pwr/20); %antilog
ds = 1/Fs;
t = (0:ds:0.000002-ds);
c1 = 1/(10^(CDFMat(i,2)/20));
c2 = 1/(10^(CDFMat(i,3)/20));
c3 = 1/(10^(CDFMat(i,4)/20));
c4 = 1/(10^(CDFMat(i,5)/20));
y1 = c1*P(1)*cos(2*pi*F*t);
y2 = c2*P(2)*cos(2*pi*F*t);
y3 = c3*P(3)*cos(2*pi*F*t);
y4 = c4*P(4)*cos(2*pi*F*t);

figure;
subplot(2,2,1)
plot(t, y1);
title('Signal 1')
ylabel('Amplitude');
xlabel('Time index');

subplot(2,2,2)
plot(t, y2);
title('Signal 2')
ylabel('Amplitude');
xlabel('Time index');

subplot(2,2,3)
plot(t, y3);
title('Signal 3')
ylabel('Amplitude');
xlabel('Time index');

subplot(2,2,4)
plot(t, y4);
title('Signal 4')
ylabel('Amplitude');
xlabel('Time index');

%% Noise

snr=10; %Signal to noise ratio
z1 = awgn(y1,snr,'measured'); %Adding noise(AWGN)
z2 = awgn(y2,snr,'measured'); %Adding noise(AWGN)
z3 = awgn(y3,snr,'measured'); %Adding noise(AWGN)
z4 = awgn(y4,snr,'measured'); %Adding noise(AWGN)

% x=input('Enter the input sequence x[n]=');
L1=length(z1);
L2=length(z2);
L3=length(z3);
L4=length(z4);

N=32768;
if(N<L1)
disp('N should be greater than L') 
else
%Wn=-j*2*pi/N;
for k=0:N-1
X1(k+1)=0;
for n=0:L1-1
X1(k+1)=X1(k+1)+z1(n+1)*exp(-j*2*pi*n*k/N);
end
end
X1 = 20*log10(X1);
% Y1=fftshift(X1);
figure;
stem(X1);
% axis(-4000, 4000, -1e-58, 3e-58)
end
end