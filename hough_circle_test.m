clc,clear all
I = imread('1.jpg');
[m,n,l] = size(I);
if l > 1
    I = rgb2gray(I);
end

BW = edge(I,'canny');
step_r = 1;
step_angle = 0.1;
minr = 20;
maxr = 30;
thresh = 0.7;

size_r = round((maxr - minr)/step_r) + 1;
size_angle = round(2*pi/step_angle);

hough_space = zeros(m,n,size_r);

[rows,cols] = find(BW);
ecount = size(rows);

%将图像空间(x,y)对应到参数空间（a,b,r）
%a = x - r*cos(angle)
%b = y - r*sin(angle)
for i = 1:ecount
    for r = 1:size_r
        for k = 1:size_angle
            a = round(rows(i) - (minr - (r-1)*step_r)*cos(k*step_angle));
            b = round(cols(i) - (minr - (r-1)*step_r)*sin(k*step_angle));
            if(a > 0 && a <= m && b > 0 && b <= n)
                hough_space(a,b,r) = hough_space(a,b,r) + 1;
            end
        end
    end
end

%搜索超过阈值地聚集点
max_para = max(max(max(hough_space)));
index = find(hough_space >= max_para*thresh);
length = size(index);
hough_circle = zeros(m,n);

for i = 1:ecount
    for k = 1:length
        par3 = floor(index(k)/(m*n)) + 1;
        par2 = floor(index(k) - (par3 - 1)*(m*n)/m) + 1;
        par1 = index(k) - (par3 - 1)*(m*n) - (par2 - 1)*m;
        if ((rows(i) - par1)^2 + (cols(i) - par2)^2 < (minr + (par3 - 1)*step_r)^2 + 5) && ((rows(i) - par1)^2 + (cols(i) - par2)^2 > (minr + (par3 - 1)*step_r)^2 - 5)
            hough_circle(rows(i),cols(i)) = 1;
        end
    end
end

for k = 1:length
    par3 = floor(index(k)/(m*n)) + 1;
    par2 = floor(index(k) - (par3 - 1)*(m*n)/m) + 1;
    par1 = index(k) - (par3 - 1)*(m*n) - (par2 - 1)*m;
    par3 = minr + (par3 - 1)*step_r;
    fprintf(1,'Center %d %d radius %d\n',par1,par2,par3);
    para(:,k) = [par1,par2,par3]'
end

figure(1);
subplot(2,2,1);
imshow(I);
title('原图');

subplot(2,2,2);
imshow(BW);
title('边缘算子处理后');

subplot(2,2,3);
imshow(hough_circle);

subplot(2,2,4);
imshow(para);






        
        
        
        