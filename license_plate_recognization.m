clc;
clear all;
%% 1 读取照片，预处理
I = imread('5.jpg');
figure(1);
imshow(I);

Im1 = rgb2gray(I);
figure(2);
subplot(2,2,1);
imshow(Im1);
title('灰度图');
figure(2);
subplot(2,2,2);
imhist(Im1);
title('灰度图的直方图');
%% 2 增强灰度图
T = imadjust(Im1,[0.19,0.78],[0,1]);
figure(2);
subplot(2,2,3);
imshow(T);
title('增强后的灰度图');
figure(2);
subplot(2,2,4);
imhist(T);
title('增强后的直方图');
%% 3 边缘检测
Im2 = edge(Im1,'sobel',0.1,'both');
figure(3);
subplot(2,2,1);
imshow(Im2);
title('sobel算子实现边缘检测');
%% 4 灰度图腐蚀并腐蚀
se = [1;1;1];
Im3 = imerode(Im2,se);
figure(3);
subplot(2,2,2);
imshow(Im3);
title('腐蚀效果图');
se = strel('rectangle',[25,25]);

Im4 = imclose(Im3,se);
figure(3);
subplot(2,2,3);
imshow(Im4);
title('平滑效果图');
%% 5 移除小对象
Im5 = bwareaopen(Im4,2000);
figure(3);
subplot(2,2,4);
imshow(Im5);
title('移除小对象');
%% 6 区域分割
[y,x,z] = size(Im5);
Im6 = double(Im5);
Blue_y = zeros(y,1);
for i = 1:y
    for j = 1:x
        if (Im6(i,j,1) == 1)
            Blue_y(i,1) = Blue_y(i,1) + 1;
        end
    end
end
[temp MaxY] = max(Blue_y);
PY1 = MaxY;

while((Blue_y(PY1,1) >= 5)&&(PY1 > 1))
    PY1 = PY1 - 1;
end
PY2 = MaxY;
while((Blue_y(PY2,1) >= 5)&&(PY2 < y))
    PY2 = PY2 + 1;
end

IY = I(PY1:PY2,:,:);
Blue_x = zeros(1,x);

for j = 1:x
    for i = PY1:PY2
        if (Im6(i,j,1) == 1)
            Blue_x(1,j) = Blue_x(1,j) + 1;
        end
    end
end

PX1 = 1;
while((Blue_x(1,PX1) < 3)&&(PX1 < x))
    PX1 =  PX1 + 1;
end

PX2 = x;
while((Blue_x(1,PX2) < 3)&&(PX2 > PX1))
    PX2 =  PX2 - 1;
end

PX1 = PX1 - 1;
PX2 = PX2 + 1;
dw = I(PY1:PY2,PX1:PX2,:);

figure(4);
subplot(1,2,1);
imshow(IY);
title('垂直方向合理区域');
subplot(1,2,2);
imshow(dw);
title('定位剪切后的彩色车牌图像');

imwrite(dw,'dw.jpg');
% 图像二值化
a = imread('dw.jpg');
b = rgb2gray(a);

figure(5);
subplot(2,3,1);
imshow(a);
title('原图');

subplot(2,3,2);
imshow(b);
title('rgb2gray后的');

g_max = double(max(max(b)));
g_min = double(min(min(b)));

%设立阈值以区分需要的信息和其他干扰信息
T = round(g_max - (g_max - g_min) / 2);
[m,n] = size(b);
d = (double(b) >= T);

subplot(2,3,3);
imshow(d);
title('车牌的二值图像');


subplot(2,3,4);
imshow(d);
title('均值滤波之前的图像');

h = fspecial('average',3);
d = im2bw(round(filter2(h,d)));

subplot(2,3,5);
imshow(d);
title('均值滤波之后的图像');

se = eye(2);
[m,n] = size(d);
if bwarea(d)/m/n >= 0.365
    d = imerode(d,se);
elseif bwarea(d)/m/n <= 0.235
    d = imdilate(d,se);
end

subplot(2,3,6);
imshow(d);
title('膨胀或腐蚀之后的图像')

%% 字符分割与归一化
[m,n] = size(d);





















