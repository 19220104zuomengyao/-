% 清除工作区变量、命令行窗口以及关闭所有图形窗口
clear;clc;close all;

% 打开图像文件
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp'},'选择图像文件');
if isequal(filename,0) || isequal(pathname,0)
    return;
end
img = imread(fullfile(pathname,filename));

% 获取原始图像的尺寸并输出
[originalHeight, originalWidth, originalChannels] = size(img);
disp(['原始图像尺寸：高度为 ', num2str(originalHeight),'像素，宽度为 ', num2str(originalWidth),'像素，通道数为 ', num2str(originalChannels)]);

% 缩放变换（缩小为原来的长宽各0.5倍）
newWidth = floor(originalWidth * 0.5);
newHeight = floor(originalHeight * 0.5);
scaledImg = imresize(img, [newHeight, newWidth]);

% 获取缩放后图像的尺寸并输出
[scaledHeight, scaledWidth, scaledChannels] = size(scaledImg);
disp(['缩放后图像尺寸：高度为 ', num2str(scaledHeight),'像素，宽度为 ', num2str(scaledWidth),'像素，通道数为 ', num2str(scaledChannels)]);

% 旋转变换（顺时针旋转30度）
angle = 30;
rotatedImg = imrotate(img, angle);

% 显示结果
subplot(1, 3, 1);
imshow(img);
title('原始图像');
subplot(1, 3, 2);
imshow(scaledImg);
title('缩放变换后的图像');
subplot(1, 3, 3);
imshow(rotatedImg);
title('旋转变换后的图像');