clc;
clear all;

%% 1 小波降噪

%读入图片
I1 = imread('1.jpg');
L = 4;
I = wextend('2D','zpd',I1,L);
nbc = size(I,1);
X = im2double(I);

%生成噪声
init = 2055415866;
randn('seed',init);
x = X + randn(size(X)) / 10;

%使用sym4小波对信号进行小波分解
wname = 'sym4';
lev = 3;
[C,S] = wavedec2(x,lev,wname);

% 图像降噪时，使用wbmpen 函数选择阈值
alpha = 2;
sigma_s = 0.048535;
thr_s = wbmpen(C,S,sigma_s,alpha);

% 使用软阈值和保存的低频信号，进行图像降噪
keepapp = 1;
xds1 = wdencmp('gbl',x,wname,lev,thr_s,'s',keepapp);
sigma_h = 0.045663;
thr_h = wbmpen(C,S,sigma_h,alpha);

% 使用硬阈值和保存的低频信号，进行图像降噪
xdh1 = wdencmp('gbl',x,wname,lev,thr_h,'h',keepapp);

%对比原图和加噪声的图
figure(1);
subplot(2,3,1);
imshow(I);
title('原图');
subplot(2,3,4);
imshow(x);
title('加噪图');

%对比小波软阈值和硬阈值的降噪效果
subplot(2,3,2);
imshow(xds1);
title('小波软阈值降噪');
subplot(2,3,5);
imshow(xdh1);
title('小波硬阈值降噪');

%生成小波包树
tree = wpdec2(x,lev,wname);
det1 = [wpcoef(tree,2) wpcoef(tree,3) wpcoef(tree,4)];
sigma = median(abs(det1(:)))/0.6745;
alpha = 2;
%计算小波包变换的阈值
thr = wpbmpen(tree,sigma,alpha);
keepapp = 1;
%小波包软阈值
xds2 = wpdencmp(tree,'s','nobest',thr,keepapp);
%小波包硬阈值
xdh2 = wpdencmp(tree,'h','nobest',thr,keepapp);
%设置颜色
colormap(pink(nbc));

%对比小波包软阈值和硬阈值的降噪效果
subplot(2,3,3);
imshow(xds2);
title('小波包软阈值降噪');
subplot(2,3,6);
imshow(xdh2);
title('小波包硬阈值降噪');

%% 2 图像压缩
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

% 小波包压缩

%求颜色索引表长度
nbc = size(map,1);
%得到信号的阈值，保留层数，小波树优化标准
[thr,sorh,keepapp,crit] = ddencmp('cmp','wp',X);
%通过以上得到的参数对信号进行压缩
[xd,treed,perf0,perfl2] = wpdencmp(X,sorh,4,'sym4',crit,thr*2,keepapp);
%更改索引表为pink索引表
colormap(pink(nbc));

figure(3);
subplot(1,2,1);
image(wcodemat(X,nbc));
title('原始图像');

subplot(1,2,2);
image(wcodemat(xd,nbc));
title('全局阈值化压缩图像');

plot(treed);
xlabel(['能量成分',num2str(perfl2),'%','零系数成分',num2str(perf0),'%']);

%%
% 小波分解压缩

load wbarb;
%subplot(2,2,1);
image(X);
colormap(map);
title('原图');

[c,l]=wavedec2(X,2,'db3');
[thr,sorh,keepapp]=ddencmp('cmp','wv',X);
[Xcmp,cxc,lxc,perf0,perf12]=wdencmp('gbl',c,l,'db3',2,thr,sorh,keepapp);

%subplot(2,2,2);
image(Xcmp);
colormap(map);
title('小波分解压缩后的图片');

disp('小波分解系数中为0的系数个数百分比：');
perf0
disp('压缩后保留能量百分比：');
perf12

%z小波包分解压缩
load wbarb;
%求颜色索引表长度
nbc = size(map,1);
%得到信号的阈值，保留层数，小波树优化标准
[thr,sorh,keepapp,crit] = ddencmp('cmp','wp',X);
%通过以上得到的参数对信号进行压缩
[xd,treed,perf0,perfl2] = wpdencmp(X,sorh,4,'sym4',crit,thr*2,keepapp);
%更改索引表为pink索引表
colormap(pink(nbc));


%subplot(2,2,3);
image(wcodemat(xd,nbc));
title('小波包压缩图像');

disp('小波包分解系数中为0的系数个数百分比：');
perf0
disp('压缩后保留能量百分比：');
perfl2

plot(treed);
xlabel(['能量成分',num2str(perfl2),'%','零系数成分',num2str(perf0),'%']);
