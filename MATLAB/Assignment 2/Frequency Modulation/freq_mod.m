clear all;
close all;
Am=1;
kf=500; %Frequency Deviation
fc=1000; %Carrier Frequency
fm=200; %Modulating Frequency
m=kf*Am/fm; %Modulating Index
n=0:0.0001:.1; %Time index
c=cos(2*pi*fc*n); %Carrier Signal
M=cos(2*pi*fm*n); %Modulating Signal
subplot(511);
plot (n,c);
ylabel('Amplitude');
xlabel('Time index');
title('Carrier signal ');
subplot(512);
plot (n,M);
ylabel('Amplitude');
xlabel('Time index');
title('Modulating Signal');
y=cos(2*pi*fc*n+(m.*sin(2*pi*fm*n))); %Frequency Modulation
subplot(513);
plot (n,y);
ylabel('Amplitude');
xlabel('Time index');
title('Frequency Modulated signal');
Fs=4000;
N=4096;
df=Fs/N;
k=-Fs/2:df:Fs/2-df;
Y=(fft(y,N)); %Discrete Fourier Transform
subplot(514);
plot(k,abs(Y));
title('Magnitude of Discrete Fourier Transform');
xlabel('Frequency');
p = unwrap(angle(Y));
subplot(515);
plot(k,p);
title('Phase of Discrete Fourier Transform');
xlabel('Frequency');
