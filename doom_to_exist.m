clear all;
clc;
I_rgb=imread('1.jpg');

figure(1);
imshow(I_rgb);
title('原始图像');

%去噪
filter=ones(5,5);
filter=filter/sum(filter(:));
denoised_r=conv2(I_rgb(:,:,1),filter,'same');
denoised_g=conv2(I_rgb(:,:,2),filter,'same');
denoised_b=conv2(I_rgb(:,:,3),filter,'same');
denoised_rgb=cat(3, denoised_r, denoised_g, denoised_b);
D_rgb=uint8(denoised_rgb);
figure();imshow(D_rgb);title('去噪后图像');%去噪后的结果
%将彩色图像从RGB转化到lab彩色空间
C =makecform('srgb2lab'); %设置转换格式
I_lab= applycform(D_rgb, C);
%进行K-mean聚类将图像分割成2个区域
ab =double(I_lab(:,:,2:3)); %取出lab空间的a分量和b分量
nrows= size(ab,1);
ncols= size(ab,2);
ab =reshape(ab,nrows*ncols,2);
nColors= 4; %分割的区域个数为4
[cluster_idx,cluster_center] =kmeans(ab,nColors,'distance','sqEuclidean','Replicates',2); %重复聚类2次
pixel_labels= reshape(cluster_idx,nrows,ncols);
%显示分割后的各个区域
segmented_images= cell(1,4);
rgb_label= repmat(pixel_labels,[1 1 3]);
for k= 1:nColors
color = I_rgb;
color(rgb_label ~= k) = 0;
segmented_images{k} = color;
end

figure(2);
subplot(2,2,1);
imshow(segmented_images{1});
title('分割结果——区域1');

figure(2);
subplot(2,2,2);
imshow(segmented_images{2});
title('分割结果——区域2');

figure(2);
subplot(2,2,3);
imshow(segmented_images{3});
title('分割结果——区域3');

figure(2);
subplot(2,2,4);
imshow(segmented_images{4});
title('分割结果——区域4');
%使分割后的图像在一个图中显示
m=uint8(rgb_label);
for i=1:69  
     for j=1:97       
          if m(i,j,1)==1          
             m(i,j,1)=255;        
             m(i,j,2)=0;          
             m(i,j,3)=0;    
          end 
          if m(i,j,1)==2   
             m(i,j,1)=256;
             m(i,j,2)=256;
             m(i,j,3)=0;
         end
         if m(i,j,1)==3   
            m(i,j,1)=0;   
            m(i,j,2)=0;
            m(i,j,3)=255;  
         end
       if m(i,j,1)==4       
          m(i,j,1)=0;  
          m(i,j,2)=128;
          m(i,j,3)=0;
       end
 end
end
figure(3),imshow(m)