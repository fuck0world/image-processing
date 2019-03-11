clc
clear all;

%% 1 ��ɫֱ��ͼ
I = imread('1.jpg');
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

set(0,'defaultfigurePosition',[100,100,1000,500]);
set(0,'defaultFigureColor',[1,1,1]);

figure(1);
subplot(2,2,1);
imshow(I);

subplot(2,2,2);
imshow(R);

subplot(2,2,3);
imshow(G);

subplot(2,2,4);
imshow(B);

figure(2);
subplot(2,2,1);
imhist(I);

subplot(2,2,2);
imhist(R);

subplot(2,2,3);
imhist(G);

subplot(2,2,4);
imhist(B);

%% 2 ��ɫ��
J = imread('1.jpg');
K = imadjust(J,[70/255 160/255],[]);

figure(3);
subplot(1,2,1);
imshow(J);
xlabel('(a)ԭͼ��');

subplot(1,2,2);
imshow(K);
xlabel('(b)�Աȶ���ǿ���ͼ��');

[m,n] = size(J);
m1 = round(m/2);
m2 = round(n/2);

[p,q] = size(K);
p1 = round(p/2);
q1 = round(q/2);

J = double(J);
K = double(K);
colorsum = 0;

disp('ԭͼ��һ�׾�');
Jg = mean2(J)
disp('��ǿ�ԱȶȺ�ͼ��һ�׾�');
Kg = mean2(K)

disp('ԭͼ��Ķ��׾�');
Jd = std(std(J))
disp('��ǿ�ԱȶȺ�ͼ����׾�');
Kd = std(std(K))

for i = 1:m1
    for j = 1:m2
        colorsum = colorsum + (J(i,j) - Jg)^3;
    end
end

disp('ԭͼ������׾�');
Je = (colorsum/(m1*m2))^(1/3)
colorsum = 0;

for i = 1:p1
    for j = 1:q1
        colorsum = colorsum + (J(i,j) - Kg)^3;
    end
end

disp('��ǿ�ԱȶȺ��ͼ�����׾�');
Ke = (colorsum/(p1*q1))^(1/3)

%% 3 ��ɫ�ۺ�����
bin = 50;
coherentPrec = 1;

Imag1 = imread('1.jpg');

if ~exist('coherentPrec','var')
    coherentPrec = 1;
end
    if ~exist('numberOfColors','var')
        numberOfColors = 27;
    end
    CCV = zeros(2,numberOfColors);
    
    Gaus = fspecial('gaussian',[5 5],2);
    img = imfilter(Imag1,Gaus,'same');
    [img,updNumOfPix] = discretizeColors(img,numberOfColors);
    imgSize = (size(img,1)*size(img,2));
    thresh = int32((coherentPrec/100)*imgSize);
    parfor i = 0:updNumOfPix - 1
        BW = img == i;
        CC = bwconncomp(BW);
        compsSize = cellfun(@numel,CC.PixelIndexList);
        incoherent = sum(compsSize(compsSize >= thresh));
        CCV(:,i + 1) = [incoherent;...
            sum(compsSize) - incoherent];
    end
  
        
        
        
        




















