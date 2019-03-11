clc;
clear all;

%% 1 С������

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
% С��ѹ��
clc;
clear all;
load wbarb;
wname = 'bior3.7';
[C,S] = wavedec2(X,2,wname);

%��ȡС���ֽ�ṹ�е�һ���Ƶϵ���͸�Ƶϵ��
ca1 = appcoef2(C,S,wname,1);
ch1 = detcoef2('h',C,S,1);
cv1 = detcoef2('v',C,S,1);
cd1 = detcoef2('d',C,S,1);

%�ֱ�Ը�Ƶ�ʳɷֽ����ع�
a1 = wrcoef2('a',C,S,wname,1);
h1 = wrcoef2('h',C,S,wname,1);
v1 = wrcoef2('v',C,S,wname,1);
d1 = wrcoef2('d',C,S,wname,1);
c1 = [a1,h1;v1,d1];

%��ʼѹ��ͼ�񣬱���С���ֽ��һ���Ƶ��Ϣ����һ��ĵ�Ƶ��Ϣ��Ϊca1����ʾ��һ��ĵ�Ƶ��Ϣ
%���ȶԵ�һ����Ϣ������������
ca1 = appcoef2(C,S,wname,1);
ca1 = wcodemat(ca1,440,'mat',0);

%ѹ��Ϊԭͼ��0.5
ca1 = 0.5*ca1;

%����С���ֽ�ڶ����Ƶ��Ϣ������ͼ���ѹ������ʱѹ���ȸ��󣬵ڶ���ĵ�Ƶ��Ϣ��Ϊca2����ʾ�ڶ���ĵ�Ƶ��Ϣ
ca2 = appcoef2(C,S,wname,2);

%���ȶԵڶ�����Ϣ������������
ca2 = wcodemat(ca2,440,'mat',0);

%ѹ��Ϊԭͼ��0.25
ca2 = 0.25*ca2;

%��ʾͼ�񡢷ֽ���Ƶ�ʳɷֵ���Ϣ
figure(2);
subplot(2,2,1);
image(X);
colormap(map);
title('ԭʼͼ��');
axis square;

subplot(2,2,2);
image(c1);
axis square;
title('�ֽ���Ƶ�͸�Ƶ��Ϣ');

subplot(2,2,3);
image(ca1);
colormap(map);
axis square;
title('��һ��ѹ��');

subplot(2,2,4);
image(ca2);
colormap(map);
axis square;
title('�ڶ���ѹ��');

disp('ѹ��ǰͼ��X�Ĵ�С��');
whos('X')
disp('��һ��ѹ��ͼ��Ĵ�СΪ��');
whos('ca1')
disp('�ڶ���ѹ��ͼ��Ĵ�СΪ��');
whos('ca2')

% С����ѹ��

%����ɫ��������
nbc = size(map,1);
%�õ��źŵ���ֵ������������С�����Ż���׼
[thr,sorh,keepapp,crit] = ddencmp('cmp','wp',X);
%ͨ�����ϵõ��Ĳ������źŽ���ѹ��
[xd,treed,perf0,perfl2] = wpdencmp(X,sorh,4,'sym4',crit,thr*2,keepapp);
%����������Ϊpink������
colormap(pink(nbc));

figure(3);
subplot(1,2,1);
image(wcodemat(X,nbc));
title('ԭʼͼ��');

subplot(1,2,2);
image(wcodemat(xd,nbc));
title('ȫ����ֵ��ѹ��ͼ��');

plot(treed);
xlabel(['�����ɷ�',num2str(perfl2),'%','��ϵ���ɷ�',num2str(perf0),'%']);

%%
% С���ֽ�ѹ��

load wbarb;
%subplot(2,2,1);
image(X);
colormap(map);
title('ԭͼ');

[c,l]=wavedec2(X,2,'db3');
[thr,sorh,keepapp]=ddencmp('cmp','wv',X);
[Xcmp,cxc,lxc,perf0,perf12]=wdencmp('gbl',c,l,'db3',2,thr,sorh,keepapp);

%subplot(2,2,2);
image(Xcmp);
colormap(map);
title('С���ֽ�ѹ�����ͼƬ');

disp('С���ֽ�ϵ����Ϊ0��ϵ�������ٷֱȣ�');
perf0
disp('ѹ�����������ٷֱȣ�');
perf12

%zС�����ֽ�ѹ��
load wbarb;
%����ɫ��������
nbc = size(map,1);
%�õ��źŵ���ֵ������������С�����Ż���׼
[thr,sorh,keepapp,crit] = ddencmp('cmp','wp',X);
%ͨ�����ϵõ��Ĳ������źŽ���ѹ��
[xd,treed,perf0,perfl2] = wpdencmp(X,sorh,4,'sym4',crit,thr*2,keepapp);
%����������Ϊpink������
colormap(pink(nbc));


%subplot(2,2,3);
image(wcodemat(xd,nbc));
title('С����ѹ��ͼ��');

disp('С�����ֽ�ϵ����Ϊ0��ϵ�������ٷֱȣ�');
perf0
disp('ѹ�����������ٷֱȣ�');
perfl2

plot(treed);
xlabel(['�����ɷ�',num2str(perfl2),'%','��ϵ���ɷ�',num2str(perf0),'%']);
