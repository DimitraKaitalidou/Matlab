% Copyright 2020, Dimitra S. Kaitalidou, All rights reserved
% This matlab script performs digital signal processing on an ECG signal.

close all
clear all

% =========================================================================
% Noise removal from ECG
% =========================================================================

% Read the input signal
load ecg.mat
[N_ecg] = size(ecg);
sampling_freq = 500; %Hz

% PART 1: Normalization and single-sided amplitude spectrum

ecg_norm_t_1 = ecg / max(abs(ecg));
t = (1:N_ecg) / sampling_freq;
[f, ecg_norm_f_1, NFFT] = DFT(sampling_freq, ecg_norm_t_1);

figure
subplot(2, 1, 1)
plot(t, ecg_norm_t_1, 'r')
title('Part 1. Normalization and single-sided amplitude spectrum')
xlabel('Time [s]')
ylabel('Normalized ECG')
axis tight
subplot(2, 1, 2)
plot(f, 2 * abs(ecg_norm_f_1(1:NFFT / 2 + 1)), 'r'); 
xlabel('Frequency [Hz]')
ylabel('2*|Ecg|')
axis tight

% PART 2: High pass Butterworth filter

Fp_2 = 0.5; %Hz
Fs_2 = 0.45; %Hz
Rp_2 = 3; %dB
Rs_2 = 5; %dB
f_type_2 = 'high';
[N_2, z_2, p_2, k_2, sos_2, g_2] = butterworh_filter(2, sampling_freq, Fp_2, Fs_2, Rp_2, Rs_2, f_type_2);

ecg_t_2 = filtfilt(sos_2, g_2, ecg_norm_t_1);
ecg_norm_t_2 = ecg_t_2 / max(abs(ecg_t_2));
[f, ecg_norm_f_2, NFFT] = DFT(sampling_freq, ecg_norm_t_2);

figure
axis tight
subplot(3, 1, 1)
plot(t, ecg_norm_t_1, 'r');
title('Part 2. Patient motion noise removal')
xlabel('Time [s]')
ylabel('Normalized ECG')
hold on
plot(t, ecg_norm_t_2, 'g')
legend('Before Butterworth HPF', 'After Butterworth HPF')
axis tight
subplot(3, 1, 2)
plot(f, 2 * abs(ecg_norm_f_1(1:NFFT / 2 + 1)), 'r');
xlabel('Frequency [Hz]')
ylabel('2*|Ecg|')
hold on
plot(f, 2 * abs(ecg_norm_f_2(1:NFFT / 2 + 1)), 'g');
legend('Before Butterworth HPF', 'After Butterworth HPF')
axis tight
subplot(3, 1, 3)
plot(f(1:100), 2 * abs(ecg_norm_f_1(1:100)), 'r');
xlabel('Frequency [Hz]')
ylabel('2*|Ecg|')
hold on
plot(f(1:100), 2 * abs(ecg_norm_f_2(1:100)), 'g');
legend('Before Butterworth HPF', 'After Butterworth HPF')
axis tight

% Part 3: Notch Butterworth filter

Fp_3 = [47 53]; %Hz
Fs_3 = [49 51]; %Hz
Rp_3 = 3; %dB
Rs_3 = 20; %dB
f_type_3 = 'stop';
[N_3, z_3, p_3, k_3, sos_3, g_3] = butterworh_filter(3, sampling_freq, Fp_3, Fs_3, Rp_3, Rs_3, f_type_3);

ecg_t_3 = filtfilt(sos_3, g_3, ecg_norm_t_1);
ecg_norm_t_3 = ecg_t_3 / max(abs(ecg_t_3));
[f, ecg_norm_f_3, NFFT] = DFT(sampling_freq, ecg_norm_t_3);

figure
subplot(3, 1, 1)
plot(t, ecg_norm_t_1, 'r')
title('Part 3: Power supply network noise removal')
xlabel('Time [s]')
ylabel('Normalized ECG')
hold on
plot(t, ecg_norm_t_2, 'g')
plot(t, ecg_norm_t_3, 'b')
legend('Before Butterworth', 'After Butterworth HPF', 'After Butterworth Notch Filter')
axis tight
subplot(3, 1, 2)
plot(f, 2 * abs(ecg_norm_f_1(1:NFFT / 2 + 1)), 'r');
xlabel('Frequency [Hz]')
ylabel('2*|Ecg|')
hold on
plot(f, 2 * abs(ecg_norm_f_2(1:NFFT / 2 + 1)), 'g');
plot(f, 2 * abs(ecg_norm_f_3(1:NFFT / 2 + 1)), 'b');
legend('Before Butterworth', 'After Butterworth HPF', 'After Butterworth Notch Filter')
axis tight
subplot(3, 1, 3)
plot(f(500:1000), 2 * abs(ecg_norm_f_1(500:1000)), 'r');
xlabel('Frequency [Hz]')
ylabel('2*|Ecg|')
hold on
plot(f(500:1000), 2 * abs(ecg_norm_f_2(500:1000)), 'g');
plot(f(500:1000), 2 * abs(ecg_norm_f_3(500:1000)), 'b');
legend('Before Butterworth', 'After Butterworth HPF', 'After Butterworth Notch Filter')
axis tight

