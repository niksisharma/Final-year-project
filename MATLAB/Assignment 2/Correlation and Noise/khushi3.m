
%generating signal

clear all;
close all;

%initialization of signals
fc=1500; % Carrier Frequency
fm=250; % Modulating Frequency
fs=10000; % Sampling Frequency
m=2; % Modulating Index
t=0:1/fs:0.1; % Time sampling with step 
  
c=sin(2*pi*fc*t); % Carrier Signal
M=sin(2*pi*fm*t); % Modulating Signal

%plot carrier
subplot(6,1,1);
plot (t,c);
ylabel('Amplitude');
xlabel('Time index');
title('Carrier signal ');

%plot message
subplot(6,1,2);
plot (t,M);
ylabel('Amplitude');
xlabel('Time index');
title('Modulating Signal');

%%
% Frequency Modulation
y=sin(2*pi*fc*t+(m.*sin(2*pi*fm*t))); 

%plot message
subplot(6,1,3);
plot (t,y);
ylabel('Amplitude');
xlabel('Time index');
title('Frequency Modulated Signal');

%%

% performing autocorrelation
auto_y = xcorr(y,y); 
t1=t;
t2=-fliplr(t);
n1=min(t1)+min(t2);
n2=max(t1)+max(t2);
n=n1:0.0001:n2;

% plot autocorrelation
subplot(6,1,4);
plot(n,auto_y);
ylabel('Amplitude');
xlabel('Time index');
title('Autocorrelation of the Signal');
grid on;

%%

%adding noise
snr=5;
z = awgn(y,snr,'measured');

% plot noise affected signal
subplot(6,1,5); 
plot(t, y, 'r');
hold on; % puts the next graph on the same plot
plot(t, z, 'b');
xlabel('Time');
ylabel('Amplitude');
title('Signal After Addition of Noise');
grid on;
hold off;

legend('Original Signal','Signal with AWGN');

%%

% performing autocorrelation
auto_y2 = xcorr(z,z); 
t1=t;
t2=-fliplr(t);
n1=min(t1)+min(t2);
n2=max(t1)+max(t2);
n=n1:0.0001:n2;

% plot autocorrelation
subplot(6,1,6);
plot(n,auto_y2);
ylabel('Amplitude');
xlabel('Time index');
title('Autocorrelation of the Signal After Noise Application');
grid on;
