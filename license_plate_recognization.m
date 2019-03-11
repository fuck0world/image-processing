clc;
clear all;
%% 1 ��ȡ��Ƭ��Ԥ����
I = imread('raw4.jpg');
figure(1);
subplot(3,3,1);
imshow(I);

Im1 = rgb2gray(I);
subplot(3,3,2);
imshow(Im1);
title('�Ҷ�ͼ');

subplot(3,3,3);
imhist(Im1);
title('�Ҷ�ͼ��ֱ��ͼ');
%% 2 ��ǿ�Ҷ�ͼ
T = imadjust(Im1,[0.19,0.78],[0,1]);

subplot(3,3,4);
imshow(T);
title('��ǿ��ĻҶ�ͼ');

subplot(3,3,5);
imhist(T);
title('��ǿ���ֱ��ͼ');
%% 3 ��Ե���
Im2 = edge(Im1,'sobel',0.1,'both');

subplot(3,3,6);
imshow(Im2);
title('sobel����ʵ�ֱ�Ե���');
%% 4 �Ҷ�ͼ��ʴ����ʴ
se = [1;1;1];
Im3 = imerode(Im2,se);

subplot(3,3,7);
imshow(Im3);
title('��ʴЧ��ͼ');
se = strel('rectangle',[25,25]);

figure(1);
Im4 = imclose(Im3,se);
figure(1);
subplot(3,3,8);
imshow(Im4);
title('ƽ��Ч��ͼ');
%% 5 �Ƴ�С����
Im5 = bwareaopen(Im4,2000);
figure(1);
subplot(3,3,9);
imshow(Im5);
title('�Ƴ�С����');
%% 6 ����ָ�
[y,x,z] = size(Im5);
Im6 = double(Im5);
Blue_y = zeros(y,1);
for i = 1:y
    for j = 1:x
        if (Im6(i,j,1) == 1)
            Blue_y(i,1) = Blue_y(i,1) + 1; % ͳ����ɫ���ص�
        end
    end
end

%��������ȷ��
%%%%%% Y���� %%%%%%%%% 
[temp MaxY] = max(Blue_y);
PY1 = MaxY;
while((Blue_y(PY1,1) >= 5)&&(PY1 > 1))
    PY1 = PY1 - 1;
end
PY2 = MaxY;
while((Blue_y(PY2,1) >= 5)&&(PY2 < y))
    PY2 = PY2 + 1;
end

%%%%%% X���� %%%%%%%%% 
IY = I(PY1:PY2,:,:);
Blue_x = zeros(1,x);
for j = 1:x
    for i = PY1:PY2
        if (Im6(i,j,1) == 1)
            Blue_x(1,j) = Blue_x(1,j) + 1;
        end
    end
end

PX1 = 1;
while((Blue_x(1,PX1) < 3)&&(PX1 < x))
    PX1 =  PX1 + 1;
end

PX2 = x;
while((Blue_x(1,PX2) < 3)&&(PX2 > PX1))
    PX2 =  PX2 - 1;
end

%�����������
PX1 = PX1 - 1;
PX2 = PX2 + 1;
dw = I(PY1:PY2,PX1:PX2,:);

figure(2);
subplot(3,3,1);
imshow(IY);
title('��ֱ�����������');
subplot(3,3,2);
imshow(dw);
title('��λ���к�Ĳ�ɫ����ͼ��');

imwrite(dw,'dw.jpg');
% ͼ���ֵ��
a = imread('dw.jpg');
b = rgb2gray(a);


subplot(3,3,3);
imshow(a);
title('ԭͼ');

subplot(3,3,4);
imshow(b);
title('rgb2gray���');

g_max = double(max(max(b)));
g_min = double(min(min(b)));

%������ֵ��������Ҫ����Ϣ������������Ϣ
T = round(g_max - (g_max - g_min) / 2);
[m,n] = size(b);
d = (double(b) >= T);

subplot(3,3,5);
imshow(d);
title('���ƵĶ�ֵͼ��');


subplot(3,3,6);
imshow(d);
title('��ֵ�˲�֮ǰ��ͼ��');

h = fspecial('average',3);
d = im2bw(round(filter2(h,d)));

subplot(3,3,7);
imshow(d);
title('��ֵ�˲�֮���ͼ��');

se = eye(2);
[m,n] = size(d);
if bwarea(d)/m/n >= 0.365
    d = imerode(d,se);
