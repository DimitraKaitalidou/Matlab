function[dist ] = signed_distance_map(input)
% Copyright 2019, Dimitra S. Kaitalidou, All rights reserved
% This function computes the signed distance map from an input image. The
% function sets to 0 the pixels on the object's boundary, to negative
% values the pixels inside the boundary and to positive values the pixels
% outiside the boundary. The distance calculated is euclidean.

% Two key matrices are used to determine the sign of the distance. The BW
% indicates all the pixels on and inside the boundary (value 1) and the
% BW_perim indicates all the pixels on the boundary only (value 1).
% Therefore when:
% a) BW_perim(i,j)==1 is on the boundary
% b) BW_perim(i,j)==0 && BW(i,j)==0 the pixel is outside the boundary
% c) BW_perim(i,j)==0 && BW(i,j)==1 the pixel is inside the boundary

% Produce the binary image where only the hippocampus is kept
input_norm = input / 512;
BW = im2bw(input_norm, 0.9);

% Find the perimeter of the object
BW_perim = bwperim(BW);

% Calculate the distance from the perimeter
[r, c] = size(BW_perim);
dist = zeros(r, c);
p = 0; % keeps how many points are on the perimeter
d = 0;
min = 0;

% Find and store the indices of the perimeters
for i = 1:r
    for j = 1:c
        if(BW_perim(i, j) == 1)
            p = p + 1;
            x(p) = i;
            y(p) = j;
        end
    end
end

% Set to 0 the values of the pixels on the perimeter (zero level set),
% to negative euclidean distance value the pixels inside the perimeter 
% to positive euclidean distance value the pixels outside the perimeter.
for i = 1:r
    for j = 1:c
        if(BW_perim(i, j) == 1)
            dist(i, j) = 0;
        else
            if(BW_perim(i, j) == 0) && (BW(i, j) == 0)
                for k = 1:p
                    d = sqrt(((x(k) - i)^2) + ((y(k) - j)^2));
                    if(k == 1)
                        min = d;
                    else
                        if(d < min) % Each pixel gets the value of the distance from the nearest pixel on the perimeter
                            min = d;
                        end
                    end
                end
                dist(i, j) = min;
            elseif(BW_perim(i, j) == 0) && (BW(i, j) == 1)
                for k = 1:p
                    d = sqrt(((x(k) - i)^2) + ((y(k) - j)^2));
                    if(k == 1)
                        min = d;
                    else
                        if(d < min) % Each pixel gets the value of the distance from the nearest pixel on the perimeter
                            min = d;
                        end
                    end
                end
                dist(i, j) = -min;
            end
        end
        d = 0;
        min = 0;
    end
end
end

