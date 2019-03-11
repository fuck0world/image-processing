clc
clear all;

%灰度共生矩阵法
A = imread('1.jpg');

%图像平滑
[m,n] = size(A);

%定义布长
hw = 2;
B = zeros(m - 2 * hw, n - 2 * hw);

for i = (1 + hw) : (m - hw)
    for j = (1 + hw) : (n - hw)
        wi = A((i - hw):(i + hw),(j - hw):(j + hw));
        B(i - hw,j - hw,1) = mean2(wi);
    end
end

B(:,:,2) = A(1 + hw:m - hw,1 + hw:n - hw);
B = uint8(B);

figure(1);
subplot(2,1,1);
imshow(B(:,:,1));
title('平滑后的图像');

subplot(2,1,2);
imshow(B(:,:,2));
title('平滑前的图像');

[m,n,l] = size(B);

%求联合分布直方图
P = zeros(256,256);
for i = 1:1:m
    for j = 1:1:n
        x = B(i,j,1) + 1;
        y = B(i,j,2) + 1;
        P(x,y) = P(x,y) + 1;
    end
end

figure(2);
hist(P);

P = P./m./n;
h0 = zeros(256,256);

% 1 求反差
for i = 1:256
    for j = 1:256
        h0(i,j) = (abs(i - j)^2)*P(i,j);
    end
end

f(1) = sum(sum(h0));
% 2 求熵
for i = 1:256
    for j = 1:256
        if P(i,j) > 0
            h0(i,j) = - P(i,j) * log2(P(i,j));
        end
    end
end

f(2) = sum(sum(h0));
% 3 求逆差距
for i = 1:256
    for j = 1:256
        ho(i,j) = P(i,j) / ((abs(i - j))^2 + 1);
    end
end

f(3) = sum(sum(h0));
% 4 求能量
for i = 1:256
    for j = 1:256
        h0(i,j) = P(i,j)^2;
    end
end

f(4) = sum(sum(h0));
% 5 求集群荫
h0 = P;

ux = 0;
uy = 0;
dx = 0;
dy = 0;

i = 1:256;

ux = mean2(i * sum(h0,2));
uy = mean2(sum(h0,1) * i');
dx = sqrt(mean2(((i - ux).^2) * sum(h0,2)));
dy = sqrt(mean2(sum(h0,1) * (((i - uy).^2)')));

for i = 1:256
    for j = 1:256
        h0(i,j) = (((i - ux) + (j - uy))^3) * P(i,j);
    end
end

f(5) = sum(sum(h0));
% 6 求集群突出
for i = 1:256
    for j = 1:256
        h0(i,j) = ((i - ux) + (j - uy))^4 * P(i,j);
    end
end

f(6) = sum(sum(h0));
% 7 求灰度相关
for i = 1:256
    for j = 1:256
        h0(i,j) = (i - ux) * (j - uy) * P(i,j);
    end
end
f(7) = (sum(sum(h0)))/dx/dy;



































