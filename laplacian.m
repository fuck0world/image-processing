
sourcePic = imread('1.jpg');
grayPic = mat2gray(sourcePic(:,:,1));

[m,n] = size(grayPic);
newGrayPic = grayPic;

LaplacianNum = 0;
LaplacianThreshold = 0.1;

for j = 2:m-1
    for k = 2:n-1
        LaplacianNum = abs(4*grayPic(j,k)-grayPic(j-1,k)-grayPic(j+1,k)-grayPic(j,k-1)-grayPic(j,k+1));
        if (LaplacianNum > LaplacianThreshold)
            newGrayPic(j,k) = 255;
        else
            newGrayPic(j,k) = 0;
        end
    end
end
figure,imshow(newGrayPic);