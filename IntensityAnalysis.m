% This  script 
close all;
clear all;
clc;

I = imread('C:\Users\hp\Desktop\rep_images\ZI-5FOX-2013-ANN00-IDSI-630-1.jpe');   % load the image rep_images\rep-img-4x-amy_2
I = rgb2gray(I);                   %convert from RGB to grayscale 
% se = strel('disk',3);
% I = imsubtract(imadd(I,imtophat(I,se)),imbothat(I,se));
% I = imsharpen(I);
figure (1);
imshow(I);                       % visulaizing the image,I2,'montage'

% plotting the histogram distribution of grayscale of the image

[pixelCount, grayLevels] = imhist(I);
figure(2);
bar(pixelCount);
xlim([0 grayLevels(end)]);
grid on

% thresholding the image
% Method 1 (global thresholding)
% level = 0.25;
% thresholdValue = level * max(max(I));
% I_binary = I < thresholdValue;
% hold on;
% maxYValue = ylim;
% line([thresholdValue, thresholdValue], maxYValue, 'Color', 'r');
% hold off
% figure(3);
% imshow(I_binary);
% I_binary = medfilt2(I_binary);

% thresholding the image
% Method 2a (local adaptive thresholding (Wellner's adaptive thresholding,1993))
% median filter
fsize = fix(length(I) / 20); % determining the size of the filter (generally should be between 1/10th to 1/20th of the original image size)
fim = medfilt2(I, [fsize fsize], 'symmetric'); % applying median smmothening

% thresholding the image
% Method 2b (local adaptive thresholding (Wellner's adaptive thresholding,1993))
% gaussian filter for linear filtering
% g = fspecial('gaussian',6 * fsize,fsize); %designing gaussian filter with specifications
% fim = filter2(g,I); %applying gaussian filter

% Applying the threshold operation
t = 20; % threshold percentage value (should be negative for white foreground and positive for black foreground)
I_binary = I < fim *(1 - t / 100);
I_binary = imfill(I_binary, 'holes');
I_binary = imopen(I_binary,strel('disk', 10));
I_binary = imclearborder(bwareaopen(I_binary, 20));
figure;imshow(I_binary)

% Labelling the image

labeledImage = bwlabel(I_binary, 8);
figure(4)
imshow(labeledImage,[]);
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
figure(5)
imshow(coloredLabels);
[B,L,N,A] = bwboundaries(I_binary);
hold on;

for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:, 2),boundary(:, 1),'Linewidth', 2);
end

blobMeasurements = regionprops(labeledImage, I, 'all');
numberOfBlobs = size(blobMeasurements, 1);
figure(6)
imshow(I);
hold on
boundaries = bwboundaries(I_binary);
numberOfBoundaries = size(boundaries, 1);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:, 2), thisBoundary(:, 1), 'g', 'LineWidth', 2);
end

hold off;

labelShiftX = -7;	% Used to align the labels in the centers of the coins.
blobECD = zeros(1, numberOfBlobs);
textFontSize = 5;
for k = 1 : numberOfBlobs           % Loop through all blobs.
	% Find the mean of each blob.  
	% directly into regionprops.  The way below works for all versions including earlier versions.)
	thisBlobsPixels = blobMeasurements(k).PixelIdxList;  % Get list of pixels in current blob.
	meanGL = mean(I(thisBlobsPixels)); % Find mean intensity (in original image)
	
	
	blobArea = blobMeasurements(k).Area;		% Get area.
	blobPerimeter = blobMeasurements(k).Perimeter;		% Get perimeter.
	blobCentroid = blobMeasurements(k).Centroid;		% Get centroid one at a time
	blobECD(k) = sqrt(4 * blobArea / pi);					% Compute ECD - Equivalent Circular Diameter.
	fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k, meanGL, blobArea, blobPerimeter, blobCentroid, blobECD(k));
	% Put the "blob number" labels on the "boundaries" grayscale image.
	text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold');
end
