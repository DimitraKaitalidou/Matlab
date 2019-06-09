% Copyright 2019, Dimitra S. Kaitalidou, All rights reserved
% This matlab script performs PCA analysis on brain MRI images in order
% to extract the primary modes of variance. These modes can be used as 
% shape prior information to facilitate the image segmentation

close all
clear all

% =========================================================================
% PART 1: Load data and calculate the signed distance map
% =========================================================================

% Read all input images
fnames = dir('*.img');
number_of_images = length(fnames);
for i=1:number_of_images
    [ avw, machine ] = avw_img_read(fnames(i).name, '', 'ieee-be');
    img = avw.img;
    img1 = img(64, :, :);
    if(i == 1)
        im1 = flipud(permute(img1, [3, 2, 1]));
        [rows, cols] = size(im1);
        im = zeros(number_of_images, rows, cols);
        im(i,:,:) = flipud(permute(img1, [3, 2, 1]));
    else
        im(i,:,:) = flipud(permute(img1, [3, 2, 1]));
    end
end

% Calculate the signed distance map, vectorize them and put them as columns 
% into M
dist = zeros(number_of_images, rows, cols);
im_centered = zeros(rows * cols, number_of_images);
for j = 1:number_of_images
    temp(:, :) = im(j, :, :);
    dist(j, :, :) = signed_distance_map(temp);
    im_centered(:, j) = reshape(dist(j, :, :), [rows * cols, 1]);
end

% =========================================================================
% PART 2: Perform PCA on the covariance matrix of the signed distance map
% =========================================================================

% Center each column of M by subtracting the mean shape
mean_values = mean(im_centered, 2);
mean_shape = reshape(mean_values, [rows, cols]);
mean_shape = flipud(mean_shape);
im_centered = im_centered - repmat(mean_values, 1, number_of_images);

% Find the eigenvalues and eigenvectors, but calculate 
% (im_centered.') * im_centered instead of im_centered * im_centered.' 
% to avoid the generation of a very large covariance matrix.
cov = (1 / (number_of_images - 1)) * (im_centered.') * im_centered;
[U, D] = eig(cov);
V = im_centered * U;
for k = 1:number_of_images
    V(:, k) = V(:, k) / norm(V(:, k), 2);
end

% Sort the eigenvalues and eigenvalues in descending order to get the
% first 4 principal components
sigma2 = diag(D);
[s, index] = sort(sigma2,'descend');
V_principal = V(:, index(1:4));

% =========================================================================
% PART 3: Calculate the primary modes of variance and produce a gif image
% =========================================================================

% Reconstruct an estimate of the shape
V_pca = zeros(4, rows * cols, 4);
co = -2;
for n = 1:21
     CCall = figure(10); 
     
     % Create 1st mode
     V_pca(1, :, n) = V_principal(:, 1) * co * sqrt(s(1)) + mean_values; % Leventon eq. 3
     temp = V_pca(1, :, n);
     subplot(2, 2, 1)
     t = reshape(temp, [rows, cols]);
     t = flipud(t);
     contour(t, [0, 0]);
     hold on;
     [c, h] = contour(mean_shape, [0, 0]);
     set(h, 'color', 'r')
     xlim([75, 125]);
     ylim([40, 90]);
     title('1st mode');
     hold off;

     % Create 2nd mode
     V_pca(2, :, n) = V_principal(:, 1:2) * co * sqrt(s(1:2)) + mean_values; % Leventon eq. 3
     temp = V_pca(2, :, n);
     subplot(2, 2, 2)
     t = reshape(temp, [rows, cols]);
     t = flipud(t);
     contour(t, [0, 0]);
     hold on;
     [c, h] = contour(mean_shape, [0, 0]);
     set(h, 'color', 'r')
     xlim([75, 125]);
     ylim([40, 90]);
     title('2nd mode');
     hold off;
     
     % Create 3rd mode
     V_pca(3, :, n) = V_principal(:, 1:3) * co * sqrt(s(1:3)) + mean_values; % Leventon eq. 3
     temp = V_pca(3, :, n);
     subplot(2, 2, 3)
     t = reshape(temp, [rows, cols]);
     t = flipud(t);
     contour(t, [0, 0]);
     hold on;
     [c, h] = contour(mean_shape, [0, 0]);
     set(h, 'color', 'r')
     xlim([75, 125]);
     ylim([40, 90]);
     title('3rd mode');
     hold off;

     % Create 4th mode
     V_pca(4, :, n) = V_principal(:, 1:4) * co * sqrt(s(1:4)) + mean_values; % Leventon eq. 3
     temp = V_pca(4, :, n);
     subplot(2, 2, 4)
     t = reshape(temp,[rows, cols]);
     t = flipud(t);
     contour(t, [0, 0]);
     hold on;
     [c, h] = contour(mean_shape, [0, 0]);
     set(h, 'color', 'r')
     xlim([75, 125]);
     ylim([40, 90]);
     title('4th mode');
     hold off;
     
     % Create the gif
     frame = getframe(CCall);  
     im = frame2im(frame); 
     [imind, cm] = rgb2ind(im, 256);
     filename = 'pca.gif';
     if(n == 1) % First slide
         imwrite(imind, cm, filename, 'gif', 'Loopcount', inf);
     else % Rest of the slides of gif
         imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append');
     end
     
     co = co + 0.2;
end