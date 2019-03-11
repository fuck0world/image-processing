clc 
clear all
a1 = imread('1.jpg');
a2 = im2double(a1);
b = rgb2gray(a2); 

[thr,sorh,keepapp] = ddencmp('den','wv',b);
c = wdencmp('gbl',b,'sym4',2,thr,sorh,keepapp);

d = medfilt2(c,[7,7]);
isuo = imresize(d,0.25,'bicubic');

es = edge(isuo,'sobel');
er = edge(isuo,'roberts');
ep = edge(isuo,'prewitt');
el = edge(isuo,'log');
ec = edge(isuo,'canny');

figure()
subplot(2,3,1);
imshow(b);

subplot(2,3,2);
imshow(es);

subplot(2,3,3);
imshow(er);

subplot(2,3,4);
imshow(ep);

subplot(2,3,5);
imshow(el);

subplot(2,3,6);
imshow(ec);