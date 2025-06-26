% Corresponding Index k for the DTMF Frequencies

load touch.mat;         % Load the file
x = x1;                 % Use x1 as the signal
N = 2048;
fs = 8192;              % Sampling rate
X = fft(x, N);
f = (0:N-1) * fs / N;
freqs = [697 770 852 941 1209 1336 1477];    % DTMF

% Determine the corresponding index k that is the closest to each touch-tone frequencies
for i = 1:length(freqs)
  [~, k] = min(abs(f - freqs(i)));
  disp([num2str(freqs(i)) ' Hz is at index k = ' num2str(k)]);
end
