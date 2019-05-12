function [ output ] = kuwahara_filter( input, size_of_filter )
%   Copyright 2019, Dimitra S. Kaitalidou, All rights reserved
%   The function applies the kuwahara filter on the inserted
%   matrix.

% Initialize matrices and variables
[r, c] = size(input);
output = zeros(r, c);
r_pad = r + 2 * (size_of_filter-1)/2;
c_pad = c + 2 * (size_of_filter-1)/2;
input_kuwahara = zeros(r_pad, c_pad);
input_pad = padarray(input,[(size_of_filter-1)/2 (size_of_filter-1)/2],0,'both');
limit = (size_of_filter-1)/2;

% Apply the kuwahara filter
 for j=limit+1:r_pad-limit
    for i=limit+1:c_pad-limit
         % Initiate counters
         mean_value = zeros(1,4);
         sigma = zeros(1,4);
         % Northwest area
         mean_value(1) = sum(sum(input_pad(j-limit:j,i-limit:i)))/((limit+1).^2);
         sigma(1) = (1/(-1+(limit+1).^2))*sum(sum((input_pad(j-limit:j,i-limit:i)-mean_value(1)).^2));
         % Northeast area
         mean_value(2) = sum(sum(input_pad(j-limit:j,i:i+limit)))/((limit+1).^2);
         sigma(2) = (1/(-1+(limit+1).^2))*sum(sum((input_pad(j-limit:j,i:i+limit)-mean_value(2)).^2));
         % Southwest area
         mean_value(3) = sum(sum(input_pad(j:j+limit,i-limit:i)))/((limit+1).^2);
         sigma(3) = (1/(-1+(limit+1).^2))*sum(sum((input_pad(j:j+limit,i-limit:i)-mean_value(3)).^2));
         % Southeast area
         mean_value(4) = sum(sum(input_pad(j:j+limit,i:i+limit)))/((limit+1).^2);
         sigma(4) = (1/(-1+(limit+1).^2))*sum(sum((input_pad(j:j+limit,i:i+limit)-mean_value(4)).^2));
         % Find the smallest standard deviation
         sigma_min = min(sigma);
         if(sigma_min == sigma(1))
             input_kuwahara(j,i) = mean_value(1);
         elseif(sigma_min == sigma(2))
             input_kuwahara(j,i) = mean_value(2);
         elseif(sigma_min == sigma(3))
             input_kuwahara(j,i) = mean_value(3);
         else
             input_kuwahara(j,i) = mean_value(4);
         end
     end
 end
 
 % Populate the output matrix
output = input_kuwahara((size_of_filter-1)/2+1:r_pad-(size_of_filter-1)/2, ((size_of_filter-1)/2)+1:c_pad-(size_of_filter-1)/2);

end

