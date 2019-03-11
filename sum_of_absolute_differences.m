%% ¾ø¶ÔÎó²îºÍËã·¨
clear all;
clc;

src = imread('1.jpg');
[a b d] = size(src);
if d == 3
    src = rgb2gray(src);
end

mask = imread('2.jpg');
[m n d] = size(mask);
if d == 3
    src = rgb2gray(src);
end

%%
N = n;
M = a;
dst = zeros(M - N,M - N);
