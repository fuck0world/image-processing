clc; 
clear all; 
X1=imread('1.jpg'); 
X=hand_segmentation(X1); 

[c,s]=wavedec2(X,2,'bior3.7');
ca1=appcoef2(c,s,'bior3.7',1);
ch1=detcoef2('h',c,s,1);
cv1=detcoef2('v',c,s,1);
cd1=detcoef2('d',c,s,1);

a1=wrcoef2('a',c,s,'bior3.7',1); 
h1=wrcoef2('h',c,s,'bior3.7',1); 
v1=wrcoef2('v',c,s,'bior3.7',1); 
d1=wrcoef2('d',c,s,'bior3.7',1); 
c1=[a1,h1,v1,d1]; 
ca1=appcoef2(c,s,'bior3.7',1); 
ca1=wcodemat(ca1,400,'mat',0); 
ca1=0.5*ca1; 
ca2=appcoef2(c,s,'bior3.7',2); 
ca2=wcodemat(ca2,400,'mat',0); 
ca2=0.25*ca2; 
%��ʾԭʼͼ�� 
subplot(221);
imshow(X);
title('ԭʼͼ��');
disp('ԭʼͼ���С');
whos('X');

%��ʾ��Ƶ��Ϣ 
subplot(222); 
c1=uint8(c1); 
imshow(c1); 
title('��ʾ��Ƶ��Ϣ');
subplot(223); 
disp('��һ��ѹ��ͼ��Ĵ�С'); 
%��ʾ��һ��ѹ��ͼ�� 
ca1=uint8(ca1); 
whos('ca1'); 
imshow(ca1); 
title('��һ��ѹ����ͼ��'); 
disp('�ڶ���ѹ��ͼ��Ĵ�С'); 
subplot(224);

%��ʾ�ڶ���ѹ��ͼ��Ĵ�С
ca2=uint8(ca2);
imshow(ca2);
title('�ڶ���ѹ����ͼ��')
whos('ca2');
%imwrite(ca2,'G:\shexiang\Yshape1.bmp');

