# Dual-Tone Multi-Frequency (DTMF)
- [ ] [`@TeddyDo915K`](https://github.com/TeddyDo915K): Part ~f~, h (5 codes), i

- Dual-tone multi-frequency (DTMF) - The basis for voice communications control and is used worldwide in modern telephony to dial numbers and configure switch board
- DTMF tone - Commonly known as a digit, is a signal consisting the sum of two sinusoid or tones with frequencies from two exclusive groups (low and high group frequency)
  
  A DTMF signal is expressed as $d_N[n] = sin(\omega_on) + sin(\omega_1n)$, where $d_N[n]$ is the digit of keypad of a discrete time index $n$, and $\omega_o$ and $\omega_1$ are the low and high DTMF in radians/sample.

  By using $ω_{o/1} = 2 \times \pi \times \frac {f_{L/H}}{F_s}$ due to the normalized frequency, a DTMF signal is expressed as $d_N[n] = sin(2 \times \pi \times \frac {f_{L}}{F_s} \times n) + sin(2 \times \pi \times \frac {f_{H}}{F_s} \times n)$ in Hz.
- Frequencies are chosen to prevent any harmonic from being incorrectly detected by the receiver as some other DTMF tone

***DTFT[^1] Frequencies for Digits Sampled at F<sub>s</sub> = 8192 Hz***
|  | 1209 Hz | 1336 Hz | 1477 Hz |
| :-: | :-: | :-: | :-: |
| **697 Hz** | 1 | 2 | 3 |
| **770 Hz** | 4 | 5 | 6 |
| **852 Hz** | 7 | 8 | 9 |
| **941 Hz** | * | 0 | # |
- Ex: Digit 1 is represented by the signal $d_1[n] = sin(2 \times \pi \times \frac {697}{F_s} \times n) + sin(2 \times \pi \times \frac{1209}{F_s} \times n)$


# DFT Based Implementation
## DTMF Tones Corresponding to Digits 0-9 When Pressed on a Telephone Keypad[^2]
- **Task:** Listen to each DTMF tones using the MATLAB function `sound`
  
> Output is literally *beep . . . beep . . .*

  
## Corresponding Index $k$ for DTMF Tones[^2][^3]
- **Task:** Compute 2048 samples of $X(e^{j\omega})$ to determine its corresponding index $k$ using the MATLAB function `fft`[^4]
  
### Results

| Frequency (Hz) | Index $k$ |
| :-: | :-: |
| 697 | 175 |
| 770 | 193 |
| 852 | 214 |
| 941 | 236 |
| 1209 | 303 |
| 1336 | 335 |
| 1477 | 370 |


## Energy Spectrum of DTMF for Digit 8[^2]
**Energy Spectrum and Digit 8 Frequencies**
- $|X(e^{j\omega _k})|^2$ - Energy in a signal at frequency $\omega_k$
- Digit 8's DTMF - $f_L$ = 852 Hz and $f_H$ = 1336 Hz
- **Task:** Compute Digit 8's energy $|D_8(e^{j\omega _k})|^2$ using the MATLAB function `ftt`

### Results

***DFT Based Implementation's Magnitude & Energy***
| Frequency (Hz) | Magnitude | Energy |
| :-: | :-: | :-: |
| 697 | 1.9029 | 3.6209 |
| 770 | 13.015 | 169.39 |
| `852` | 500.51 | 2.5051e+05 |
| 941 | 7.1501 | 51.124 |
| 1209 | 6.9656 | 48.519 |
| `1336` | 500.26 | 2.5026e+05 |
| 1477 | 3.0512 | 9.3098 |

</br>

***Energy Spectrum of Digit 8 Using DFT Based Implementation***
![image](https://github.com/user-attachments/assets/2d234e31-44e5-4ab2-b601-fcde5ff898ad)


# Goertzel Algorithm Based Decoder Implementation
## DFT Magnitude and Energy Spectrum of DTMF for Digit 8[^2]
- Goertzel Algorithm - An efficent method to compute the spectrum of a signal when only a small number of spectral values or frequency bins needs computing
  - Full length of DFT does not need to be computed 
- **Task:** Compute Digit 8's DFT magnitude $|D_8[k]|$ and energy $|D_8[k]|^2$ using the MATLAB function `goertzel`[^5]

### Results

***Goertzel Algorithm's DFT Implementation's Magnitude & Energy***
| Frequency (Hz) | Magnitude | Energy |
| :-: | :-: | :-: |
| 697 | 5.4727e-12 | 2.9951e-23 |
| 770 | 8.1237e-13 | 6.5995e-25 |
| `852` | 1024 | 1.0486e+06 |
| 941 | 1.7206e-12 | 2.9604e-24 |
| 1209 | 1.419e-12 | 48.519 |
| `1336` | 1024 | 1.0486e+06 |
| 1477 | 6.9756e-13 | 4.8659e-25 |

</br>

***DFT Magnitude and Energy Spectrum of Digit 8 Using Goertzel Algorithm***
![image](https://github.com/user-attachments/assets/94ef2f46-2160-46d3-a71d-887e54a256fa)


[^1]: Discrete-Time Fourier Transform (DTFT). DTFT {x[n]} ⇔ DTFT<sup>-1</sup> {X(e<sup>jω</sup>)}
[^2]: Code by [`@eoommaa`](https://github.com/eoommaa) (Part A, F, G, and Goertzel Algorithm)
[^3]: Code by [`@TeddyDo915K`](https://github.com/TeddyDo915K) (Part F, H, and I)
[^4]: [MATLAB function `fft` documentation](https://www.mathworks.com/help/matlab/ref/fft.html)
[^5]: [MATLAB function `goertzel` documentation](https://www.mathworks.com/help/signal/ref/goertzel.html?searchHighlight=Goertzel&s_tid=srchtitle_support_results_1_Goertzel)
[^6]: [DFT Estimation with the Goertzel Algorithm](https://www.mathworks.com/help/signal/ug/dft-estimation-with-the-goertzel-algorithm.html)
