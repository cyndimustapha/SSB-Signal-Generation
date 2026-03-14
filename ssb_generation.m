clc;
clear;
close all;

pkg load signal

% Parameters
fm = 10;            % Message frequency (Hz)
fc = 100;           % Carrier frequency (Hz)
fs = 1000;          % Sampling frequency (Hz)
T  = 1;             % Duration (seconds)

t = 0:1/fs:T-1/fs;  % Time vector

% Message signal
m = 2*cos(2*pi*fm*t) + cos(4*pi*fm*t);

% Hilbert transform of message signal
m_hat = imag(hilbert(m));

% Carrier signals
c_cos = cos(2*pi*fc*t);
c_sin = sin(2*pi*fc*t);

% SSB signals
s_USB = m .* c_cos - m_hat .* c_sin;
s_LSB = m .* c_cos + m_hat .* c_sin;

% ---- Time-domain plots ----
figure;
subplot(3,1,1);
plot(t, s_USB);
title('Upper Sideband SSB Signal (Time Domain)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,2);
plot(t, s_LSB);
title('Lower Sideband SSB Signal (Time Domain)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% ---- Envelope computation ----
env_USB = abs(hilbert(s_USB));
env_LSB = abs(hilbert(s_LSB));

subplot(3,1,3);
plot(t, env_USB, 'r', 'LineWidth', 1.5);
hold on;
plot(t, env_LSB, 'b--', 'LineWidth', 1.5);
legend('USB Envelope', 'LSB Envelope');
title('Envelope of USB and LSB SSB Signals');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% ---- Save time-domain figure as JPEG ----
print('SSB_time_domain','-djpeg');

% ---- FFT for amplitude spectrum ----
N = length(t);
f = (-N/2:N/2-1)*(fs/N);

USB_FFT = abs(fftshift(fft(s_USB)))/N;
LSB_FFT = abs(fftshift(fft(s_LSB)))/N;

% ---- Amplitude spectra plots ----
figure;
subplot(2,1,1);
plot(f, USB_FFT);
title('Amplitude Spectrum of USB Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 200]);
grid on;

subplot(2,1,2);
plot(f, LSB_FFT);
title('Amplitude Spectrum of LSB Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 200]);
grid on;

% ---- Save frequency-domain figure as JPEG ----
print('SSB_frequency_spectrum','-djpeg');
