% ttdecode2 Function

function digits = ttdecode2(x)
   % ttdecode2 convert touch tone signals into phone numbers that has a
   % variable silence period
  
   % Define DTMF frequencies
   row_freqs = [697, 770, 852, 941];
   col_freqs = [1209, 1336, 1477];
   digit_map = {'1', '2', '3';
                '4', '5', '6';
                '7', '8', '9';
                '*', '0', '#'};
  
   % Parameters
   Fs = 8192;            % Sampling frequency
   N = 2048;             % FFT size
   min_tone_len = 100;   % Minimum tone duration
   energy_thresh = 0.01; % Energy threshold for detecting tones
   win = 100;            % Window size for short-time energy
   % Compute short-time energy
   energy = movsum(x.^2, win);
  
   % Identify tone segments (where energy > threshold)
   is_tone = energy > energy_thresh;
   tone_start = find(diff([0 is_tone]) == 1);
   tone_end = find(diff([is_tone 0]) == -1);
   % Filter out very short tones
   valid = (tone_end - tone_start) >= min_tone_len;
   tone_start = tone_start(valid);
   tone_end = tone_end(valid);
   % Initialize digit output
   digits = zeros(1, length(tone_start));
   % Loop through detected tones
   for i = 1:length(tone_start)
       segment = x(tone_start(i):tone_end(i));
       X = abs(fft(segment, N)).^2;
       % Identify row and column frequencies
       [~, row_idx] = max(X(round(row_freqs*N/Fs + 1)));
       [~, col_idx] = max(X(round(col_freqs*N/Fs + 1)));
       % Map to digit
       digit_char = digit_map{row_idx, col_idx};
       if ismember(digit_char, {'0','1','2','3','4','5','6','7','8','9'})
           digits(i) = str2double(digit_char);
       else
           digits(i) = NaN; % Use NaN for '*', '#'
       end
   end
end


%-----------------------------------------------
disp('Digits from hardx1:');
digits1 = ttdecode2(hardx1);
disp(digits1);
disp('Digits from hardx2:');
digits2 = ttdecode2(hardx2);
disp(digits2);
