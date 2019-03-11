clc
clear all;

I = imread('1.jpg');
%I_gray = rgb2gray(I);
level = graythresh(I);

[height,width] = size(I);
bw = im2bw(I,level);

figure(1);
imshow(bw);

%标注二进制图像中已连接的部分
[L,num] = bwlabel(bw,8);

plot_x = zeros(1,1);
plot_y = zeros(1,1);

%求质心
sum_x = 0;
sum_y = 0;
area = 0;
[height,width] = size(bw);

for i = 1:height
    for j = 1:width
        if L(i,j) == 1
            sum_x = sum_x + i;
            sum_y = sum_y + j;
            area = area + 1;
        end
    end
end

%质心的坐标
plot_x(1) = fix(sum_x/area);
plot_y(1) = fix(sum_y/area);
figure(2);
imshow(bw);
hold on;
plot(plot_y(1),plot_x(1),'wo','markerfacecolor',[0 0 0])





