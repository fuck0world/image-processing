clc 
clear all;

I = imread('3.jpg');
I = rgb2gray(I);
figure(1);
subplot(1,2,1);
imshow(I);

[M,N] = size(I);
[y,x] = getpts;

x1 = round(x);
y1 = round(y);
seed = I(x1,y1);
J = zeros(M,N);
J(x1,y1) = 1;
sum = seed;
suit = 1;
count = 1;
threshold = 0.15;

while count > 0
    s = 0;
    count = 0;
    for i = 1:M
        for j = 1:N
            if J(i,j) == 1
                %判断是否为边界点
                if (i+1)>0 && (i+1)<(M+1) && (j-1)>0 && (j+1)<(N+1)
                    %判断周围8个点是否符合阈值条件
                    for u = -1:1
                        for v = -1:1
                            %判断点是否被标记且符合阈值条件
                            if J(i+u,j+v) == 0 && abs(I(i+u,j+v)-seed)<=threshold && 1/(1+1/15*abs(I(i+u,j+v)-seed))>0.8
                                J(i+u,j+v) = 1;
                                count = count + 1;
                                s = s + I(i + u,j + v);
                            end
                        end
                    end
                end
            end
        end
    end
    suit = suit + count;
    sum = sum + s;
    seed = sum/suit;
end

subplot(1,2,2);
imshow(J);
                    



























































