% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear
clc
%% Load example video frame
load laneFrame.mat
figure(1)
imshow(frame)
title('Frame')

%% Preprocess
% Threshold the image

% Apply a skeleton morphology to get the thinnest lines


%% Detect Lines
% Perform Hough Transform


% Identify Peaks in Hough Transform


% Extract lines from hough transform and peaks


%% View results
% Overlay lines


% View image
