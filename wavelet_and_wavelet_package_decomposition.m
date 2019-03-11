clc;
clear all;
%% 1 ͼ��ȥ��
%����ͼƬ
I1 = imread('1.jpg');
L = 4;
I = wextend('2D','zpd',I1,L);
nbc = size(I,1);
X = im2double(I);

%��������
init = 2055415866;
randn('seed',init);
x = X + randn(size(X)) / 10;

%ʹ��sym4С�����źŽ���С���ֽ�
wname = 'sym4';
lev = 3;
[C,S] = wavedec2(x,lev,wname);

% ͼ����ʱ��ʹ��wbmpen ����ѡ����ֵ
alpha = 2;
sigma_s = 0.048535;
thr_s = wbmpen(C,S,sigma_s,alpha);

% ʹ������ֵ�ͱ���ĵ�Ƶ�źţ�����ͼ����
keepapp = 1;
xds1 = wdencmp('gbl',x,wname,lev,thr_s,'s',keepapp);
sigma_h = 0.045663;
thr_h = wbmpen(C,S,sigma_h,alpha);

% ʹ��Ӳ��ֵ�ͱ���ĵ�Ƶ�źţ�����ͼ����
xdh1 = wdencmp('gbl',x,wname,lev,thr_h,'h',keepapp);

%�Ա�ԭͼ�ͼ�������ͼ
figure(1);
subplot(2,3,1);
imshow(I);
title('ԭͼ');
subplot(2,3,4);
imshow(x);
title('����ͼ');

%�Ա�С������ֵ��Ӳ��ֵ�Ľ���Ч��
subplot(2,3,2);
imshow(xds1);
title('С������ֵ����');
subplot(2,3,5);
imshow(xdh1);
title('С��Ӳ��ֵ����');

%����С������
tree = wpdec2(x,lev,wname);
det1 = [wpcoef(tree,2) wpcoef(tree,3) wpcoef(tree,4)];
sigma = median(abs(det1(:)))/0.6745;
alpha = 2;
%����С�����任����ֵ
thr = wpbmpen(tree,sigma,alpha);
keepapp = 1;
%С��������ֵ
xds2 = wpdencmp(tree,'s','nobest',thr,keepapp);
%С����Ӳ��ֵ
xdh2 = wpdencmp(tree,'h','nobest',thr,keepapp);
%������ɫ
colormap(pink(nbc));

%�Ա�С��������ֵ��Ӳ��ֵ�Ľ���Ч��
subplot(2,3,3);
imshow(xds2);
title('С��������ֵ����');
subplot(2,3,6);
imshow(xdh2);
title('С����Ӳ��ֵ����');

%% 2 ͼ��ѹ��
% С���ֽ�ѹ��
load wbarb;
figure(2);
subplot(1,2,1);
image(X);
colormap(map);
title('ԭͼ');

[c,l]=wavedec2(X,2,'db3');
[thr,sorh,keepapp]=ddencmp('cmp','wv',X);
[Xcmp,cxc,lxc,perf0,perf12]=wdencmp('gbl',c,l,'db3',2,thr,sorh,keepapp);

figure(2);
subplot(1,2,2);
image(Xcmp);
colormap(map);
title('С���ֽ�ѹ�����ͼƬ');

disp('С���ֽ�ϵ����Ϊ0��ϵ�������ٷֱȣ�');
perf0
disp('ѹ�����������ٷֱȣ�');
perf12

% С�����ֽ�ѹ��
load wbarb;
%����ɫ��������
nbc = size(map,1);
%�õ��źŵ���ֵ������������С�����Ż���׼
[thr,sorh,keepapp,crit] = ddencmp('cmp','wp',X);
%ͨ�����ϵõ��Ĳ������źŽ���ѹ��
[xd,treed,perf0,perfl2] = wpdencmp(X,sorh,4,'sym4',crit,thr*2,keepapp);
%����������Ϊpink������
%colormap(pink(nbc));

figure(3);
image(wcodemat(xd,nbc));
title('С����ѹ��ͼ��');

disp('С�����ֽ�ϵ����Ϊ0��ϵ�������ٷֱȣ�');
perf0
disp('ѹ�����������ٷֱȣ�');
perfl2