% Part 4: Low pass Butterworth filters

% Specifications group 1
fp_4_1 = 40; %Hz
fs_4_1 = 49; %Hz
Rp_4_1 = 3; %dB
Rs_4_1 = 40; %dB
f_type_4_1 = 'low';
[N_4_1, z_4_1, p_4_1, k_4_1, sos_4_1, g_4_1] = butterworh_filter(4.1, sampling_freq, fp_4_1, fs_4_1, Rp_4_1, Rs_4_1, f_type_4_1);
ecg_t_4_1 = filtfilt(sos_4_1, g_4_1, ecg_norm_t_1);
ecg_norm_t_4_1 = ecg_t_4_1 / max(abs(ecg_t_4_1));
[f, ecg_norm_f_4_1, NFFT] = DFT(sampling_freq, ecg_norm_t_4_1);

figure
subplot(2, 1, 1)
plot(t, ecg_norm_t_1, 'r')
title('Part 4.1: High frequency noise removal')
xlabel('Time [s]')
ylabel('Normalized ECG')
hold on
plot(t, ecg_norm_t_4_1, 'g')
legend('Before Butterworth LPF', 'After Butterworth LPF')
axis tight
subplot(2, 1, 2)
plot(f, 2 * abs(ecg_norm_f_1(1:NFFT / 2 + 1)), 'r');
xlabel('Frequency [Hz]')
ylabel('2*|Ecg|')
hold on
plot(f, 2 * abs(ecg_norm_f_4_1(1:NFFT / 2 + 1)), 'g');
legend('Before Butterworth LPF', 'After Butterworth LPF')
axis tight

% Specifications group 2
fp_4_2 = 30; %Hz
fs_4_2 = 40; %Hz
Rp_4_2 = 3; %dB
Rs_4_2 = 40;%dB
f_type_4_2 = 'low';
[N_4_2, z_4_2, p_4_2, k_4_2, sos_4_2, g_4_2] = butterworh_filter(4.2, sampling_freq, fp_4_2, fs_4_2, Rp_4_2, Rs_4_2, f_type_4_2);
ecg_t_4_2 = filtfilt(sos_4_2, g_4_2, ecg_norm_t_1);
ecg_norm_t_4_2 = ecg_t_4_2 / max(abs(ecg_t_4_2));
[f, ecg_norm_f_4_2, NFFT] = DFT(sampling_freq, ecg_norm_t_4_2);

figure
subplot(2, 1, 1)
plot(t, ecg_norm_t_1, 'r')
title('Part 4.2: High frequency noise removal')
xlabel('Time [s]')
ylabel('Normalized ECG')
hold on
plot(t, ecg_norm_t_4_2, 'g')
legend('Before Butterworth LPF', 'After Butterworth LPF')
axis tight
subplot(2, 1, 2)
plot(f, 2 * abs(ecg_norm_f_1(1:NFFT / 2 + 1)), 'r');
xlabel('Frequency [Hz]')
ylabel('2*|Ecg|')
hold on
plot(f, 2 * abs(ecg_norm_f_4_2(1:NFFT / 2 + 1)),'g');
legend('Before Butterworth LPF', 'After Butterworth LPF')
axis tight

% Specifications group 3
fp_4_3 = 30; %Hz
fs_4_3 = 45; %Hz
Rp_4_3 = 3; %dB
Rs_4_3 = 40;%dB
f_type_4_3 = 'low';
[N_4_3, z_4_3, p_4_3, k_4_3, sos_4_3, g_4_3] = butterworh_filter(4.3, sampling_freq, fp_4_3, fs_4_3, Rp_4_3, Rs_4_3, f_type_4_3);
ecg_t_4_3 = filtfilt(sos_4_3, g_4_3, ecg_norm_t_1);
ecg_norm_t_4_3 = ecg_t_4_3 / max(abs(ecg_t_4_3));
[f, ecg_norm_f_4_3, NFFT] = DFT(sampling_freq, ecg_norm_t_4_3);

