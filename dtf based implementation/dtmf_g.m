% Energy Spectrum of DTMF for Digit 8 Using DFT Based Implementation

load('dtmf_signals.mat', 'd8');     % Load DTMF signal for digit 8 (d8)
Fs = 8192;      % Sampling frequency
N = 2048;       % FFT size

% Compute FFT of the signal
D8 = fft(d8, N);
mag = abs(D8);      % Magnitude spectrum
energy = mag.^2;    % Energy spectrum

% Define all DTMF. Note: DTMF for d8 is [852, 1336]
d8_freqs = [852, 1336];
dtmf_freqs = unique([697, 770, 852, 941, 1209, 1336, 1477]);

% Compute DTMF to FFT bin indices
k_indices = round(dtmf_freqs * N / Fs) + 1;

% Find peak locations near d8's DTMF
[peaks, locs] = findpeaks(energy(1:N/2), 'SortStr', 'descend', 'NPeaks', 2);
freq_axis = (0:N-1)*Fs/N;           % Freq axis
peak_freqs = freq_axis(locs);       % Actual DTMF where peaks occur

% Extract mag and energy at all DTMF
dtmf_mag = mag(k_indices);
dtmf_energy = energy(k_indices);

% Display results
disp('DFT Based Implementation''s Magnitude & Energy:');
disp(table(dtmf_freqs(:), dtmf_mag(:), dtmf_energy(:), 'VariableNames', {'Frequency (Hz)', 'Magnitude', 'Energy'}));
%disp('DFT Based Implementation''s Energy:');
%disp(table(dtmf_freqs(:), dtmf_energy(:), 'VariableNames', {'Frequency (Hz)', 'Energy'}));


%-----------------------------------------------
% Plot the energy spectrum
figure;
plot(freq_axis(1:N/2), energy(1:N/2))   % Plot up to Nyquist freq
hold on;
stem(dtmf_freqs, dtmf_energy);
stem(peak_freqs, peaks);                % d8's DTMF
% Add labels and titles
xlabel('Frequency (Hz)');
ylabel('Energy |D(e^{jω})|^{2}');
title('Energy Spectrum of Digit 8 Using DFT Based Implementation');
legend('Energy', 'DTMF', 'd8''s DTMF (852 Hz & 1336 Hz)');
grid on;
xlim([600, 1500]);      % Zoom to DTMF range
