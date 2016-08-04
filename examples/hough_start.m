% Copyright 2015-2016 The MathWorks, Inc.
%%
close all
clear
clc
%% 1. Image with two dots
a = zeros(50);
a(20,20) = 1; a(40,10) = 1;
figure;
subplot(2,2,1)
imshow(a)
title('Image with 2 dots')

%% 2. Image with a line
b = eye(150);
subplot(2,2,3)
imshow(b)
title('Image with a line')