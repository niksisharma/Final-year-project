clear all;
close all;
Fs = 800e3;
dt = 1/Fs;
t = (0:dt:0.002-dt);
Fm = 5000;
y = cos(2*pi*Fm*t);
subplot(3,2,1);
plot(t, y);
title('Time-Domain signal')
ylabel('Amplitude');
xlabel('Time index');
N=16000;
df = Fs/N;
k= (-Fs/2:df:Fs/2-df);
S=(fft(y,N)); %Discrete Fourier Trasnform
subplot(3,2,3);
plot(k,abs(S));
title('Magnitude of Discrete Fourier Transform');
xlabel('Frequency');
p = unwrap(angle(S));
subplot(3,2,5);
plot(k,p);
title('Phase of Discrete Fourier Transform');
xlabel('Frequency');
snr=5; %Signal to noise ratio
z = awgn(y,snr,'measured'); %Adding noise(AWGN)
Z=(fft(z,N)); %Discrete Fourier Transform on time domain signal
subplot(3,2,4);
plot(k,abs(S),'r');
hold on;
plot(k,abs(Z),'b');
title('Magnitude of Discrete Fourier Transform (with noise)');
xlabel('Frequency');
grid on;
hold off;
legend('Original Signal','Signal with AWGN');
subplot(3,2,6);
plot(k,unwrap(angle(S)),'r');
hold on;
plot(k,unwrap(angle(Z)),'b');
title('Phase of Discrete Fourier Transform (with noise)');
xlabel('Frequency');
grid on;
hold off;
legend('Original Signal','Signal with AWGN');
