% DTMF tones corresponding to digits 0–9 when pressed on a telephone keypad

N = 0:999;          % Sample indices
Fs = 8192;          % Sampling frequency (Hz)
t = N/Fs;           % Time vector (s)

% Define DTMF freq for digits 0-9 in w (omega for [low freq, high freq])
dtmf_freqs = [
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

all_tones = [];     % Matrix to store all tones

% Generate signals d0 to d9
for digit = 0:9
    tone = sin(2*pi*dtmf_freqs(digit+1, 1) * t) + ...
           sin(2*pi*dtmf_freqs(digit+1, 2) * t);    % Sum of 2 sine waves
    % Sum of 2 sine waves is [row #, 1 (low freq) / 2 (high freq)]
    eval(['d' num2str(digit) ' = tone;']);          % Stores the tone in the variable (eg d0-d9)

    all_tones = [all_tones, tone];
    if digit < 9
       all_tones = [all_tones, zeros(1, round(Fs))];
   end
end

% Listen to each signal using 'sound'
for digit = 0:9
    fprintf('Playing digit %d...\n', digit);
    eval(['sound(d' num2str(digit) ', Fs);']);      % Play the digit
    pause(1);
end

save('dtmf_signals.mat', 'd0', 'd1', 'd2', 'd3', 'd4', 'd5', 'd6', 'd7', 'd8', 'd9');       % Saves all signals one by one
sound(all_tones, Fs);               % Play the concatenated signal
audiowrite('signal_sound.wav', all_tones, Fs);
