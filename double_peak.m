clc;
clear all;
close all;

I = imread('4.jpg');
figure;
subplot(2,2,1);
imshow(I);

I = rgb2gray(I);
subplot(2,2,2);
imshow(I);

%统计每个灰度值的个数
fxy = imhist(I);
subplot(2,2,3);
plot(fxy);

p1 = {'Input Num:'};
p2 = {'180'};
p3 = inputdlg(p1,'input',2,p2);

p = str2num(p3{1});
p = p/255;
bw = im2bw(I,p);
subplot(2,2,4);
imshow(bw);





