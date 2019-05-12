% Copyright 2019, Dimitra S. Kaitalidou, All rights reserved
% This matlab script applies smoothing filters to an input image
% Specifically the mean, gaussian and kuwahara filters are applied

% Read the mri image
close all
clear all
img=imread('290px-MRI_Head_Brain_Normal.jpg');
im_mri=im2double(img);

% =========================================================================
% PART 1: Mean filter
% =========================================================================

im_mean3 = mean_filter(im_mri, 3);
im_mean5 = mean_filter(im_mri, 5);

% Print and save figures
figure (1)
imshow(im_mean3,[]);
xlabel('(\alpha) After mean filter 3x3')
imwrite(im_mean3/max(max(im_mean3)),'MR figure1.jpg');
figure (2)
imshow(im_mean5,[]);
xlabel('(\beta) After mean filter 5x5')
imwrite(im_mean5/max(max(im_mean5)),'MR figure2.jpg');

% =========================================================================
% PART 2: Gaussian filter
% =========================================================================

im_gauss3_05 = gauss_filter(im_mri, 3, 0.5);
im_gauss3_12 = gauss_filter(im_mri, 3, 1.2);
im_gauss3_3 = gauss_filter(im_mri, 3, 3);
im_gauss5_05 = gauss_filter(im_mri, 5, 0.5);
im_gauss5_12 = gauss_filter(im_mri, 5, 1.2);
im_gauss5_3 = gauss_filter(im_mri, 5, 3);
im_gauss9_05 = gauss_filter(im_mri, 9, 0.5);
im_gauss9_12 = gauss_filter(im_mri, 9, 1.2);
im_gauss9_3 = gauss_filter(im_mri, 9, 3);

% Print and save figures
figure (3)
imshow(im_gauss3_05,[]);
xlabel('(\alpha) After gaussian filter 3x3 and \sigma=0.5')
imwrite(im_gauss3_05/max(max(im_gauss3_05)),'MR figure3.jpg');
figure (4)
imshow(im_gauss3_12,[]);
xlabel('(\beta) After gaussian filter 3x3 and \sigma=1.2')
imwrite(im_gauss3_12/max(max(im_gauss3_12)),'MR figure4.jpg');
figure (5)
imshow(im_gauss3_3,[]);
xlabel('(\gamma)  After gaussian filter 3x3 and \sigma=3')
imwrite(im_gauss3_3/max(max(im_gauss3_3)),'MR figure5.jpg');
figure (6)
imshow(im_gauss5_05,[]);
xlabel('(\alpha) After gaussian filter 5x5 and \sigma=0.5')
imwrite(im_gauss5_05/max(max(im_gauss5_05)),'MR figure6.jpg');
figure (7)
imshow(im_gauss5_12,[]);
xlabel('(\beta) After gaussian filter 5x5 and \sigma=1.2')
imwrite(im_gauss5_12/max(max(im_gauss5_12)),'MR figure7.jpg');
figure (8)
imshow(im_gauss5_3,[]);
xlabel('(\gamma) After gaussian filter 5x5 and \sigma=3')
imwrite(im_gauss5_3/max(max(im_gauss5_3)),'MR figure8.jpg');
figure (9)
imshow(im_gauss9_05,[]);
xlabel('(\alpha) After gaussian filter 9x9 and \sigma=0.5')
imwrite(im_gauss9_05/max(max(im_gauss9_05)),'MR figure9.jpg');
figure (10)
imshow(im_gauss9_12,[]);
xlabel('(\beta) After gaussian filter 9x9 and \sigma=1.2')
imwrite(im_gauss9_12/max(max(im_gauss9_12)),'MR figure11.jpg');
figure (12)
imshow(im_gauss9_3,[]);
xlabel('(\gamma) After gaussian filter 9x9 and \sigma=3')
imwrite(im_gauss9_3/max(max(im_gauss9_3)),'MR figure12.jpg');

% =========================================================================
% PART 3: Kuwahara filter
% =========================================================================

im_kuwahara5 = kuwahara_filter(im_mri, 5);
im_kuwahara9 = kuwahara_filter(im_mri, 9);

% Print and save figures
figure (13)
imshow(im_kuwahara5,[])
xlabel('(\alpha) After Kuwahara filter 5x5') 
imwrite(im_kuwahara5/max(max(im_kuwahara5)),'MR figure13.jpg');
figure (14)
imshow(im_kuwahara9,[])
xlabel('(\beta) After Kuwahara filter 9x9')
imwrite(im_kuwahara9/max(max(im_kuwahara9)),'MR figure14.jpg');

% =========================================================================
% PART 4: Verification
% =========================================================================

% Create the average filters with hsize = [3 3] or [5 5]
m3 = fspecial('average',[3 3]);
m5 = fspecial('average',[5 5]);

% Filter the input signals
im_mean3_v = imfilter(im_mri, m3);
im_mean5_v = imfilter(im_mri, m5);

% Create the gaussian filters with hsize = [3 3] or [5 5] or [9 9] and 
% sigma = 0.5.1.2,3
G3_05 = fspecial('gaussian',[3 3],0.5);
G3_12 = fspecial('gaussian',[3 3],1.2);
G3_3 = fspecial('gaussian',[3 3],3);
G5_05 = fspecial('gaussian',[5 5],0.5);
G5_12 = fspecial('gaussian',[5 5],1.2);
G5_3 = fspecial('gaussian',[5 5],3);
G9_05 = fspecial('gaussian',[9 9],0.5);
G9_12 = fspecial('gaussian',[9 9],1.2);
G9_3 = fspecial('gaussian',[9 9],3);

% Filter the input signals
im_gauss3_05_v = imfilter(im_mri,G3_05);
im_gauss3_12_v = imfilter(im_mri,G3_12);
im_gauss3_3_v = imfilter(im_mri,G3_3);
im_gauss5_05_v = imfilter(im_mri,G5_05);
im_gauss5_12_v = imfilter(im_mri,G5_12);
im_gauss5_3_v = imfilter(im_mri,G5_3);
im_gauss9_05_v = imfilter(im_mri,G9_05);
im_gauss9_12_v = imfilter(im_mri,G9_12);
im_gauss9_3_v = imfilter(im_mri,G9_3);

disp('Is the MR image calculated by the mean_filter() the same as the MR image produced by the mean matlab function?')
if(max(max(abs(im_mean3 - im_mean3_v))) < 1e-15)
    disp('Yes')
else
    disp('No')
end

disp('Is the MR image calculated by the gaussian_filter() the same as the MR image produced by the gaussian matlab function?')
if(max(max(abs(im_gauss3_05 - im_gauss3_05_v))) < 1e-15)
    disp('Yes')
else
    disp('No')
end