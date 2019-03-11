clc;
clear all;
%% 1 读取照片，预处理
I = imread('raw4.jpg');
figure(1);
subplot(3,3,1);
imshow(I);

Im1 = rgb2gray(I);
subplot(3,3,2);
imshow(Im1);
title('灰度图');

subplot(3,3,3);
imhist(Im1);
title('灰度图的直方图');
%% 2 增强灰度图
T = imadjust(Im1,[0.19,0.78],[0,1]);

subplot(3,3,4);
imshow(T);
title('增强后的灰度图');

subplot(3,3,5);
imhist(T);
title('增强后的直方图');
%% 3 边缘检测
Im2 = edge(Im1,'sobel',0.1,'both');

subplot(3,3,6);
imshow(Im2);
title('sobel算子实现边缘检测');
%% 4 灰度图腐蚀并腐蚀
se = [1;1;1];
Im3 = imerode(Im2,se);

subplot(3,3,7);
imshow(Im3);
title('腐蚀效果图');
se = strel('rectangle',[25,25]);

figure(1);
Im4 = imclose(Im3,se);
figure(1);
subplot(3,3,8);
imshow(Im4);
title('平滑效果图');
%% 5 移除小对象
Im5 = bwareaopen(Im4,2000);
figure(1);
subplot(3,3,9);
imshow(Im5);
title('移除小对象');
%% 6 区域分割
[y,x,z] = size(Im5);
Im6 = double(Im5);
Blue_y = zeros(y,1);
for i = 1:y
    for j = 1:x
        if (Im6(i,j,1) == 1)
            Blue_y(i,1) = Blue_y(i,1) + 1; % 统计蓝色像素点
        end
    end
end

%车牌区域确定
%%%%%% Y方向 %%%%%%%%% 
[temp MaxY] = max(Blue_y);
PY1 = MaxY;
while((Blue_y(PY1,1) >= 5)&&(PY1 > 1))
    PY1 = PY1 - 1;
end
PY2 = MaxY;
while((Blue_y(PY2,1) >= 5)&&(PY2 < y))
    PY2 = PY2 + 1;
end

%%%%%% X方向 %%%%%%%%% 
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

%车牌区域矫正
PX1 = PX1 - 1;
PX2 = PX2 + 1;
dw = I(PY1:PY2,PX1:PX2,:);

figure(2);
subplot(3,3,1);
imshow(IY);
title('垂直方向合理区域');
subplot(3,3,2);
imshow(dw);
title('定位剪切后的彩色车牌图像');

imwrite(dw,'dw.jpg');
% 图像二值化
a = imread('dw.jpg');
b = rgb2gray(a);


subplot(3,3,3);
imshow(a);
title('原图');

subplot(3,3,4);
imshow(b);
title('rgb2gray后的');

g_max = double(max(max(b)));
g_min = double(min(min(b)));

%设立阈值以区分需要的信息和其他干扰信息
T = round(g_max - (g_max - g_min) / 2);
[m,n] = size(b);
d = (double(b) >= T);

subplot(3,3,5);
imshow(d);
title('车牌的二值图像');


subplot(3,3,6);
imshow(d);
title('均值滤波之前的图像');

h = fspecial('average',3);
d = im2bw(round(filter2(h,d)));

subplot(3,3,7);
imshow(d);
title('均值滤波之后的图像');

se = eye(2);
[m,n] = size(d);
if bwarea(d)/m/n >= 0.365
    d = imerode(d,se);
elseif bwarea(d)/m/n <= 0.235
    d = imdilate(d,se);
end

subplot(3,3,8);
imshow(d);
title('膨胀或腐蚀之后的图像')

%% 7 字符分割与归一化
% 寻找连续有文字的块，若长度大于某阈值，则认为该块有两个字符组成，需要分割 
d = qiege(d); 
[m,n] = size(d); 

subplot(3,3,9);
imshow(d);
title(n);

