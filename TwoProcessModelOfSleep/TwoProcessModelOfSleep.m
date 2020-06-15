% Copyright 2020, Dimitra S. Kaitalidou, All rights reserved
% This matlab script applies the Two-Process Model of Sleep
% The following input values can be used for testing purposes:
% Number of hours: 72 hours (3 days)

close all
clear all

% Read and convert the input values
num_of_hours_input = inputdlg('Give the number of hours.');
num_of_hours = str2num(num_of_hours_input{1,1});
initial_state_input = inputdlg('Give the initial state: 0 for awake, 1 for asleep.');
initial_state = str2num(initial_state_input{1,1});
circadian_function_input = inputdlg('Give the type of circadian function: 0 for simple, 1 for complex.');
circadian_function = str2num(circadian_function_input{1,1});

% Apply the Two-Process Model of Sleep
if (initial_state == 0 || initial_state == 1) && (circadian_function == 0 || circadian_function == 1)
    Oscillator(initial_state, num_of_hours, circadian_function);
else
    h = msgbox('Invalid Value', 'Error', 'error');
end