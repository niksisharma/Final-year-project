clear all;
close all;
fc=1500; %Carrier Frequency
fm=250; %Modulating Frequency
m=2; %Modulating Index
n=0:0.0001:.1; %Time index
c=sin(2*pi*fc*n); %Carrier Signal
M=sin(2*pi*fm*n); %Modulating Signal
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
y=sin(2*pi*fc*n+(m.*sin(2*pi*fm*n))); %Frequency Modulation
subplot(513);
plot (n,y);
ylabel('Amplitude');
xlabel('Time index');
title('Frequency Modulated signal');
Fs=4000;
N=4096;
df=Fs/N;
k= (-Fs/2:df:Fs/2-df)*2*pi/Fs;
S=fftshift(fft(y,N)); %Discrete Fourier Transform
subplot(514);
plot(k,abs(S));
title('Magnitude of Discrete Fourier Transform');
xlabel('Frequency (x pi, radians per second)');
p = unwrap(angle(S));
subplot(515);
plot(k,p);
title('Phase of Discrete Fourier Transform');
xlabel('Frequency (x pi, radians per second)');
