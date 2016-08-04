% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear
clc
%% Load example video frame
load frame51.mat
figure(1)
subplot(1,2,1)
imshow(frame)
title('Frame')

%% Preprocess
% Block Orange Cones
frameNoOrange = blockOrangeCones(frame);
subplot(1,2,2)
imshow(frameNoOrange)
title('Blocked Orange Cones')

% Mask
BW = createLineMaskHSV(frameNoOrange);
figure(2)
subplot(1,2,1)
imshow(BW)
title('Lines')

% Apply a close morphology to make continuous lines
BM = imclose(BW,strel('disk',10));
subplot(1,2,2)
imshow(BM)
title('Continuous Lines')

% Apply a skeleton morphology to get the thinnest lines
BMSkel = bwmorph(BM,'skel',Inf);
figure(3)
imshow(BMSkel)
title('Skeletonized Lines')

%% Detect Lines
% Perform Hough Transform
[H,T,R] = hough(BMSkel);

% Identify Peaks in Hough Transform
hPeaks =  houghpeaks(H,10,'NHoodSize',[55 11]);

% Extract lines from hough transform and peaks
hLines = houghlines(BMSkel,T,R,hPeaks,...
        'FillGap',100,'MinLength',100);

%% View results
% Overlay lines
[linePos,markerPos] = getVizPosArray(hLines);

lineFrame = insertShape(frame,'Line',linePos,...
            'Color','blue','LineWidth',5);
outFrame = insertObjectAnnotation(lineFrame,...
            'circle',markerPos,'','Color','yellow','LineWidth',5);

% View image
figure(5)
imshow(outFrame)
title('Detected Lines')