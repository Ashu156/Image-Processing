% Thsi script is for detecting edges in an image

close all;
clear all;
clc;

I = imread('C:\Users\hp\Desktop\rep_images\rep-img-4x-amy_1.tif');  % load the image
I = rgb2gray(I);                   %convert from RGB to grayscale 
figure (1);
imshow(I);                       % visulaizing the image

% plotting the histogram distribution of grayscale of the image

[pixelCount, grayLevels] = imhist(I);
figure(2);
bar(pixelCount);
xlim([0 grayLevels(end)]);
grid on

[~, threshold] = edge(I, 'sobel'); % Obtaining the threshold
fudgeFactor = 1;
BWs = edge(I,'sobel', threshold * fudgeFactor); % Applying binary mask to the figure
figure, imshow(BWs), title('binary gradient mask'); % Show figure

