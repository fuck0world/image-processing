clc;
clear all;
%% 1 图像去噪
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
% 小波分解压缩
load wbarb;
figure(2);
subplot(1,2,1);
image(X);
colormap(map);
title('原图');

[c,l]=wavedec2(X,2,'db3');
[thr,sorh,keepapp]=ddencmp('cmp','wv',X);
[Xcmp,cxc,lxc,perf0,perf12]=wdencmp('gbl',c,l,'db3',2,thr,sorh,keepapp);

figure(2);
subplot(1,2,2);
image(Xcmp);
colormap(map);
title('小波分解压缩后的图片');

disp('小波分解系数中为0的系数个数百分比：');
perf0
disp('压缩后保留能量百分比：');
perf12

% 小波包分解压缩
load wbarb;
%求颜色索引表长度
nbc = size(map,1);
%得到信号的阈值，保留层数，小波树优化标准
[thr,sorh,keepapp,crit] = ddencmp('cmp','wp',X);
%通过以上得到的参数对信号进行压缩
[xd,treed,perf0,perfl2] = wpdencmp(X,sorh,4,'sym4',crit,thr*2,keepapp);
%更改索引表为pink索引表
%colormap(pink(nbc));

figure(3);
image(wcodemat(xd,nbc));
title('小波包压缩图像');

disp('小波包分解系数中为0的系数个数百分比：');
perf0
disp('压缩后保留能量百分比：');
perfl2





