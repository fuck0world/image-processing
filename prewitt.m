
sourcePic = imread('1.jpg');
grayPic = mat2gray(sourcePic(:,:,1));

[m,n] =  size(grayPic);
newGrayPic = grayPic;
PrewittNum = 0;
PrewittThrshold = 0.8;
 
 for j = 2:m-1
     for k = 2:n-1
         PrewittNum = abs(grayPic(j-1,k+1)-grayPic(j+1,k+1)+grayPic(j-1,k)-grayPic(j+1,k)+grayPic(j-1,k-1)-grayPic(j+1,k-1))+abs(grayPic(j-1,k+1)-grayPic(j,k+1)+grayPic(j+1,k+1)-grayPic(j-1,k-1)+grayPic(j,k-1)-grayPic(j+1,k-1));
         if (PrewittNum > PrewittThrshold)
             newGrayPic(j,k) = 255;
         else
             newGrayPic(j,k) = 0;
         end
     end
 end
 figure;
 imshow(newGrayPic);
         