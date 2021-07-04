%% 
% This script stitches images together into a movie and also lets you edit
% the movie through the images, like putting a mask over certain regions of
% the video and adding text to the video.

%%
clear all; % Clear workspace
close all; % Close open window(s)
clc;       % Clera command window

%%
file = fullfile(strcat(pwd, '\Movie Frames from A_U_02.05.15'), '*.png'); % Path to folder where images are located
images = dir(file); % Getting the details of images
numImages = length(images); % Number of images in the folder
x = zeros(numImages, 3); % Initialize a matrix for storing dimensions of each image

%
for i = 1:numImages
    currentFileName = images(i).name; % Extract image file name
    currentImage = imread(strcat(images(i).folder, '\', currentFileName)); % Read the image file in workspace
    images2{i} = currentImage;  % Store the image file in a cell array
    x(i,:) = size(images2{i});  % Extract dimension of the image
end

% numImages_strPadded = sprintf('%04d', 1:numImages);

%% Resizing the images

inputSize = [min(x(:, 1)) min(x(:, 2))]; % Find minimum width and height of all the images
start_frame = 250; % Starting frame for putting text into 

for ii = 1:numImages
    currentFileName = images(ii).name; % Extract image file name
    
    currentImage = imread(strcat(images(ii).folder, '\', currentFileName)); % Read the image file into workspace
    % Insert a black rectangle at the bottom of the image (Change this line
    % to change the desired loaction and dimensions of the shape to be
    % inserted
    RGB = insertShape(currentImage, 'FilledRectangle', [0 222-222/4 457 222-222/3], 'Color', 'black', 'Opacity', 1);
    
    % Insert a black rectangle at the top of the image (Change this line
    % to change the desired loaction and dimensions of the shape to be
    % inserted
    RGB = insertShape(RGB, 'FilledRectangle', [0 0 457 222/3], 'Color', 'black', 'Opacity', 1);
    
    % Insert text at the top of the image (Change this line
    % to change the text to be inserted and its properties
    if ii >= start_frame % Inserts text from strat_frame to end 
       RGB = insertText(RGB, [0 0], 'Appetitive call playback ON', 'BoxColor', 'black', 'BoxOpacity', 1, 'TextColor', 'white', 'Font', 'Arial', 'FontSize', 20);
    end
    images3{ii} = imresize(RGB, inputSize); % Store individual images in a new cell array
end

%% Initialize video object

video = VideoWriter('ControlApproach.avi'); % Create the video object
myVideo.FrameRate = 30; % Can adjust this
open(video);           % Open the file for writing

for ii = 1:4:numImages % Writes every 5th image into the video file for speeding up the playabck rate
    imshow(images3{ii});
    frame = getframe(gcf); %get frame
    writeVideo(video, frame);
end

close(video) % Close the file after writing

%%

%% end of script
