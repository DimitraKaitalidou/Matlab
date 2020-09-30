function[N, z, p, k, sos, g] = butterworh_filter(part, f_sampling, Fp, Fs, Rp, Rs, f_type)
% Copyright 2019, Dimitra S. Kaitalidou, All rights reserved
% This function implements a digital Butterworth filter. 

% Funtion inputs:
% part is the part of the code that calls the function
% f_sampling is the sampling frequency
% fp is the passband edge frequency [Hz]
% fs is the stopband edge frequency [Hz] 
% Rp is the passband ripple [dB]
% Rs is the least attenuation in the stopband [dB]
% f_type is the type of the filter, i.e., high, low, stop, bandpass

% Function outputs:
% N is the order of the filter
% z is the vector with the zeroes
% p is the vector with the poles  
% k is the gain
% sos is a second-order section matrix
% g is the gain of sos that is equivalent to the transfer function H(z),
% whose n zeros, m poles, and scalar gain are specified in z, p, and k

f_norm = f_sampling / 2; 

Wp = Fp / f_norm;
Ws = Fs / f_norm;

[N, Wn] = buttord(Wp, Ws, Rp, Rs); 
[z, p, k] = butter(N, Wn, f_type);
[sos, g] = zp2sos(z, p, k);
h = dfilt.df2sos(sos, g);

% Plot and compare the results
hfvt = fvtool(h, 'FrequencyScale', 'log');
legend(hfvt, 'ZPK Design')
title(['Specifications group for part ', num2str(part),': Fp = ', num2str(Fp), ' Fs = ', num2str(Fs), ' Rp = ', num2str(Rp), ' Rs = ', num2str(Rs), ''])
end