figure
subplot(2, 1, 1)
plot(t, ecg_norm_t_1, 'r')
title('Part 4.3: High frequency noise removal')
xlabel('Time [s]')
ylabel('Normalized ECG')
hold on
plot(t, ecg_norm_t_4_3, 'g')
legend('Before Butterworth LPF', 'After Butterworth LPF')
axis tight
subplot(2, 1, 2)
plot(f, 2 * abs(ecg_norm_f_1(1:NFFT / 2 + 1)), 'r');
xlabel('Frequency [Hz]')
ylabel('2*|Ecg|')
hold on
plot(f, 2 * abs(ecg_norm_f_4_3(1:NFFT / 2 + 1)), 'g');
legend('Before Butterworth LPF', 'After Butterworth LPF')
axis tight

% Specifications group 4
fp_4_4 = 30; %Hz
fs_4_4 = 48; %Hz
Rp_4_4 = 3; %dB
Rs_4_4 = 40; %dB
f_type_4_4= 'low';
[N_4_4, z_4_4, p_4_4, k_4_4, sos_4_4, g_4_4] = butterworh_filter(4.4, sampling_freq, fp_4_4, fs_4_4, Rp_4_4, Rs_4_4, f_type_4_4);
ecg_t_4_4 = filtfilt(sos_4_4, g_4_4, ecg_norm_t_1);
ecg_norm_t_4_4 = ecg_t_4_4 / max(abs(ecg_t_4_4));
[f, ecg_norm_f_4_4, NFFT] = DFT(sampling_freq, ecg_norm_t_4_4);

figure
subplot(2, 1, 1)
plot(t, ecg_norm_t_1, 'r')
title('Part 4.4: High frequency noise removal')
xlabel('Time [s]')
ylabel('Normalized ECG')
hold on
plot(t, ecg_norm_t_4_4, 'g')
legend('Before Butterworth LPF', 'After Butterworth LPF')
axis tight
subplot(2, 1, 2)
plot(f, 2 * abs(ecg_norm_f_1(1:NFFT / 2 + 1)), 'r');
xlabel('Frequency [Hz]')
ylabel('2*|Ecg|')
hold on
plot(f, 2 * abs(ecg_norm_f_4_4(1:NFFT / 2 + 1)), 'g');
legend('Before Butterworth LPF', 'After Butterworth LPF')
axis tight

% Specifications group 5
fp_4_5 = 30; %Hz
fs_4_5 = 48; %Hz
Rp_4_5 = 3; %dB
Rs_4_5 = 60; %dB
f_type_4_5= 'low';
[N_4_5, z_4_5, p_4_5, k_4_5, sos_4_5, g_4_5] = butterworh_filter(4.5, sampling_freq, fp_4_5, fs_4_5, Rp_4_5, Rs_4_5, f_type_4_5);
ecg_t_4_5 = filtfilt(sos_4_5, g_4_5, ecg_norm_t_1);
ecg_norm_t_4_5 = ecg_t_4_5 / max(abs(ecg_t_4_5));
[f, ecg_norm_f_4_5, NFFT] = DFT(sampling_freq, ecg_norm_t_4_5);

figure
subplot(2, 1, 1)
plot(t, ecg_norm_t_1, 'r')
title('Part 4.5: High frequency noise removal')
xlabel('Time [s]')
ylabel('Normalized ECG')
hold on
plot(t, ecg_norm_t_4_5, 'g')
legend('Before Butterworth LPF', 'After Butterworth LPF')
axis tight
subplot(2, 1, 2)
plot(f, 2*abs(ecg_norm_f_1(1:NFFT / 2 + 1)), 'r');
xlabel('Frequency [Hz]')
ylabel('2*|Ecg|')
hold on
plot(f, 2 * abs(ecg_norm_f_4_5(1:NFFT / 2 + 1)), 'g');
legend('Before Butterworth LPF', 'After Butterworth LPF')
axis tight

% Save the best signal produced by the LPF Butterworth filters
ecg_norm_t_4 = ecg_norm_t_4_4;
ecg_norm_f_4 = ecg_norm_f_4_4;

