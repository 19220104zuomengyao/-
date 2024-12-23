% 清除工作区变量、命令行窗口以及关闭所有图形窗口
clear;clc;close all;

% 打开图像文件
img = imread('E:\图片\qimo.jpg');

% 灰度化
if size(img,3) == 3
    grayImg = rgb2gray(img);
else
    grayImg = img;
end

% 线性变换增强对比度
a = 2; % 线性变换系数
b = 50; % 线性变换偏移量
linearEnhancedImg = imadjust(grayImg,[], [], a);

% 对数变换增强对比度
c = 1; % 对数变换系数
logEnhancedImg = c * log(1 + double(grayImg));
logEnhancedImg = uint8(mat2gray(logEnhancedImg) * 255);

% 指数变换增强对比度
d = 1.05; % 指数变换底数
expEnhancedImg = d.^ double(grayImg);
expEnhancedImg = uint8(mat2gray(expEnhancedImg) * 255);

% 显示结果
subplot(2,2,1);
imshow(grayImg);
title('原始灰度图像');
subplot(2,2,2);
imshow(linearEnhancedImg);
title('线性变换增强对比度后的图像');
subplot(2,2,3);
imshow(logEnhancedImg);
title('对数变换增强对比度后的图像');
subplot(2,2,4);
imshow(expEnhancedImg);
title('指数变换增强对比度后的图像');