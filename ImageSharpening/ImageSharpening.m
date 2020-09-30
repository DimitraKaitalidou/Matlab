% Copyright 2019, Dimitra S. Kaitalidou, All rights reserved
% This matlab script applies sharpening filters to an input image
% Specifically the sobel and prewitt filters are applied

% Read the mri image
close all
clear all
img = imread('290px-MRI_Head_Brain_Normal.jpg');
im_mri = im2double(img);

% =========================================================================
% PART 1: Sobel and Prewitt
% =========================================================================

% Apply the sobel and prewitt operators and show the images  
input_mr_sobel = sobel_filter(im_mri);
input_mr_prewitt = prewitt_filter(im_mri);

% Print and save figures
figure (1)
imshow(input_mr_sobel, []);
xlabel('(\alpha) After Sobel filter') 
imwrite(input_mr_sobel/max(max(input_mr_sobel)), 'MR figure11.jpg');
figure (2)
imshow(input_mr_prewitt, []);
xlabel('(\alpha) After Prewitt filter') 
imwrite(input_mr_prewitt/max(max(input_mr_prewitt)), 'MR figure12.jpg');

% =========================================================================
% PART 2: Verification
% =========================================================================

[Gmag_mr_sobel, Gdir_mr_sobel] = imgradient(im_mri, 'sobel');
disp('Is the MR image calculated by the sobel_filter() the same as the MR image produced by the imgradient() matlab function?')
if(max(max(abs(Gmag_mr_sobel - input_mr_sobel))) < 1e-15)
    disp('Yes')
else
    disp('No')
end
[Gmag_mr_prewitt, Gdir_mr_prewitt] = imgradient(im_mri, 'prewitt');
disp('Is the MR image calculated by the prewitt_filter() the same as the MR image produced by the imgradient() matlab function?')
if(max(max(abs(Gmag_mr_prewitt - input_mr_prewitt))) < 1e-15)
    disp('Yes')
else
    disp('No')
end
