function[output] = mean_filter(input, size_of_filter)
% Copyright 2019, Dimitra S. Kaitalidou, All rights reserved
% The function applies the mean or averaging filter on the inserted
% matrix.

% Initialize matrices and variables
[r, c] = size(input);
r_pad = r + 2 * (size_of_filter - 1) / 2;
c_pad = c + 2 * (size_of_filter - 1) / 2;
input_mean = zeros(r_pad, c_pad);
input_pad = padarray(input, [((size_of_filter - 1) / 2) ((size_of_filter - 1) / 2)], 0, 'both');

% Apply the mean filter
for j = ((size_of_filter - 1) / 2) + 1:r_pad - ((size_of_filter - 1) / 2)
    for i = ((size_of_filter - 1) / 2) + 1:c_pad - ((size_of_filter - 1) / 2 )
        input_mean(j, i) = (1 / (size_of_filter.^2)) * sum(sum(input_pad(j - (size_of_filter - 1) / 2:j + (size_of_filter - 1) / 2, i - (size_of_filter - 1) / 2:i + (size_of_filter - 1) / 2)));
    end 
end

% Populate the output matrix
output = input_mean((size_of_filter - 1) / 2 + 1:r_pad - (size_of_filter - 1) / 2, ((size_of_filter - 1) / 2) + 1:c_pad - (size_of_filter - 1) / 2);

end

