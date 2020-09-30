function[output] = gauss_filter(input, size_of_filter, sigma)
% Copyright 2019, Dimitra S. Kaitalidou, All rights reserved
% The function applies the gaussian filter on the inserted
% matrix.

% Initialize matrices and variables
[r, c] = size(input);
output = zeros(r, c);
r_pad = r + 2 * (size_of_filter - 1) / 2;
c_pad = c + 2 * (size_of_filter - 1) / 2;
input_gauss = zeros(r_pad, c_pad);
input_pad = padarray(input, [((size_of_filter - 1) / 2) ((size_of_filter - 1) / 2)], 0, 'both');
total = 0;

% Create the impulse response or kernel to apply the gaussian filter
ga = zeros(size_of_filter, size_of_filter);

for k = -(size_of_filter - 1) / 2:(size_of_filter - 1) / 2
    for l = -(size_of_filter - 1) / 2:(size_of_filter - 1) / 2
        ga(k + ((size_of_filter - 1) / 2) + 1, l + ((size_of_filter - 1) / 2) + 1) = exp((- (k.^2) - (l.^2)) / (2 * (sigma.^2)));
    end
end

ga = ga / sum(ga(:));

% Apply the gaussian filter with convolution
for j = ((size_of_filter - 1) / 2) + 1:r_pad - ((size_of_filter - 1) / 2)
    for i = ((size_of_filter - 1) / 2) + 1:c_pad - ((size_of_filter - 1) / 2)
        for h = -(size_of_filter - 1) / 2:(size_of_filter - 1) / 2
            for g = -(size_of_filter - 1) / 2:(size_of_filter - 1) / 2
                total = total + input_pad(j + h, i + g) * ga(h + ((size_of_filter - 1) / 2) + 1, g + ((size_of_filter - 1) / 2) + 1);
            end
        end
        input_gauss(j, i) = total;
        total = 0;
    end 
end

% Populate the output matrix
output = input_gauss((size_of_filter - 1) / 2 + 1:r_pad - (size_of_filter - 1) / 2, ((size_of_filter - 1) / 2) + 1:c_pad - (size_of_filter - 1) / 2);

end

