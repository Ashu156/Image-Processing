%% 
% This script lets you animate a plot and save the same as video file.
% In this example, I have loaded a LFP recording dataset, preprocessed it
% and then plotted a selected portion of it as an animation.

%%
clear all  % Clear the workspace
close all  % Close open windows
clc        % Clear command window

%% Loading the raw data

[fileName, path] = uigetfile; % Choose file 
load(strcat(path, fileName)); % Load file

 %% Data precprocessing (LFP data for this case) 

x_min1 = -1.5; x_max1 = 2.5;

ts_csc1 = CSC28_TS;                                            % timestamps from channel 1
dp_csc1 = (CSC28_DP);                                          % data points in channel 1
ADBitVolts1 = (str2double(CSC28_NlxHeader{15}(13:38)))*10^6;   % bit to microVolt conversion
Fs1 = str2double(CSC28_NlxHeader{14}(end - 4:end));            % sampling frequency

if Fs1 > 1e3
    Fs1 = 1e3;
end
downsampling_factor = 1;
Fs1 = Fs1/downsampling_factor;

dp_csc1 = dp_csc1*ADBitVolts1;                                 % CSC data points in microVolts
dp_csc1 = decimate(dp_csc1(:), downsampling_factor);                                          % linearizing the data points

dp_csc1 = detrend(dp_csc1,'constant');                         % detrended data from channel 1
ts_events1 = (Events_tone_on + 000000.00)./10^6;               % selecting events of choice 
numTrials1 = length(ts_events1);                               % number of events
ts_csc1 = ts_csc1./10^6 ;                                      % in seconds

% Generate all the timestamps corresponding to all data points
tt1 = [0:1/Fs1:511/Fs1]' ;
tts_csc1 = [];

for i = 1:length(ts_csc1)
    tts_csc1 = [tts_csc1  [ts_csc1(i) + tt1]];
end

tts_csc1 = decimate(tts_csc1(:), downsampling_factor);
kmin1 = round(Fs1*(x_min1));         % Min x-limit  
kmax1 = round(Fs1*(x_max1));         % Max x-limit  

tx1 = (x_min1:1/Fs1:x_max1)*1000 ; % time in milliseconds


lfp1 = zeros(length([kmin1:kmax1]), numTrials1);
eventID = dsearchn(tts_csc1, ts_events1');

for i = 1:numTrials1
    min_dist1(1,i) = min(abs(tts_csc1(:) - ts_events1(i)));
    k1(1,i) = find(abs(tts_csc1(:) - ts_events1(i)) == min_dist1(1,i)) ;
    lfp1(:,i) = dp_csc1(eventID(i) + kmin1 : eventID(i) + kmax1);
end

%% Choose data to plot
lfp1 = lfp1(1:length(tx1), :)
voltage = mean(lfp1(1:500, :), 2); % I chose the first 500 data points to plot and animate
time = (tx1(1:length(voltage))) + 1501;

plot(time, voltage) % Check if the chosen data is plotted correctly

%% Initialize video object

myVideo = VideoWriter('LFP'); % Open video file
myVideo.FrameRate = 10;  % You can adjust this, 5 - 10 works well for me
open(myVideo)

%% Plot in a loop and grab frames

for i = 1:4:length(time) % Saves every 5th frame for speeding up the video
    plot(time(1, 1:i), voltage(1:i, 1), 'LineWidth', 2)
    set(gcf, 'Color', [1 1 1])
    grid on
    ylim([min(voltage)-20 max(voltage)+20])
    xlim([time(1) time(end)])
    xlabel('Time')
    ylabel('Voltage')
    pause(0.01) % Pause and grab frame
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame);
end
close(myVideo)

%% end of script