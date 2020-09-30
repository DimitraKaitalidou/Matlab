# DSP on ECG

## Introduction

The electrocardiogram (ECG) is a graphical representation of a bioelectrical signal that is produced by the human body during the cardiac cycle. The ECG signal shows graphically useful information regarding the function of the heart. This information comes from the representation of the cardiac voltage (which is extracted by placing electrodes on specific places of the human body) during a period of time in a wave form. The ECG signal, as any other signal, can be analyzed and processed in two domains, i.e., the time and the frequency domain.

The P, Q, R, S and T are specific wave forms that are recognized in the ECG signal in the time domain. The amplitude of the bioelectrical waves is measured in mV. Despite the fact that the values of the amplitudes are small, they can be measured with traditional measuring devices, but they still need to be amplified.

It is important to note that along with the signal, there is noise, which comes from different sources during the measurement of the ECG signal, e.g., patient motion noise, noise from power supply, etc. The analysis in the frequency domain helps to understand how these unwanted sources affect the measured signal in the time domain. To eliminate them from the signal measured by the electrodes, the signal is processed digitally following the procedure described below. After the removal of the noise, useful information can be extracted from the cleared ECG, such as the RR interval, the heart rate, etc.

## Noise removal from ECG
An ECG recording (ecg.mat file) obtained with a sampling frequency of 500Hz can be found in this repository. The recording is not so good, so it needs to be processed before the cardiologist analyzes it. Particularly:
1. The amplitude of the ECG signal is normalized in the range [-1: 1] and displayed in the time and frequency domain. The signal in the frequency domain is produced by finding its spectral content via Discrete Fourier Transform (DFT). Inspecting the produced figure the following conclusions are made:
   - The absolute value of the amplitude (and therefore the energy of the signal) is concentrated in frequencies smaller than 50Hz and it declines as the frequency rises
   - Specifically, before the 0.5Hz it reaches the maximum value and then it falls to values less than the half
   - A peak is observed at 50Hz
   - Finally, after 30Hz there is significant decrease in amplitude which is caused by other interference, e.g., RF noise from the equipment
2. In order to eliminate the patient motion noise, a high pass Butterworth filter that cuts off frequencies lower than 0.5Hz is applied to the ECG signal: 
   - The bilinear transform is used to implement the filter
   - Filter parameter selection: As the filter is high pass, the ftype input parameter of the function butter() is ‘high’. The passband edge frequency F<sub>p</sub> is chosen to be 0.5Hz and the cutoff edge frequency F<sub>s</sub> is chosen to be 0.45Hz, so that it is close to F<sub>p</sub> but still F<sub>s</sub> < F<sub>p</sub>. The fluctuations in the passband and stopband frequency zones were selected after testing in order to achieve monotony-smoothness of the filter without raising its order too much and making it as fast as possible (R<sub>p</sub> = 3, R<sub>s</sub> = 5)
3. The 50 Hz noise is produced by the power supply network. It is removed from the ECG signal by using a notch Butterworth filter:
   - The bilinear transform is used to implement the filter
   - Filter parameter selection: As the filer is a notch filter, the ftype input parameter of the function butter() is ‘stop’. The passband edge frequency F<sub>p</sub> is chosen to be [47 53]Hz and the cutoff edge frequency F<sub>s</sub> is chosen to be [49 51]Hz, so that they are close to F<sub>p</sub> but still F<sub>pa</sub> < F<sub>sa</sub> < F<sub>sb</sub> < F<sub>pb</sub>. The fluctuations in the passband and stopband frequency zones were selected after testing in order to achieve monotony-smoothness of the filter without raising its order too much and making it as fast as possible (R<sub>p</sub> = 3, R<sub>s</sub> = 20)
4. The high frequency noise in the ECG signal is eliminated by making different noise estimates when designing a range of low pass Butterworth filters. A different set of specifications (type, class, decay) is used in order to make the right choice of ECG content and achieve better decay and flexibility of implementation:
   - The bilinear transform is used to implement the filters
   - Filter parameter selection: As the filer is a low pass, the ftype input parameter of the function butter() is ‘low’. The sets of specifications were compared in terms of smoothness, baseline wander, speed of convergence in the time domain and the signal attenuation at the cutoff frequency. The filter with the following specifications was selected: F<sub>p</sub> = 30, F<sub>s</sub> = 45, R<sub>p</sub> = 3, R<sub>s</sub> = 40
5. Finally, the above filters are applied in a cascaded way in order to produce the final ECG signal free from noise

## ECG analysis

Given the cleared ECG, the QRS complex can be derived and from that, the heart rate in beats per minute (bpm). In order to keep the algorithm simple, it was considered that the ECG is normal. This hypothesis is validated by the fact that the ECG looks normal, i.e., the graphical representation of the signal does not signify a heart disease. The following steps were followed in order to derive the QRS complex and the heart rate:
1. All the local minima and maxima are found
2. The R peaks are found by filtering the ECG values to be above the threshold of 0.45. This threshold was derived by inspecting the ECG waveform
3. Based on R peaks, the Q and S peaks were found, which are the previous and next local minima
4. The RR intervals are calculated by subtracting the previous time point from the next. Then, the intervals are converted from samples to seconds
5. The mean value of RR intervals is calculated
6. The heart rate is equal to 60 divided by the mean RR interval (because 60 seconds = 1 minute)

## References
1. “ECG SIGNAL PROCESSING AND HEART RATE FREQUENCY DETECTION METHODS”, J. Parak, J. Havlik, Department of Circuit Theory, Faculty of Electrical Engineering, Czech Technical University in Prague.
2. “Digital Filter Approach for ECG in Signal Processing”, Sonal K. Jagtap, M. D. Uplane, Department of Electronics, Shivaji University, Kolhapur.
3. “A DSP Practical Application: Working on ECG Signal”, Cristian Vidal Silva, Andrew Philominraj, Carolina del Río, University of Talca, Chile.
4. http://www.eetimes.com/document.asp?doc_id=1278571
5. http://www.mikroe.com/chapters/view/73/chapter-3-iir-filters/
6. http://www.mathworks.com/help/signal/ref/butter.html
7. http://www.mathworks.com/help/signal/ref/buttord.html
8. http://www.electronics-tutorials.ws/filter/filter_8.html
9. http://www.physionet.org/cgi-bin/atm/ATM
10. http://en.wikipedia.org/wiki/Heart_rate
