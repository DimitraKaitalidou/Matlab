function Oscillator(initial_state, num_of_hours, circadian_process_function)
% Copyright 2020, Dimitra S. Kaitalidou, All rights reserved
% This is the implementation of the two process model of sleep, using the
% simple or the complex function for the circadian process C(t)
% The following values can be used for testing purposes:
% Upper threshold homeostatic pressure: 0.2, 0.35, 0.6, 0.85

% Initilize variables
time = 1:num_of_hours;
w = pi / 12;
t0 = 0;
xs = 4.2;
xw = 18.2; 
mu = 1;
alpha = 0;
a = 0.1;
H0_ut = 0.35; % upper threshold of homeostatic pressure
H0_lt = 0.17; % lower threshold of homeostatic pressure
H = zeros(1, num_of_hours);
state = initial_state;

% Check state to initialize H0
if initial_state == 0 
    H0 = H0_lt;
else
    H0 = H0_ut;
end

% Circadian process
if circadian_process_function == 0
    circadian_process_function_str = 'Simple Circadian Function';
    C = sin(w * (time - alpha));
else
    circadian_process_function_str = 'Complex Circadian Function';
    C = 0.97 * sin(w * (time - alpha)) + 0.22 * sin(2 * w * (time - alpha)) + 0.007 * sin(3 * w * (time - alpha)) + 0.03 * sin(4 * w * (time - alpha)) + 0.001 * sin(5 * w * (time - alpha));
end

% Oscillate between the two states
for t = 1:num_of_hours
    if state == 0
        H(t) = mu + (H0 - mu) * exp((t0 - t) / xw); 
        if H(t) > H0_ut + a * C(t)
            H(t) = H0_ut + a * C(t);
            H0 = H(t);
            state = 1;
            t0 = t;
        end
    else
        H(t) = H0 * exp((t0 - t) / xs);
        if H(t) < H0_lt + a * C(t)
            H(t) = H0_lt + a * C(t);
            H0 = H(t);
            state = 0;
            t0 = t;
        end
    end
end

% Print results
figure;
plot(time, H0_ut + a * C(time), 'LineWidth', 1, 'Color', [0.780392169952393 0.95686274766922 0.39215686917305])
title({'Sleep-wake cycles -', circadian_process_function_str, 'Mean Value of Homeostatic Pressure = ' H0_ut});
hold on 
plot(time, H0_lt + a * C(time), 'LineWidth', 1, 'Color', [0.30588236451149 0.803921580314636 0.768627464771271])
hold on 
plot(time, H, 'LineWidth', 1, 'Color', [0.749019622802734 0 0.749019622802734])
legend ('Upper Asymptote of Homeostatic Pressure', 'Lower Asymptote of Homeostatic Pressure', 'Homeostatic Pressure');

end