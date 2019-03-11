clc;
clear all;

%��һ�������߻Ҷȼ����ݶ�ֵ
Ng = 16;
Ns = 16;

A = imread('1.jpg');
A = rgb2gray(A);
A = double(A);

%�Ҷ�ͼ���һ��
fmax = max(max(A));
[m,n] = size(A);

for i = 2:m
    for j = n/2 + 1:n
        F(i - 1,j - n/2) = fix(A(i,j)*(Ng - 1)/fmax) + 1;
        end
end

ffmax = max(max(F));
ffmin = min(min(F));

%�Ҷ�-�ݶȹ�������
%sobel��Ե����

for i = 2:m - 1
    for j = n/2 + 1:n - 1
        sx = (A(i - 1,j + 1) + 2 * A(i,j + 1) + A(i + 1,j + 1) - A(i - 1,j - 1) - 2 * A(i,j - 1) + A(i + 1,j - 1));
        sy = (A(i + 1,j - 1) + 2 * A(i + 1,j) + A(i + 1,j + 1) - A(i - 1,j - 1) - 2 * A(i - 1,j) + A(i - 1,j + 1));
        %�ݶ�ͼ��
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

%��ҶȾ���
H = zeros(16,16);
for i = 1:m
    for j = 1:n
        x = F(i,j);
        y = G(i,j);
        H(x,y) = H(x,y) + 1;
    end
end

%ȡ�ҶȾ���Ĺ�һ������
P = zeros(16,16);
P1 = zeros(16,16);
su = sum(sum(H));

for i = 1:Ng
    for j = 1:Ns
        P(i,j) = H(i,j)/su;
        P1(i,j) = (H(i,j) + 1)/(su + 16 * 16);
    end
end

%������ͳ��
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
        %С�ݶ�����
        t1 = t1 + (H(i,j)/(j^2)/hs);
        
        %���ݶ�����
        t2 = t2 + H(i,j)*j^2/hs;
        
        %����
        t5 = t5 + P(i,j)*P(i,j);
        
        %�����
        t13 = t13 - P1(i,j)*log2(P1(i,j));
        
        %����
        t14 = t14 + P(i,j) * ((i - j)^2);
        
        %����
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

%�Ҷȷֲ���������
s3 = s2/hs;

%�ҶȾ�ֵ
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
%�ݶȷֲ���������
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

%�ҶȾ�����
t8 = sqrt(s6);

%�Ҷ���
t11 = -r6;
        
        
        








        
        
        