figure
subplot(2, 1, 1)
plot(t, ecg_norm_t_1, 'r')
title('Part 4: Best signal from LPF Butterworth filters')
xlabel('Time [s]')
ylabel('Normalized ECG')
hold on
plot(t, ecg_norm_t_2, 'g')
plot(t, ecg_norm_t_3, 'b')
plot(t, ecg_norm_t_4, 'black')
legend('ECG part 1', 'ECG part 2', 'ECG part 3', 'ECG part 4')
axis tight
subplot(2, 1, 2)
plot(f, 2 * abs(ecg_norm_f_1(1:NFFT / 2 + 1)), 'r');
xlabel('Frequency [Hz]')
ylabel('2*|Ecg|')
hold on
plot(f, 2 * abs(ecg_norm_f_2(1:NFFT / 2 + 1)), 'g');
plot(f, 2 * abs(ecg_norm_f_3(1:NFFT / 2 + 1)), 'b');
plot(f, 2 * abs(ecg_norm_f_4(1:NFFT / 2 + 1)), 'black');
legend('ECG part 1', 'ECG part 2', 'ECG part 3', 'ECG part 4')
axis tight

% PART 5: Final ECG

ecg_norm_t_5 = filtfilt(sos_3, g_3, ecg_norm_t_2);
ecg_norm_t_5 = ecg_norm_t_5 / max(abs(ecg_norm_t_5));
ecg_norm_t_5 = filtfilt(sos_4_4, g_4_4, ecg_norm_t_5);
ecg_norm_t_5 = ecg_norm_t_5 / max(abs(ecg_norm_t_5));
[f, ecg_norm_f_5, NFFT] = DFT(sampling_freq, ecg_norm_t_5);

figure
subplot(2, 1, 1)
plot(t, ecg_norm_t_1, 'r')
title('Part 5: Final ECG')
xlabel('Time [s]')
ylabel('Normalized ECG')
hold on
plot(t, ecg_norm_t_5, 'g')
legend('Original ECG', 'Cleared ECG')
axis tight
subplot(2, 1, 2)
plot(f, 2 * abs(ecg_norm_f_1(1:NFFT / 2 + 1)), 'r');
xlabel('Frequency [Hz]')
ylabel('2*|Ecg|')
hold on
plot(f, 2 * abs(ecg_norm_f_5(1:NFFT / 2 + 1)), 'g');
legend('Original ECG', 'Cleared ECG')
axis tight

% =========================================================================
% ECG analysis
% =========================================================================

% Find all local maxima and minima
[local_min, p_local_min] = islocalmin(ecg_norm_t_5);
[local_max, p_local_max] = islocalmax(ecg_norm_t_5);
all_peaks = ecg_norm_t_5(local_min | local_max);
all_locs = find(p_local_min | p_local_max);
[N_all_peaks] = size(all_peaks);

% Find the R peaks
r_peaks = all_peaks;
r_locs = all_locs;

for i = 1:N_all_peaks
    if r_peaks(i) < 0.45 
        r_peaks(i) = 0;
        r_locs(i) = 0;
    end
end

% Find the QRS complex
qrs_peaks = zeros(N_all_peaks);
qrs_locs = zeros(N_all_peaks);

for i = 2:N_all_peaks
    if r_peaks(i) ~= 0 
        qrs_peaks(i - 1) = all_peaks(i - 1);
        qrs_locs(i - 1) = all_locs(i - 1);
        qrs_peaks(i) = all_peaks(i);
        qrs_locs(i) = all_locs(i);
        qrs_peaks(i + 1) = all_peaks(i + 1);
        qrs_locs(i + 1) = all_locs(i + 1);
    end
end

% Clear the arrays
r_peaks = r_peaks(r_peaks ~= 0);
r_locs = r_locs(r_locs ~= 0);
[N_r_peaks] = size(r_peaks);
qrs_peaks = qrs_peaks(qrs_peaks ~= 0);
qrs_locs = qrs_locs(qrs_locs ~= 0);

figure
plot(t, ecg_norm_t_5, 'r')
title('ECG analysis: QRS complex')
xlabel('Time [s]')
ylabel('Normalized ECG')
hold on
plot(t(qrs_locs), qrs_peaks, 'g', 'linestyle', 'none', 'marker', 'o')
plot(t(r_locs), r_peaks, 'b', 'linestyle', 'none', 'marker', '*')
legend('Cleared ECG', 'QRS', 'R peaks')
axis tight

% Find the RR intervals and the heart rate in beats per minute
r_locs_diff = zeros(N_r_peaks - 1);
rr_int = zeros(N_r_peaks - 1);
for i = 2:N_r_peaks
    r_locs_diff(i - 1) = r_locs(i) - r_locs(i - 1);
    rr_int(i - 1) = r_locs_diff(i - 1) / sampling_freq; %sec
end
heart_rate = 60 / mean(rr_int)
