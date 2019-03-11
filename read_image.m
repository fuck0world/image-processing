%% 线性变换
A = imread('1.jpg');
figure(1);
subplot(2,2,1);
imshow(A);
subplot(2,2,2);
imhist(A);
J1 = imadjust(A, [0.3,0.7], []);
subplot(2,2,3);
imshow(J1);
subplot(2,2,4);
imhist(J1);

%% 灰度对数变换
J = double(A);

J = 40 * (log(J+1));
H = uint8(J);
figure(2);
subplot(2,1,1);
imshow(I);
subplot(2,1,2);
imshow(H);

%% 直方图均衡化
K = histeq(A);
figure(3);
subplot(2,2,1);
imshow(A);
subplot(2,2,2);
imshow(K)
subplot(2,2,3);
imhist(K,64);
subplot(2,2,4);
imhist(A,64);

%% 几何变换

% 1 平移
img1 = imread('1.jpg');
figure,imshow(img1);
imwrite(img1, '平移1.jpg');
se = translate(strel(1),[10,0]);
img2 = imdilate(img1,se);
figure,imshow(img2);
imwrite(img2, '平移2.jpg');

% 2 旋转
img1 = imread('1.jpg');
figure(3);
subplot(2,2,1);
imshow(img1);
subplot(2,2,2);
img3 = imrotate(img1,45);
imshow(img3);
subplot(2,2,3);
img4 = imrotate(img1,90);
imshow(img4);
subplot(2,2,4);
img5 = imrotate(img1,135);
imshow(img5);

% 3 比例缩放
img1 = imread('1.jpg');
figure(4);
subplot(2,2,1);
imshow(img1);
subplot(2,2,2);
img2 = imresize(img1,2);
imshow(img2);
subplot(2,2,3);
img3 = imresize(img1,0.5);
imshow(img3);

% 4 镜像
init = imread('1.jpg');
figure(5);
subplot(1,2,1);
imshow(init);
[R,C] = size(init);
res = zeros(R,C);
for i = 1:R
    for j = 1:C
        x = i;
        y = C - j + 1;
        res(x,y) = init(i,j);
    end
end
subplot(1,2,2);
imshow(uint8(res));
imwrite(uint8(res),'镜像2.jpg');

% 5 均值滤波
I = imread('1.jpg');
J = imnoise(I,'salt & pepper',0.02);
figure(6);
subplot(3,3,1);
imshow(I(:,:,1));
subplot(3,3,2);
imshow(I(:,:,2));
subplot(3,3,3);
imshow(I(:,:,3));

subplot(3,3,4);
imshow(J);
k1 = medfilt2(J(:,:,1));
k2 = medfilt2(J(:,:,1),[5,5]);
k3 = medfilt2(J(:,:,1),[7,7]);
k4 = medfilt2(J(:,:,1),[9,9]);
figure(6);
subplot(3,3,5);
imshow(k1);
subplot(3,3,6);
imshow(k2);
subplot(3,3,7);
imshow(k3);
subplot(3,3,8);
imshow(k4);

% 6 中值滤波
I = imread('1.jpg');
J = imnoise(I(:,:,1),'salt & pepper',0.02);
figure(7);
subplot(1,2,1);
imshow(I(:,:,1));
figure(7);
subplot(1,2,2);
imshow(J);

%% 膨胀、腐蚀和开运算、闭运算和细化
% 1 腐蚀
I = imread('1.jpg');
figure(8);
subplot(2,4,1);
imshow(I(:,:,1));

se1 = strel('disk',1);
se2 = strel('disk',2);
se3 = strel('disk',3);

I2 = imerode(I,se1);
I3 = imerode(I,se2);
I4 = imerode(I,se3);

figure(8);
subplot(2,4,2);
imshow(I2);

figure(8);
subplot(2,4,3);
imshow(I3);

figure(8);
subplot(2,4,4);
imshow(I4);

%  2 膨胀
I = imread('1.jpg');
figure(8);
subplot(2,4,5);
imshow(I(:,:,1));

se1 = strel('disk',1);
se2 = strel('disk',2);
se3 = strel('disk',3);

I2 = imdilate(I,se1);
I3 = imdilate(I,se2);
I4 = imdilate(I,se3);

figure(8);
subplot(2,4,6);
imshow(I2);

figure(8);
subplot(2,4,7);
imshow(I3);

figure(8);
subplot(2,4,8);
imshow(I4);

% 3 开、闭运算
I = imread('1.jpg');
se = strel('disk',1);
I1 = imopen(I,se);
I2 = imclose(I,se);

figure(9);
subplot(1,2,1);
imshow(I1);

figure(9);
subplot(1,2,2);
imshow(I2);

% 细化
I = imread('1.jpg');
I1 = bwmorph(I(:,:,1),'remove');
I2 = bwmorph(I(:,:,1),'skel',Inf);
I3 = bwmorph(I(:,:,1),'thin',Inf);

figure(10);
subplot(2,2,1);
imshow(I(:,:,1));

figure(10);
subplot(2,2,2);
imshow(I1);

figure(10);
subplot(2,2,3);
imshow(I2);

figure(10);
subplot(2,2,4);
imshow(I3);

% 填充
img = imread('1.jpg');
img = img(:,:,1) > 128;
img = mat2gray(img);
figure(11);
subplot(2,1,1);
imshow(img);

[m n] = size(img);
[x y] = ginput();
x = round(x);
y = round(y);

temp = ones(m,n);
queue_head = 1;
queue_tail = 1;
neighbour = [-1 -1;-1 0;-1 1;0 -1;1 -1;1 0;1 1];

q{queue_tail} = [y x];
queue_tail = queue_tail + 1;
[ser1 ser2] = size(neighbour);

while queue_head ~= queue_tail
    pix = q{queue_head};
    for i = 1:ser1
        pix1 = pix +neighbour(i,:);
        if pix1(1) >=1 && pix1(2) >= 1 && pix1(1) <= m && pix1(2) <= n
            if img(pix1(1),pix(2)) == 1
                img(pix1(1),pix1(2)) = 0;
                q{queue_tail} = [pix1(1) pix1(2)];
                queue_tail = queue_tail + 1;
            end
        end
    end
    queue_head = queue_head + 1;
end
figure(11);
subplot(2,1,2);
imshow(mat2gray(img));










