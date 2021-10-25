clear all;
close all;
Am=1;
Ac=1;
kf=500; %Frequency Deviation
fc=1000; %Carrier Frequency
fm=200; %Modulating Frequency
m=kf*Am/fm; %Modulating Index
Fs=8000; %Sampling Frequency
N=8192;
dt=1/Fs;
n=0:dt:.025-dt; %Time index
c=cos(2*pi*fc*n); %Carrier Signal
M=cos(2*pi*fm*n); %Modulating Signal
subplot(421);
plot (n,c);
ylabel('Amplitude');
xlabel('Time index');
title('Carrier signal ');
grid on;
subplot(422);
plot (n,M);
ylabel('Amplitude');
xlabel('Time index');
title('Modulating Signal');
grid on;
y=Ac*(cos(2*pi*fc*n+(m.*sin(2*pi*fm*n)))); %Frequency Modulation
subplot(423);
plot (n,y);
ylabel('Amplitude');
xlabel('Time index');
title('Frequency Modulated signal');
grid on;
df=Fs/N;
k=-Fs/2:df:Fs/2-df; %Frequency index
Y=(fft(y,N)); %Discrete Fourier Transform on FM Signal
subplot(425);
plot(k,abs(Y));
title('Magnitude of Discrete Fourier Transform');
xlabel('Frequency');
grid on;
subplot(427);
plot(k,unwrap(angle(Y)));
title('Phase of Discrete Fourier Transform');
xlabel('Frequency');
grid on;
snr=5; %Signal to noise ratio
z = awgn(y,snr,'measured'); %Adding noise(AWGN)
subplot(424); 
plot(n, y, 'r');
hold on; % puts the next graph on the same plot
plot(n, z, 'b');
xlabel('Time');
ylabel('Amplitude');
title('FM Signal After Addition of Noise');
grid on;
hold off;
legend('Original Signal','Signal with AWGN');
Z=(fft(z,N)); %Discrete Fourier Transform on noise affected FM Signal
subplot(426);
plot(k,abs(Y),'r');
hold on;
plot(k,abs(Z),'b');
title('Magnitude of Discrete Fourier Transform (with noise)');
xlabel('Frequency');
grid on;
hold off;
legend('Original Signal','Signal with AWGN');
subplot(428);
plot(k,unwrap(angle(Y)),'r');
hold on;
plot(k,unwrap(angle(Z)),'b');
title('Phase of Discrete Fourier Transform (with noise)');
xlabel('Frequency');
grid on;
hold off;
legend('Original Signal','Signal with AWGN');
