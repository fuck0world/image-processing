% 小波压缩
clc;
clear all;
load wbarb;
wname = 'bior3.7';
[C,S] = wavedec2(X,2,wname);

%提取小波分解结构中第一层低频系数和高频系数
ca1 = appcoef2(C,S,wname,1);
ch1 = detcoef2('h',C,S,1);
cv1 = detcoef2('v',C,S,1);
cd1 = detcoef2('d',C,S,1);

%分别对各频率成分进行重构
a1 = wrcoef2('a',C,S,wname,1);
h1 = wrcoef2('h',C,S,wname,1);
v1 = wrcoef2('v',C,S,wname,1);
d1 = wrcoef2('d',C,S,wname,1);
c1 = [a1,h1;v1,d1];

%开始压缩图像，保留小波分解第一层低频信息，第一层的低频信息即为ca1，显示第一层的低频信息
%首先对第一层信息进行量化编码
ca1 = appcoef2(C,S,wname,1);
ca1 = wcodemat(ca1,440,'mat',0);

%压缩为原图的0.5
ca1 = 0.5*ca1;

%保留小波分解第二层低频信息，进行图像的压缩，此时压缩比更大，第二层的低频信息即为ca2，显示第二层的低频信息
ca2 = appcoef2(C,S,wname,2);

%首先对第二层信息进行量化编码
ca2 = wcodemat(ca2,440,'mat',0);

%压缩为原图的0.25
ca2 = 0.25*ca2;

%显示图像、分解后各频率成分的信息
figure(2);
subplot(2,2,1);
image(X);
colormap(map);
title('原始图像');
axis square;

subplot(2,2,2);
image(c1);
axis square;
title('分解后低频和高频信息');

subplot(2,2,3);
image(ca1);
colormap(map);
axis square;
title('第一次压缩');

subplot(2,2,4);
image(ca2);
colormap(map);
axis square;
title('第二次压缩');

disp('压缩前图像X的大小：');
whos('X')
disp('第一次压缩图像的大小为：');
whos('ca1')
disp('第二次压缩图像的大小为：');
whos('ca2')


