clc;
clear all;

%归一化后的最高灰度级和梯度值
Ng = 16;
Ns = 16;

A = imread('1.jpg');
A = rgb2gray(A);
A = double(A);

%灰度图像归一化
fmax = max(max(A));
[m,n] = size(A);

for i = 2:m
    for j = n/2 + 1:n
        F(i - 1,j - n/2) = fix(A(i,j)*(Ng - 1)/fmax) + 1;
        end
end

ffmax = max(max(F));
ffmin = min(min(F));

%灰度-梯度共生矩阵法
%sobel边缘算子

for i = 2:m - 1
    for j = n/2 + 1:n - 1
        sx = (A(i - 1,j + 1) + 2 * A(i,j + 1) + A(i + 1,j + 1) - A(i - 1,j - 1) - 2 * A(i,j - 1) + A(i + 1,j - 1));
        sy = (A(i + 1,j - 1) + 2 * A(i + 1,j) + A(i + 1,j + 1) - A(i - 1,j - 1) - 2 * A(i - 1,j) + A(i - 1,j + 1));
        %梯度图像
        B(i - 1,j - n/2) = (sx^2 + sy^2)^0.5;
    end
end

bmax = max(max(B));
[m,n] = size(B);

for i = 1:m
    for j = 1:n
        G(i,j) = floor(B(i,j) * (Ns - 1)/bmax) + 1;
    end
end

ggmax = max(max(G));
ggmin = min(min(G));

%求灰度矩阵
H = zeros(16,16);
for i = 1:m
    for j = 1:n
        x = F(i,j);
        y = G(i,j);
        H(x,y) = H(x,y) + 1;
    end
end

%取灰度矩阵的归一化矩阵
P = zeros(16,16);
P1 = zeros(16,16);
su = sum(sum(H));

for i = 1:Ng
    for j = 1:Ns
        P(i,j) = H(i,j)/su;
        P1(i,j) = (H(i,j) + 1)/(su + 16 * 16);
    end
end

%特征量统计
t1 = 0;
t2 = 0;
t3 = 0;
t4 = 0;
t5 = 0;
t6 = 0;
t7 = 0;
t8 = 0;
t9 = 0;
t10 = 0;
t11 = 0;
t12 = 0;
t13 = 0;
t14 = 0;
t15 = 0;

hs = sum(sum(H));
for i = 1:Ng
    for j = 1:Ns
        %小梯度优势
        t1 = t1 + (H(i,j)/(j^2)/hs);
        
        %大梯度优势
        t2 = t2 + H(i,j)*j^2/hs;
        
        %能量
        t5 = t5 + P(i,j)*P(i,j);
        
        %混合熵
        t13 = t13 - P1(i,j)*log2(P1(i,j));
        
        %惯性
        t14 = t14 + P(i,j) * ((i - j)^2);
        
        %逆差距
        t15 = t15 + (1/(1 + (i - j)^2)) * P(i,j);
    end
end

s2 = 0;
r2 = 0;
for i = 1:Ng
    s1 = 0;
    r1 = 0;
    for j = 1:Ns
        s1 = s1 + H(i,j);
        r1 = r1 + P(i,j);
    end
    s2 = s2 + s1^2;
    r2 = r2 + i * r1;
end

%灰度分布不均匀性
s3 = s2/hs;

%灰度均值
t6 = r2;

s4 = 0;
r4 = 0;
for j = 1:Ns
    s3 = 0;
    r3 = 0;
    for i = 1:Ng
        s3 = s3 + H(i,j);
        r3 = r3 + P(i,j);
    end
    s4 = s4 + s3^2;
    r4 = r4 + j * r3;
end
%梯度分布不均匀性
t4 = s4/hs;
t7 = r4;

s6 = 0;
r6 = 0;
for i = 1:Ng
    s5 = 0;
    r5 = 0;
    for j = 1:Ns
        s5 = s5 + P(i,j);
        r5 = r5 + P1(i,j);
    end
    s6 = s6 + ((i - t6)^2) * s5;
    r6 = r6 + r5 * log2(r5);
end

%灰度均方差
t8 = sqrt(s6);

%灰度熵
t11 = -r6;
        
        
        








        
        
        