k1 = 1;
k2 = 1;
s = sum(d);
j = 1; 
while j ~= n 
    while s(j) == 0 
        j = j+1; 
    end
    k1 = j; 
    while s(j) ~= 0 && j <= n-1 
        j = j+1; 
    end
    k2 = j-1; 
    if k2-k1 >= round(n / 6.5) 
        [val,num] = min(sum(d(:,[k1 + 5:k2 - 5]))); 
        d(:,k1 + num + 5) = 0; % 分割 
    end
end

% 再切割

d = qiege(d); % 切割出 7 个字符 
y1 = 10;
y2 = 0.25;
flag = 0;
word1 = []; 
while flag == 0 
    [m,n] = size(d); 
    left = 1;
    wide = 0; 
    while sum(d(:,wide+1)) ~= 0 
        wide = wide + 1; 
    end
    if wide < y1 % 认为是左侧干扰 
        d(:,[1:wide]) = 0; 
        d = qiege(d); 
    else
        temp = qiege(imcrop(d,[1 1 wide m])); 
        [m,n] = size(temp); 
        all = sum(sum(temp)); 
        two_thirds = sum(sum(temp([round(m/3):2*round(m/3)],:))); 
        if two_thirds / all > y2 
            flag = 1;
            word1 = temp; % WORD 1 
        end
        d(:,[1:wide]) = 0;
        d = qiege(d); 
    end
end


% 分割出第二个字符
[word2,d]=getword(d); 
% 分割出第三个字符 
[word3,d]=getword(d);
% 分割出第四个字符 
[word4,d]=getword(d); 
% 分割出第五个字符 
[word5,d]=getword(d); 
% 分割出第六个字符 
[word6,d]=getword(d); 
% 分割出第七个字符 
[word7,d]=getword(d); 

figure(3);
subplot(3,7,1);
imshow(word1);
title('第1个字符'); 

subplot(3,7,2);
imshow(word2);
title('第2个字符'); 

subplot(3,7,3);
imshow(word3);
title('第3个字符'); 

subplot(3,7,4);
imshow(word4);
title('第4个字符'); 

subplot(3,7,5);
imshow(word5);
title('第5个字符'); 

subplot(3,7,6);
imshow(word6);
title('第6个字符');

subplot(3,7,7);
imshow(word7);
title('第7个字符'); 

% 归一化大小为 40*20 
[m,n]=size(word1); 
word1=imresize(word1,[40 20]); 
word2=imresize(word2,[40 20]); 
word3=imresize(word3,[40 20]); 
word4=imresize(word4,[40 20]); 
word5=imresize(word5,[40 20]);
word6=imresize(word6,[40 20]); 
word7=imresize(word7,[40 20]); 

subplot(3,7,8);
imshow(word1);
title('归一化后的第1个字符'); 

subplot(3,7,9);
imshow(word2);
title('归一化后的第2个字符'); 

subplot(3,7,10);
imshow(word3);
title('归一化后的第3个字符'); 

subplot(3,7,11);
imshow(word4);
title('归一化后的第4个字符'); 

subplot(3,7,12);
imshow(word5);
title('归一化后的第5个字符'); 

subplot(3,7,13);
imshow(word6);
title('归一化后的第6个字符'); 

subplot(3,7,14);
imshow(word7);
title('归一化后的第7个字符'); 

%% 8 细化
Xi1 = bwmorph(word1,'thin',5);
Xi2 = bwmorph(word2,'thin',5);
Xi3 = bwmorph(word3,'thin',5);
Xi4 = bwmorph(word4,'thin',5);
Xi5 = bwmorph(word5,'thin',5);
Xi6 = bwmorph(word6,'thin',5);
Xi7 = bwmorph(word7,'thin',5);

subplot(3,7,15);
imshow(Xi1);
title('细化后的第1个字符');

subplot(3,7,16);
imshow(Xi2);
title('细化后的第2个字符');

subplot(3,7,17);
imshow(Xi3);
title('细化后的第3个字符');

