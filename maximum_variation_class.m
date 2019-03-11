clc;
clear all;

SE = strel('diamond',4);

BW1 = imread('4.jpg');
BW2 = imerode(BW1,SE);
BW3 = imdilate(BW2,SE);
BW4 = BW1 - BW3;

figure(1);
subplot(2,4,1);
imshow(BW1);
title('原图');

subplot(2,4,2);
imshow(BW2);
title('腐蚀后的图像');

subplot(2,4,3);
imshow(BW3);
title('膨胀后的图像');

subplot(2,4,4);
imshow(BW4);
title('原图-膨胀图像');

[m,n,k] = size(BW4);
I_gray = rgb2gray(BW4);

figure(1);
subplot(2,4,5)
imshow(I_gray);
title('转换成黑白图');

I_double = double(I_gray);
[wid,len] = size(I_gray);
colorlevel = 256;
hist = zeros(colorlevel,1);
subplot(2,4,6)
imhist(BW4);
title('黑白图的直方图');

for i = 1:wid
    for j = 1:len
        m = I_gray(i,j) + 1;
        hist(m) = hist(m) + 1;
    end
end

hist = hist/(wid*len);
miuT = 0;

for m = 1:colorlevel
    miuT = miuT + (m - 1)*hist(m);
end
xigmaB2 = 0;

for mindex = 1:colorlevel
    threshold = mindex - 1;
    omega1 = 0;
    omega2 = 0;
    for m = 1:threshold - 1
        omega1 = omega1 + hist(m);
    end
    omega2 = 1 - omega1;
    miu1 = 0;
    miu2 = 0;
    for m = 1:colorlevel
        if m < threshold
            miu1 = miu1 + (m - 1)*hist(m);
        else
            miu2 = miu2 + (m - 1)*hist(m);
        end
    end
    miu1 = miu1/omega1;
    miu2 = miu2/omega2;
    xigmaB21 = omega1*(miu1 - miuT)^2 + omega2*(miu2 - miuT)^2;
    xigma(mindex) = xigmaB21;
    if xigmaB21 > xigmaB2
        finalT = threshold;
        xigmaB2 = xigmaB21;
    end
end

fT = finalT/255;
T = graythresh(I_gray);

for i = 1:wid
    for j = 1:len
        if I_double(i,j) > finalT
            bin(i,j) = 1;
        else
            bin(i,j) = 0;
        end
    end
end
subplot(2,4,7);
imshow(bin);
title('最大类间');

subplot(2,4,8);
plot(1:colorlevel,xigma);
title('处理后的直方图');














