% DFT Magnitude and Energy Spectrum of DTFT for Digit 8 Using Goertzel Algorithm

Fs = 8192;          % Sampling freq
N = 2048;           % Number of FFT points
t = (0:N-1)/Fs;     % Time vector (s). 0:N-1 represents FFT bin indices

% Low & high DTMF of d8
lf = 852;
hf = 1336;

d8_lf = sin(2*pi*lf*t);
d8_hf = sin(2*pi*hf*t);
d8_signal = d8_lf + d8_hf;      % Sum of d8 signal

dtmf_freqs = [697 770 852 941 1209 1336 1477];
k = round(dtmf_freqs/Fs*N) + 1;

% Compute DFT magnitudes & energy using Goertzel
ydft = zeros(length(dtmf_freqs), 1);             % Single tone for d8
ydft(:, 1) = abs(goertzel(d8_signal, k));        % Stores the magnitudes for the tone

dft_mag = abs(goertzel(d8_signal, k));
energy = dft_mag.^2;

% Display results
disp('Goertzel Algorithm''s DFT Magnitude and Energy:');
disp(table(dtmf_freqs(:), ydft(:), energy(:), 'VariableNames', {'Frequency (Hz)', 'Magnitude', 'Energy'}));


%-----------------------------------------------
% Create a subplot for d8's DFT magnitude and energy
figure('Position', [0, 0, 830, 740]);

% Plot d8's DFT magnitude
subplot(2,1,1)
stem(dtmf_freqs, ydft)
hold on
d8_freqs = [852, 1336];
[~, idx] = ismember(d8_freqs, dtmf_freqs);      % Find indices of d8 freq
stem(dtmf_freqs(idx), ydft(idx));               % d8's DTMF
% Add labels and titles
xlabel("Frequency (Hz)")
ylabel("DFT Magnitude |X[k]|")
title('DFT Magnitude of Digit 8 Using Goertzel Algorithm')
legend('Magnitude', 'd8''s DTMF (852 Hz & 1336 Hz)')
grid on
ylim([0, 1400]);

% Plot d8's energy
subplot(2,1,2)
stem(dtmf_freqs, energy)
hold on
d8_freqs = [852, 1336];
[~, idx] = ismember(d8_freqs, dtmf_freqs);      % Find indices of d8 freq
stem(dtmf_freqs(idx), energy(idx));             % d8's DTMF freqs
% Add labels and titles
xlabel("Frequency (Hz)")
ylabel("Energy |X[k]|^{2}")
title('Energy Spectrum of Digit 8 Using Goertzel Algorithm')
legend('Energy', 'd8''s DTMF (852 Hz & 1336 Hz)')
grid on
ylim([0, 14*10^5]);
