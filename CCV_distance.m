% 颜色聚合向量 主函数
clc;
clear all;

% 初始化
bin=50; %量化级数
coherentPrec=1;%聚合像素阈值 

% 读取图像
Img1=imread('1.jpg');
Img2=imread('2.jpg');

% 颜色聚合向量
CCV1=getCCV(Img1,coherentPrec,bin);
CCV2=getCCV(Img2,coherentPrec,bin);

% 计算两幅图像的距离
D=0;  %两幅图像的距离
for i=1:bin
    C=abs(CCV1(1,i)-CCV2(1,i));
    N=abs(CCV1(2,i)-CCV2(2,i));
    d=C+N;
    D=D+d;
end
function CCV = getCCV(img,coherentPrec, numberOfColors)
    if ~exist('coherentPrec','var')
        coherentPrec = 1;
    end
    if ~exist('numberOfColors','var')
        numberOfColors = 27;
    end
    CCV = zeros(2,numberOfColors);
    %高斯滤波
    Gaus = fspecial('gaussian',[5 5],2);
    img = imfilter(img,Gaus,'same');
    
    [img, updNumOfPix]= discretizeColors(img,numberOfColors);  %量化
    
    imgSize = (size(img,1)*size(img,2));
    thresh = int32((coherentPrec/100) *imgSize);
    
    parfor i=0:updNumOfPix-1
        BW = img==i;
        CC = bwconncomp(BW);
        compsSize = cellfun(@numel,CC.PixelIdxList);
        incoherent = sum(compsSize(compsSize>=thresh));
        CCV(:,i+1) = [incoherent; ...
            sum(compsSize) - incoherent];
    end
end

function [oneChannel, updatedNumC] = discretizeColors(img,numColors)
 
width = size(img,2);
height = size(img,1);
oneChannel = zeros(height,width);
 
% We have 3 channels. For each channel we have V unique values. 
% So we want to find the value of V given that V x V x V ~= numColors
numOfBins = floor(pow2(log2(numColors)/3));
numOfBinsSQ = numOfBins*numOfBins;
img = floor((img/(256/numOfBins)));
for i=1:height
    for j=1:width
        oneChannel(i,j) = img(i,j,1)*numOfBinsSQ ...
            + img(i,j,2)*numOfBins + img(i,j,3);
    end
end
updatedNumC = power(numOfBins,3);
 
end
