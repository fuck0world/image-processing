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
%显示原始图像 
subplot(221);
imshow(X);
title('原始图像');
disp('原始图像大小');
whos('X');

%显示分频信息 
subplot(222); 
c1=uint8(c1); 
imshow(c1); 
title('显示分频信息');
subplot(223); 
disp('第一次压缩图像的大小'); 
%显示第一次压缩图像 
ca1=uint8(ca1); 
whos('ca1'); 
imshow(ca1); 
title('第一次压缩的图像'); 
disp('第二次压缩图像的大小'); 
subplot(224);

%显示第二次压缩图像的大小
ca2=uint8(ca2);
imshow(ca2);
title('第二次压缩的图像')
whos('ca2');
%imwrite(ca2,'G:\shexiang\Yshape1.bmp');

