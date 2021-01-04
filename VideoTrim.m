%%
% This script trims a video file as per given start and end time.

%%

clear all; % Clear workspace
close all; % Close open windows
clc;       % Clear commnad window

%% Specify start and end timings for trimming the video

startMinute = 5;  % desired starting minute of the video file
startSecond = 12; % desired starting second of the video file

endMinute = 5;    % desired ending minute of the video file
endSecond = 17;   % desired ending second of the video file

beginTime = startMinute*60 + startSecond; % desired beginning time in seconds
endTime =   endMinute*60 + endSecond;     % desired ending time in seconds
outputName = 'ToneHabituation.avi';       % output video file name 

%% Load the original video and initialize parameters 

fileName = 'E:\Behaviour\Sohail-Extincton\Behaviour\Tone habituation\Control\batch 1\AU';
inputName = strcat(fileName, '.avi'); % full name of the video file
a = VideoReader(inputName);           % read the video file

%  if ~isinteger(a.FrameRate)
%  a.FrameRate = round(a.FrameRate)
%  end
 
beginFrame = round(beginTime * a.FrameRate);   % desired starting frame
endFrame = round(endTime * a.FrameRate);       % desired ending frame

vidObj = VideoWriter(outputName);              % initalize output video object
vidObj.FrameRate = round(a.FrameRate);         % fps of the output video file
open(vidObj);                                  % open video object 

%% Write desired frames into the new video file

for img = beginFrame:endFrame
    b = read(a, img);
    writeVideo(vidObj, b)
end
close(vidObj);

%% end of script