clear all;
close all;
Fs = 800e3;
dt = 1/Fs;
t = (0:dt:0.002-dt);
Fm = 5000;
y = cos(2*pi*Fm*t);
subplot(3,1,1);
plot(t, y);
title('Time-Domain signal')
ylabel('Amplitude');
xlabel('Time index');
N=16000;
df = Fs/N;
k= (-Fs/2:df:Fs/2-df)*2*pi/Fs;
S=fftshift(fft(y,N)); %Discrete Fourier Trasnform
subplot(3,1,2);
plot(k,abs(S));
title('Magnitude of Discrete Fourier Transform');
xlabel('Frequency (x pi, radians per second)');
p = unwrap(angle(S));
subplot(3,1,3);
plot(k,p);
title('Phase of Discrete Fourier Transform');
xlabel('Frequency (x pi, radians per second)');