elseif bwarea(d)/m/n <= 0.235
    d = imdilate(d,se);
end

subplot(3,3,8);
imshow(d);
title('���ͻ�ʴ֮���ͼ��')

%% 7 �ַ��ָ����һ��
% Ѱ�����������ֵĿ飬�����ȴ���ĳ��ֵ������Ϊ�ÿ��������ַ���ɣ���Ҫ�ָ� 
d = qiege(d); 
[m,n] = size(d); 

subplot(3,3,9);
imshow(d);
title(n);

k1 = 1;
k2 = 1;
s = sum(d);
j = 1; 
while j ~= n 
    while s(j) == 0 
        j = j+1; 
    end
    k1 = j; 
    while s(j) ~= 0 && j <= n-1 
        j = j+1; 
    end
    k2 = j-1; 
    if k2-k1 >= round(n / 6.5) 
        [val,num] = min(sum(d(:,[k1 + 5:k2 - 5]))); 
        d(:,k1 + num + 5) = 0; % �ָ� 
    end
end

% ���и�

d = qiege(d); % �и�� 7 ���ַ� 
y1 = 10;
y2 = 0.25;
flag = 0;
word1 = []; 
while flag == 0 
    [m,n] = size(d); 
    left = 1;
    wide = 0; 
    while sum(d(:,wide+1)) ~= 0 
        wide = wide + 1; 
    end
    if wide < y1 % ��Ϊ�������� 
        d(:,[1:wide]) = 0; 
        d = qiege(d); 
    else
        temp = qiege(imcrop(d,[1 1 wide m])); 
        [m,n] = size(temp); 
        all = sum(sum(temp)); 
        two_thirds = sum(sum(temp([round(m/3):2*round(m/3)],:))); 
        if two_thirds / all > y2 
            flag = 1;
            word1 = temp; % WORD 1 
        end
        d(:,[1:wide]) = 0;
        d = qiege(d); 
    end
end


% �ָ���ڶ����ַ�
[word2,d]=getword(d); 
% �ָ���������ַ� 
[word3,d]=getword(d);
% �ָ�����ĸ��ַ� 
[word4,d]=getword(d); 
% �ָ��������ַ� 
[word5,d]=getword(d); 
% �ָ���������ַ� 
[word6,d]=getword(d); 
% �ָ�����߸��ַ� 
[word7,d]=getword(d); 

figure(3);
subplot(3,7,1);
imshow(word1);
title('��1���ַ�'); 

subplot(3,7,2);
imshow(word2);
title('��2���ַ�'); 

subplot(3,7,3);
imshow(word3);
title('��3���ַ�'); 

subplot(3,7,4);
imshow(word4);
title('��4���ַ�'); 

subplot(3,7,5);
imshow(word5);
title('��5���ַ�'); 

subplot(3,7,6);
imshow(word6);
title('��6���ַ�');

subplot(3,7,7);
imshow(word7);
title('��7���ַ�'); 

% ��һ����СΪ 40*20 
[m,n]=size(word1); 
word1=imresize(word1,[40 20]); 
word2=imresize(word2,[40 20]); 
word3=imresize(word3,[40 20]); 
word4=imresize(word4,[40 20]); 
word5=imresize(word5,[40 20]);
word6=imresize(word6,[40 20]); 
word7=imresize(word7,[40 20]); 

subplot(3,7,8);
imshow(word1);
title('��һ����ĵ�1���ַ�'); 

subplot(3,7,9);
imshow(word2);
title('��һ����ĵ�2���ַ�'); 

subplot(3,7,10);
imshow(word3);
title('��һ����ĵ�3���ַ�'); 

subplot(3,7,11);
imshow(word4);
title('��һ����ĵ�4���ַ�'); 

subplot(3,7,12);
imshow(word5);
title('��һ����ĵ�5���ַ�'); 

subplot(3,7,13);
imshow(word6);
title('��һ����ĵ�6���ַ�'); 

subplot(3,7,14);
imshow(word7);
title('��һ����ĵ�7���ַ�'); 

%% 8 ϸ��
Xi1 = bwmorph(word1,'thin',5);
Xi2 = bwmorph(word2,'thin',5);
Xi3 = bwmorph(word3,'thin',5);
Xi4 = bwmorph(word4,'thin',5);
Xi5 = bwmorph(word5,'thin',5);
Xi6 = bwmorph(word6,'thin',5);
Xi7 = bwmorph(word7,'thin',5);

subplot(3,7,15);
imshow(Xi1);
title('ϸ����ĵ�1���ַ�');

subplot(3,7,16);
imshow(Xi2);
title('ϸ����ĵ�2���ַ�');

subplot(3,7,17);
imshow(Xi3);
title('ϸ����ĵ�3���ַ�');

subplot(3,7,18);
imshow(Xi4);
title('ϸ����ĵ�4���ַ�');

subplot(3,7,19);
imshow(Xi5);
title('ϸ����ĵ�5���ַ�');

subplot(3,7,20);
imshow(Xi6);
title('ϸ����ĵ�6���ַ�');

subplot(3,7,21);
imshow(Xi7);
title('ϸ����ĵ�7���ַ�');

imwrite(word1,'1.jpg'); 
imwrite(word2,'2.jpg'); 
imwrite(word3,'3.jpg'); 
imwrite(word4,'4.jpg'); 
imwrite(word5,'5.jpg'); 
imwrite(word6,'6.jpg'); 
imwrite(word7,'7.jpg'); 
%% 9 �ַ���ʶ��
liccode = char(['0':'9' 'A':'Z' '���������¼�']); 
%�����Զ�ʶ���ַ������ 1~10 ���� 11~36 ��ĸ 37~41���� 
SubBw2 = zeros(40,20);%����һ��40*20��С������� 
l = 1; 

for I = 1:7  
    ii = int2str(I);%��������ת�ַ�������
    t = imread([ii,'.jpg']); 
    SegBw2=imresize(t,[40 20],'nearest');%���Ŵ��� 
    %��һλ����ʶ��
    if l==1  
        kmin=37; 
        kmax=41; 
    elseif l==2 %�ڶ�λ A~Z ��ĸʶ�� 
        kmin=11; 
        kmax=36; 
    else l>=3 %����λ�Ժ�����ĸ������ʶ�� 
        kmin=1; 
        kmax=36; 
    end
    for k2=kmin:kmax 
        fname=strcat('������\',liccode(k2),'.bmp');
          SamBw2 = imread(fname);
            for  i = 1:40
                for j = 1:20
                    SubBw2(i,j) = SegBw2(i,j) - SamBw2(i,j);
                end
            end
           % �����൱������ͼ����õ�������ͼ
            Dmax = 0;
            for k1 = 1:40
                for l1 = 1:20
                    if  ( SubBw2(k1,l1) > 0 || SubBw2(k1,l1) <0 )
                        Dmax=Dmax+1;
                    end
                end
            end
            Error(k2) = Dmax;
        end
        Error1 = Error(kmin:kmax);
        MinError = min(Error1);
        findc = find(Error1 == MinError);
        Code(l*2-1) = liccode(findc(1) + kmin-1);
        Code(l*2)=' ';
        l = l + 1;
end
figure(4),imshow(dw),title (['���ƺ���:', Code],'Color','b');


function e=qiege(d) 
    [m,n]=size(d); 
    top=1;bottom=m;
    left=1;
    right=n; % init 
    while sum(d(top,:))==0 && top<=m 
        top=top+1; 
    end
    while sum(d(bottom,:))==0 && bottom>=1 
        bottom=bottom-1; 
    end
    while sum(d(:,left))==0 && left<=n 
        left=left+1; 
    end
    while sum(d(:,right))==0 && right>=1 
        right=right-1; 
    end
    dd=right-left; 
    hh=bottom-top; 
    e=imcrop(d,[left top dd hh]);%�ú������ڷ���ͼ���һ���ü�����
end

function [word,result]=getword(d)
    word=[];
    flag=0;
    y1=8;
    y2=0.5; 
    while flag==0 
        [m,n]=size(d); 
        wide=0; 
        while sum(d(:,wide+1))~=0 && wide<=n-2 
            wide=wide+1; 
        end
        temp=qiege(imcrop(d,[1 1 wide m])); 
        [m1,n1]=size(temp); 
        if wide<y1 && n1/m1>y2 
            d(:,[1:wide])=0; 
            if sum(sum(d))~=0 
                d=qiege(d); % �и����С��Χ 
            else
                word=[];
                flag=1; 
            end
        else
            word=qiege(imcrop(d,[1 1 wide m])); 
            d(:,[1:wide])=0; 
            if sum(sum(d))~=0; 
                d=qiege(d);
                flag=1; 
            else
                d=[]; 
            end
        end
    end 
    result=d;
end









