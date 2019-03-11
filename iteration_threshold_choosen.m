clc;
clear all;

I = imread('3.jpg');
I = rgb2gray(I);

figure(1);
subplot(2,2,1);
imshow(I);
title('ºÚ°×Ô­Í¼');

figure(1);
subplot(2,2,2);
imhist(I);
title('Ö±·½Í¼');

[x,y] = size(I);
I = im2double(I);
a = imhist(I);

maxI = 1;
I = I*255;

for i = 2:max(size(a))
    if a(maxI) < a(i)
        maxI = i;
    end
end

minI = 1;
for i = 2:max(size(a))
    if a(minI) > a(i)
        minI = i;
    end
end

z0 = maxI;
z1 = minI;
T = floor((z0+z1)/2+0.5);

TT = 0;
S0 = 0;
n0 = 0;
S1 = 0;
n1 = 0;
allow = 0.001;
d = abs(T - TT);
count = 0;
while(d >= allow)
    count = count + 1;
    for i = 1:x
        for j = 1:y
            if (I(i,j) >= T)
                S0 = S0 + I(i,j);
                n0 = n0 + 1;
            end
            if (I(i,j) < T)
                S1 = S1 + I(i,j);
                n1 = n1 + 1;
            end
        end
    end
    T0 = S0/n0;
    T1 = S1/n1;
    TT = (T0 + T1)/2;
    d = abs(T - TT);
    T = TT;
end

tmax2 = T;
Seg = zeros(x,y);
for i = 1:x
    for j = 1:y
        if (I(i,j) >= T)
            Seg(i,j) = 1;
        end
    end
end

subplot(2,2,3);
imshow(Seg);

subplot(2,2,4);
imhist(Seg);






