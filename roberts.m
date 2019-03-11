clear all;
clc
sourcePic = imread('1.jpg');
grayPic = mat2gray(sourcePic(:,:,1));

[m,n] = size(grayPic);
newGrayPic = grayPic;

robertsNum = 0;
robertsThreshold = 0.2;

for j = 1:m-1
    for k = 1:n-1
        robertsNum = abs(grayPic(j,k) - grayPic(j+1,k+1)) + abs(grayPic(j+1,k) - grayPic(j,k+1));
        if (robertsNum > robertsThreshold)
            newGrayPic(j,k) = 255;
        else
            newGrayPic(j,k) = 0;
        end
    end
end
figure,imshow(newGrayPic);