clc;
clear all;

%% 1 ��Сֵ����ֵ�ָ�
I = imread('3.jpg');
I = rgb2gray(I);

figure(1);
subplot(2,2,1);
imshow(I);
title('�ڰ�ԭͼ');

subplot(2,2,2);
imhist(I);
title('ֱ��ͼ');

I1 = im2bw(I,135/255);
subplot(2,2,3);
imshow(I1);

subplot(2,2,4);
imhist(I1);
%% 2 ��С������














