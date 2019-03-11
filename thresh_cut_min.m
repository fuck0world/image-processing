clc;
clear all;

%% 1 极小值点阈值分割
I = imread('3.jpg');
I = rgb2gray(I);

figure(1);
subplot(2,2,1);
imshow(I);
title('黑白原图');

subplot(2,2,2);
imhist(I);
title('直方图');

I1 = im2bw(I,135/255);
subplot(2,2,3);
imshow(I1);

subplot(2,2,4);
imhist(I1);
%% 2 最小均方误差法














