clc;
clear all;

img=imread('3.jpg');

imshow(img);
img=mat2gray(img);

imgn=split(img);
figure;
imshow(imgn)

function img=split(img)   
    [m n]=size(img);
    if m==1 && n==1    %�ֽ⵽ֻʣһ�������򷵻�
       return 
    end   
      
    out=0;      %�������Ƿ������غͱ�����ƽ�����ز�����û��Ϊ0����Ϊ1
    me=mean(img(:));
    for i=1:m
        for j=1:n
            %����׼�򣬰�����Լ����塣
            %����׼��ܼ򵥣�����ǰ���غͱ�����ƽ�����ز��ϴ����������
            if abs(img(i,j)-me)>0.2
                out=1;
                break;
            end
        end
    end
    
    if out==0       %�������������������ƽ�����ز�಻������������������ƽ��ֵ��Ҳ�ǰ�����Լ����塣
        img(:,:)=me;
        return 
    else           
        if n==1             %���ֻʣһ��
            img(1:m/2,1)=split(img(1:m/2,1));       %���ϰ벿�ֵݹ����
            img(m/2+1:m,1)=split(img(m/2+1:m,1));     %���°벿�ֵݹ����
        elseif m==1         %���ֻʣһ��
            img(1,1:n/2)=split(img(1,1:n/2));       %����벿�ֵݹ����
            img(1,n/2+1:n)=split(img(1,n/2+1:n));   %���Ұ벿�ֵݹ����
        else
            img(1:m/2,1:n/2)=split(img(1:m/2,1:n/2));           %ͼ�����ϵݹ����
            img(m/2+1:m,1:n/2)=split(img(m/2+1:m,1:n/2));       %ͼ�����µݹ����
            img(1:m/2,n/2+1:n)=split(img(1:m/2,n/2+1:n));       %ͼ�����ϵݹ����
            img(m/2+1:m,n/2+1:n)=split(img(m/2+1:m,n/2+1:n));   %ͼ�����µݹ����           
        end                
    end
end

