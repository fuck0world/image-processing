clear all;
clc;

I = imread('1.jpg');

R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

R_BITS = 2;
G_BITS = 2;
B_BITS = 2;

size_color = 2^R_BITS*2^G_BITS*2^B_BITS;
d = 7;

os = offset(d);
s = size(os);




for i = 1:s(1)
    offset1 = os(i,:)
    glm = 