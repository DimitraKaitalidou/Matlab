function[output] = prewitt_filter(input)
% Copyright 2019, Dimitra S. Kaitalidou, All rights reserved
% The function applies the prewitt filter on the inserted
% matrix.

% Initialize matrices and variables
[r, c] = size(input);
r_pad = r + 2;
c_pad = c + 2;
input_prewitt = zeros(r_pad, c_pad);
input_pad = padarray(input, [1 1], 'replicate', 'both');
total1 = 0;
total2 = 0;

gx = [-1 0 1; -1 0 1; -1 0 1];
gy = [-1 -1 -1; 0 0 0; 1 1 1];

% Apply the prewitt filter
for j = 2:r_pad - 1
    for i = 2:c_pad - 1
        for h = -1:1
            for g = -1:1
                total1 = total1 + input_pad(j + h, i + g) * gx(h + 2, g + 2);
                total2 = total2 + input_pad(j + h, i + g) * gy(h + 2, g + 2);
            end
        end
        input_prewitt(j, i) = sqrt(total1 * total1 + total2 * total2);
        total1 = 0;
        total2 = 0;
    end 
end

% Populate the output matrix
output = input_prewitt(2:r_pad - 1, 2:c_pad - 1);

end


