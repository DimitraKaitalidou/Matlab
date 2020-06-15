# Two-Process Model of Sleep

## Model description
The most well-known mathematical model of sleep regulation is the two-process model, which models the sleep-wake cycle. Specifically, the cycle consists of two processes:
- A sleep-dependent process (Process S), which is called the homeostatic process
- A sleep-independent process (Process C), which is called the circadian process

The homeostatic process takes the form of a relaxation oscillator that results in a monotonically increasing homeostatic sleep pressure during awake state that is interrupted during sleep. The switching between awake and sleeping states occurs at upper and lower threshold values of the homeostatic sleep pressure respectively, which are modulated by an approximately sinusoidal circadian oscillator. 

## Code description
This Matlab program implements the following algorithm:

<pre><code> if state = sleep 
   H<sub>t</sub> = μ + (H<sub>0</sub> - μ) * exp((t<sub>0</sub> - t) / xw) 
   if H<sub>t</sub> > H<sub>0</sub><sup>+</sup> + (a * C<sub>t</sub>)
       H<sub>t</sub> = H<sub>0</sub><sup>+</sup> + a * C<sub>t</sub>
       H<sub>0</sub> = H<sub>t</sub>
       state = wake 
       t<sub>0</sub> = t 
   end 
else 
   H<sub>t</sub> = H<sub>0</sub> * exp((t<sub>0</sub> - t) / xs) 
   if H<sub>t</sub> < H<sub>0</sub><sup>-</sup> + (a * C<sub>t</sub>)
      H(t) = H<sub>0</sub><sup>-</sup> + a * C<sub>t</sub>
      H<sub>0</sub> = H<sub>t</sub>     
      state = sleep 
      t<sub>0</sub> = t 
   end 
end </code></pre>

Specifically, H<sub>t</sub> is the homeostatic pressure, H<sub>0</sub><sup>+</sup> is the upper threshold of homeostatic pressure, H<sub>0</sub><sup>-</sup> is the lower threshold of homeostatic pressure, H<sub>0</sub> is the initial homeostatic pressure depending on the initial state and C<sub>t</sub> is a periodic function of the circadian process (simple or complex form depending on user input). Details on the algorithm and the values can found [here](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0103877#s1).

# References
1. Mathematical Models for Sleep-Wake Dynamics: Comparison of the Two-Process Model and a Mutual Inhibition Neuronal Model
Skeldon AC, Dijk DJ, Derks G (2014) Mathematical Models for Sleep-Wake Dynamics: Comparison of the Two-Process Model and a Mutual Inhibition Neuronal Model. PLOS ONE 9(8): e103877. https://doi.org/10.1371/journal.pone.0103877
2. http://www.scholarpedia.org/article/Sleep_homeostasis
3. Borbély A (1982), A two process model of sleep regulation. Human Neurobiology 1: 195–204.
