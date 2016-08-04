% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear
clc
%% Initialize System Objects
% Create a VideoFileReader System object to read video from a file.
VR = vision.VideoFileReader('laneDeparture.avi');
% Create a VideoPlayer System object to visualize video
VP = vision.DeployableVideoPlayer;

%% Loop Algorithm
while (~isDone(VR))
    
    %% Preprocess
    % Acquire frame
    frame = step(VR);
    
    % Threshold the image
    BM = createLaneMask(frame);
    
    % Apply a skeleton morphology to get the thinnest lines
    BMSkel = bwmorph(BM,'skel',Inf);
    
    %% Detect Lines
    % Perform Hough Transform
    [H,theta,rho] = hough(BMSkel);

    % Identify Peaks in Hough Transform
    hPeaks  = houghpeaks(H,30,'threshold',ceil(0.3*max(H(:))),...
    'NHoodSize',[155 35]);

    % Extract lines from hough transform and peaks
    hLines = houghlines(BMSkel,theta,rho,hPeaks,'FillGap',80,'MinLength',7);

    %% View results
    % Overlay lines
    [linePos,markerPos] = getVizPosArray(hLines);

    if (~isempty(linePos))
        % If lines are detected, mark their positions
        lineFrame = insertShape(frame,'Line',linePos,...
                    'Color','blue','LineWidth',5);
        outFrame = insertObjectAnnotation(lineFrame,...
                    'circle',markerPos,'','Color','yellow','LineWidth',5);
    else
        % If lines are not detected, display unaltered frame
        outFrame = frame;
        
    end
    
    % Update video player
    step(VP,outFrame);
end

%% Clean up
release(VR)
release(VP)