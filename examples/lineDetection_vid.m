% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear
clc
%% Initialize System Objects
% Create a VideoFileReader System object to read video from a file.
vidFReader = vision.VideoFileReader('igvcVideo.avi',...
    'VideoOutputDataType','double');
% Create a VideoPlayer System object to visualize video
vidPlayer = vision.DeployableVideoPlayer;

%% Loop Algorithm
idx = 1;
while(~isDone(vidFReader))
    %% Preprocess
    % Acquire frame
    frame = step(vidFReader);
    
    % Block Orange Cones
    frameNoOrange = blockOrangeCones(frame); 

    % Mask to get Lines of interest
    BW = createLineMaskHSV(frameNoOrange);

    % Apply a close morphology to make continuous lines
    BM = imclose(BW,strel('disk',10));

    % Apply a skeleton morphology to get the thinnest lines
    BMSkel = bwmorph(BM,'skel',Inf);
    
    %% Detect Lines
    % Perform Hough Transform
    [H,T,R] = hough(BMSkel);

    % Identify Peaks in Hough Transform
    hPeaks  = houghpeaks(H,10,'NhoodSize',[45 45]);

    % Extract lines from hough transform and peaks
    hLines = houghlines(BMSkel,T,R,hPeaks,...
        'FillGap',100,'MinLength',100);

    %% View results
    % Overlay lines
    [linePos,markerPos] = getVizPosArray(hLines);

    if(~isempty(hLines))
        lineFrame = insertShape(frame,'Line',linePos,...
            'Color','blue','LineWidth',5);
        outFrame = insertObjectAnnotation(lineFrame,...
            'circle',markerPos,'','Color','yellow','LineWidth',5);
    else
        outFrame = frame;
    end
    % Update video player
    step(vidPlayer,outFrame);
end

%% Clean up
release(vidFReader)
release(vidPlayer)