subplot(3,7,18);
imshow(Xi4);
title('细化后的第4个字符');

subplot(3,7,19);
imshow(Xi5);
title('细化后的第5个字符');

subplot(3,7,20);
imshow(Xi6);
title('细化后的第6个字符');

subplot(3,7,21);
imshow(Xi7);
title('细化后的第7个字符');

imwrite(word1,'1.jpg'); 
imwrite(word2,'2.jpg'); 
imwrite(word3,'3.jpg'); 
imwrite(word4,'4.jpg'); 
imwrite(word5,'5.jpg'); 
imwrite(word6,'6.jpg'); 
imwrite(word7,'7.jpg'); 
%% 9 字符的识别
liccode = char(['0':'9' 'A':'Z' '京宁沪苏陕冀']); 
%建立自动识别字符代码表 1~10 数字 11~36 字母 37~41汉字 
SubBw2 = zeros(40,20);%生成一个40*20大小的零矩阵 
l = 1; 

for I = 1:7  
    ii = int2str(I);%整形数据转字符串类型
    t = imread([ii,'.jpg']); 
    SegBw2=imresize(t,[40 20],'nearest');%缩放处理 
    %第一位汉字识别
    if l==1  
        kmin=37; 
        kmax=41; 
    elseif l==2 %第二位 A~Z 字母识别 
        kmin=11; 
        kmax=36; 
    else l>=3 %第三位以后是字母或数字识别 
        kmin=1; 
        kmax=36; 
    end
    for k2=kmin:kmax 
        fname=strcat('样本库\',liccode(k2),'.bmp');
          SamBw2 = imread(fname);
            for  i = 1:40
                for j = 1:20
                    SubBw2(i,j) = SegBw2(i,j) - SamBw2(i,j);
                end
            end
           % 以上相当于两幅图相减得到第三幅图
            Dmax = 0;
            for k1 = 1:40
                for l1 = 1:20
                    if  ( SubBw2(k1,l1) > 0 || SubBw2(k1,l1) <0 )
                        Dmax=Dmax+1;
                    end
                end
            end
            Error(k2) = Dmax;
        end
        Error1 = Error(kmin:kmax);
        MinError = min(Error1);
        findc = find(Error1 == MinError);
        Code(l*2-1) = liccode(findc(1) + kmin-1);
        Code(l*2)=' ';
        l = l + 1;
end
figure(4),imshow(dw),title (['车牌号码:', Code],'Color','b');


function e=qiege(d) 
    [m,n]=size(d); 
    top=1;bottom=m;
    left=1;
    right=n; % init 
    while sum(d(top,:))==0 && top<=m 
        top=top+1; 
    end
    while sum(d(bottom,:))==0 && bottom>=1 
        bottom=bottom-1; 
    end
    while sum(d(:,left))==0 && left<=n 
        left=left+1; 
    end
    while sum(d(:,right))==0 && right>=1 
        right=right-1; 
    end
    dd=right-left; 
    hh=bottom-top; 
    e=imcrop(d,[left top dd hh]);%该函数用于返回图像的一个裁剪区域
end

function [word,result]=getword(d)
    word=[];
    flag=0;
    y1=8;
    y2=0.5; 
    while flag==0 
        [m,n]=size(d); 
        wide=0; 
        while sum(d(:,wide+1))~=0 && wide<=n-2 
            wide=wide+1; 
        end
        temp=qiege(imcrop(d,[1 1 wide m])); 
        [m1,n1]=size(temp); 
        if wide<y1 && n1/m1>y2 
            d(:,[1:wide])=0; 
            if sum(sum(d))~=0 
                d=qiege(d); % 切割出最小范围 
            else
                word=[];
                flag=1; 
            end
        else
            word=qiege(imcrop(d,[1 1 wide m])); 
            d(:,[1:wide])=0; 
            if sum(sum(d))~=0; 
                d=qiege(d);
                flag=1; 
            else
                d=[]; 
            end
        end
    end 
    result=d;
end









