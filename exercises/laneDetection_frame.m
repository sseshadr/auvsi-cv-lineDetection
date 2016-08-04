% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear
clc
%% Load example video frame
load laneFrame.mat
figure(1)
subplot(1,2,1)
imshow(frame)
title('Frame')

%% Preprocess
% Threshold the image
BM = createLaneMask(frame);
subplot(1,2,2)
imshow(BM)
title('Thresholded Frame')

% Apply a skeleton morphology to get the thinnest lines
BMSkel = bwmorph(BM,'skel',Inf);
figure(3)
imshow(BMSkel)
title('Skeletonized Lines')

%% Detect Lines
% Perform Hough Transform
[H,theta,rho] = hough(BMSkel);

% Identify Peaks in Hough Transform
hPeaks  = houghpeaks(H,30,'Threshold',ceil(0.3*max(H(:))),...
    'NHoodSize',[155 35]);

% Extract lines from hough transform and peaks
hLines = houghlines(BMSkel,theta,rho,hPeaks,'FillGap',70,...
    'MinLength',7);

%% View results
% Overlay lines
[linePos,markerPos] = getVizPosArray(hLines);

lineFrame = insertShape(frame,'Line',linePos,...
            'Color','blue','LineWidth',5);
outFrame = insertObjectAnnotation(lineFrame,...
            'circle',markerPos,'','Color','yellow','LineWidth',5);

% View image
figure(4)
imshow(outFrame)