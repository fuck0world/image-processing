clc
clear all
sourcePic = imread('1.jpg');
grayPic = mat2gray(sourcePic(:,:,2));

[m,n] = size(grayPic);
newGrayPic = grayPic;

sibelNum = 0;
sobelThreshold = 0.2;

for j = 2:m-1
    for k = 2:n-1
        sobelNum = abs(grayPic(j-1,k+1)+2*grayPic(j,k+1)+grayPic(j+1,k+1)-grayPic(j-1,k-1)-2*grayPic(j,k-1)-grayPic(j+1,k-1))+abs(grayPic(j-1,k-1)+2*grayPic(j-1,k)+grayPic(j-1,k+1)-grayPic(j+1,k-1)-2*grayPic(j+1,k)-grayPic(j+1,k+1));
        if (sobelNum > sobelThreshold)
            newGrayPic(j,k) = 255;
        else
            newGrayPic(j,k) = 0;
        end
    end
end
figure,imshow(newGrayPic);