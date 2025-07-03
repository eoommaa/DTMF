% ttdecode(x) Function

function digits = ttdecode(x)
   % ttdecode convert touch tone signals into phone numbers
   % digits = ttdecode(x) x = input signal
  
   % Define DTMF frequencies
   row_freqs = [697, 770, 852, 941];    % Low group frequencies
   col_freqs = [1209, 1336, 1477];      % High group frequencies
  
   % Digit mapping matrix (rows x columns)
   digit_map = {'1', '2', '3';
                '4', '5', '6';
                '7', '8', '9';
                '*', '0', '#'};
  
   % Parameters
   digit_length = 1000;     % Samples per digit
   silence_length = 100;    % Samples of silence between digits to simulate the pause/silence
   segment_length = digit_length + silence_length;
   num_digits = floor(length(x)/segment_length);
   digits = zeros(1, num_digits);       % Preallocate output
  
   % FFT parameters
   N = 2048;                % Number of FFT points
   Fs = 8192;               % Sampling frequency
   f = (0:N-1)*(Fs/N);      % Frequency vector
  
   for i = 1:num_digits
       % Extract current digit segment (skip silence)
       start_idx = (i-1)*segment_length + 1;
       end_idx = min(start_idx + digit_length - 1, length(x));
       digit_signal = x(start_idx:end_idx);
      
       % Compute FFT
       X = abs(fft(digit_signal, N)).^2;
      
       % Find row frequency
       [~, row_idx] = max(X(round(row_freqs*N/Fs + 1)));
      
       % Find column frequency
       [~, col_idx] = max(X(round(col_freqs*N/Fs + 1)));
      
       % Map to digit (using cell array to handle all characters)
       digit_char = digit_map{row_idx, col_idx};
      
       % Convert to numeric (for digits) or keep as character
       if ismember(digit_char, {'0','1','2','3','4','5','6','7','8','9'})
           digits(i) = str2double(digit_char);
       else
           digits(i) = NaN;  % For *, # characters
       end
   end
end


%-----------------------------------------------
% Test signal 1 2 3, each number has to be followed by zeros(1,100) to simulate the pause/silence
phone = [d1, zeros(1,100), d2, zeros(1,100), d3, zeros(1,100), d4, zeros(1,100), d5, zeros(1,100), d6, zeros(1,100), d7, zeros(1,100), d8, zeros(1,100), d9,zeros(1,100), d0, zeros(1,100)];

% Decode and display phone number
testout = ttdecode(phone);
disp('Decoded phone number:');
disp(testout);


%-----------------------------------------------
% Test signal 1 2 3, each number has to be followed by zeros(1,100) to simulate the pause/silence
phone = [d5, zeros(1,100), d5, zeros(1,100), d5, zeros(1,100), d7, zeros(1,100), d3, zeros(1,100), d1, zeros(1,100), d9, zeros(1,100)];

% Decode and display
testout = ttdecode(phone);
disp('Decoded phone number:');
disp(testout);
