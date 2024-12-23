% 清除工作区变量、命令行窗口以及关闭所有图形窗口
clear;clc;close all;

% 打开图像文件
img = imread('E:\图片\qimo.jpg');

% 缩放变换（缩小为原来的0.5倍）
scaleFactor = 0.5;
scaledImg = imresize(img,scaleFactor);

% 旋转变换（顺时针旋转30度）
angle = 30;
rotatedImg = imrotate(img,angle);

% 显示结果
subplot(1,3,1);
imshow(img);
title('原始图像');
subplot(1,3,2);
imshow(scaledImg);
title('缩放变换后的图像');
subplot(1,3,3);
imshow(rotatedImg);
title('旋转变换后的图像');