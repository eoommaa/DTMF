% Digit 012 Spectrogram

N = 0:999;          % Sample indices
Fs = 8192;          % Sampling frequency (Hz)
t = N/Fs;           % Time vector (s)

% Define DTMF frequencies for digits 0-9 [low freq, high freq]
dtmf = [
    941, 1336;      % 0
    697, 1209;      % 1
    697, 1336;      % 2
    697, 1477;      % 3
    770, 1209;      % 4
    770, 1336;      % 5
    770, 1477;      % 6
    852, 1209;      % 7
    852, 1336;      % 8
    852, 1477       % 9
];

dialed_digits = [0, 1, 2];
full_signal = [];                               % Matrix to store dialed digits
silence = zeros(1, round(0.05*Fs));             % Add silence after the digit
dtmf_freq = zeros(length(dialed_digits), 2);    % Pre-allocate matrix
digit_num = [];                                 % Store Digit 012 numbers

for digit = dialed_digits
    dtmf_signal = sin(2*pi*dtmf(digit+1, 1) * t) + ...
        sin(2*pi*dtmf(digit+1, 2) * t);                     % Sum of 2 sine waves
    full_signal = [full_signal, dtmf_signal, silence];      % Append to full signal (3-digit signal)
end


%-----------------------------------------------
% Create a subplot for 3-digit DTMF time and freq domain signal
time = (length(full_signal)-1)/Fs;                      % Total time of full signal
time_axis = linspace(0, time, length(full_signal));     % Time axis for the full signal

% Plot time domain for 3-digit DTMF signal
figure('Position', [0, 0, 830, 740]);
subplot(2,1,1);
plot(time_axis*1000, full_signal);      % Convert to ms
% Add labels and titles
xlabel('Time (ms)');
ylabel('Amplitude');
title('Digit 012 DTMF Signal');
grid on;
xlim([0, 520]);

% Plot freq domain for 3-digit DTMF signal
subplot(2,1,2);
[P, F] = pspectrum(full_signal, Fs, 'Leakage', 1, 'FrequencyLimits', [650, 1500]);
plot(F, 10*log10(P));
% Add labels and titles
xlabel('Frequency (Hz)');
ylabel('Power Spectrumn (dB)');
title('Digit 012 Power Spectrum');
grid on;
xlim([650, 1500]);


%-----------------------------------------------
% Create a subplot for individual DTMF power spectra
figure('Position', [0, 0, 1500, 1000]);
for i = 1:length(dialed_digits)
    digit = dialed_digits(i);
    dtmf_signal = sin(2*pi*dtmf(digit+1, 1) * t) + sin(2*pi*dtmf(digit+1, 2) * t);
    full_signal = [full_signal, dtmf_signal, silence];
       
    % Compute power spectrum
    [P, F] = pspectrum(dtmf_signal, Fs);
    valid_idx = F >= 600 & F <= 1600;
    F = F(valid_idx);       % Keep only freq between 600-1500 Hz based on valid_idx
    P = P(valid_idx);

    % Find DTMF peaks for each 3-digit signal
    [~, locs] = findpeaks(P, 'SortStr', 'descend', 'NPeaks', 2);
    peak_freqs = sort(F(locs));
    dtmf_freq(i,:) = peak_freqs;
    digit_num = [digit_num; digit];

    % Create a subplot for each digit power spectrum
    subplot(length(dialed_digits), 1, i);
    % Plot each digit's spectrum & DTMF peaks in dB
    spectrum = plot(F, 10*log10(P));
    hold on;
    dtmf_peaks = plot(dtmf_freq(i,:), 10*log10(P(locs)), 'o');
    hold off;
    
    % Add labels and titles
    xlabel('Frequency (Hz)');
    ylabel('Power (dB)');
    xlim([600, 1600]);
    title(['Digit ', num2str(digit), ' Power Spectrum']);
    grid on;
    % Digit's DTMF and legend
    digit_dtmf = sprintf('%d Hz & %d Hz', round(dtmf_freq(i,1)), round(dtmf_freq(i,2)));
    legend([spectrum, dtmf_peaks], ...
        'Power Spectrum', ...
        ['Digit ', num2str(digit), '''s DTMF (', digit_dtmf, ')']);
end

% Display 3-digit freq peaks
freq_table = table(digit_num, round(dtmf_freq(:,1)), round(dtmf_freq(:,2)), ...
    'VariableNames', {'Digit', 'Low Frequency (Hz)', 'High Frequency (Hz)'});
disp('3-Digit DTMF Peak Frequencies:');
disp(freq_table);


%-----------------------------------------------
% Create a subplot for 3-digit DTMF signal spectrogram
% Plot 3-digit DTMF signal spectrogram w/o freq res & overlap
figure('Position', [0, 0, 830, 740]);
subplot(2,2,1);
pspectrum(full_signal,Fs,"spectrogram",Leakage=1,OverlapPercent=0, ...
    MinThreshold=-10,FrequencyLimits=[650, 1500]);
% Add labels and titles
xlabel('Time (ms)');
ylabel('Frequency');
xlim([0, 0.5]);

% Trade off time and freq res to get the best rep of 3-digit signal
% Plot 3-digit DTMF w/ freq res = 50 & overlap = 50% (common overlap) 
subplot(2,2,2);
pspectrum(full_signal,Fs,"spectrogram",FrequencyResolution=50, ...
    OverlapPercent=50,MinTHreshold=-60,FrequencyLimits=[650, 1500])
% Add labels and titles
xlabel('Time (ms)');
ylabel('Frequency');
xlim([0, 0.5]);

% Plot 3-digit DTMF w/ freq res = 90 & overlap = 90%
subplot(2,2,3);
pspectrum(full_signal,Fs,"spectrogram",FrequencyResolution=90, ...
    OverlapPercent=99,MinTHreshold=-60,FrequencyLimits=[650, 1500])
% Add labels and titles
xlabel('Time (ms)');
ylabel('Frequency');
xlim([0, 0.5]);

% Plot 3-digit DTMF w/ freq res = 150 & overlap = 99%
subplot(2,2,4);
pspectrum(full_signal,Fs,"spectrogram",FrequencyResolution=150, ...
    OverlapPercent=99,MinTHreshold=-60,FrequencyLimits=[650, 1500])
% Add labels and titles
xlabel('Time (ms)');
ylabel('Frequency');
xlim([0, 0.5]);
