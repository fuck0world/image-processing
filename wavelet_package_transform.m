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


