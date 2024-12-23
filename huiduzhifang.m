% 清除工作区变量、命令行窗口以及关闭所有图形窗口
clear;clc;close all;

% 打开图像文件
img = imread('E:\图片\qimo.jpg');

% 转为灰度图（如果是彩色图）
if size(img,3) == 3
    grayImg = rgb2gray(img);
else
    grayImg = img;
end

% 显示灰度直方图
subplot(2,2,1);
imhist(grayImg);
title('原始灰度直方图');

% 直方图均衡化
equImg = histeq(grayImg);
subplot(2,2,2);
imhist(equImg);
title('直方图均衡化后的直方图');

% 直方图匹配（这里简单示例，以标准均匀分布直方图作为参考进行匹配）
refImg = rand(size(grayImg));
[matchedImg,~] = histeq(grayImg,imhist(refImg));
subplot(2,2,3);
imhist(matchedImg);
title('直方图匹配后的直方图');

% 显示均衡化和匹配后的图像（这里简单并排展示）
subplot(2,2,4);
imshow([equImg,matchedImg]);
title('直方图均衡化（左）与匹配（右）后的图像');