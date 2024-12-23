% 清除工作区变量、命令行窗口以及关闭所有图形窗口
clear;clc;close all;

% 打开图像文件
img = imread('E:\图片\qimo.jpg');

% 转为灰度图
if size(img, 3) == 3
    grayImg = rgb2gray(img);
else
    grayImg = img;
end

% Robert算子
robertX = [-1 0; 0 1];
robertY = [0 -1; 1 0];
robertEdgeX = imfilter(grayImg, robertX, 'replicate');
robertEdgeY = imfilter(grayImg, robertY, 'replicate');
robertEdgeX = double(robertEdgeX);
robertEdgeY = double(robertEdgeY);
robertEdge = sqrt(robertEdgeX.^2 + robertEdgeY.^2);
robertEdge = uint8(mat2gray(robertEdge) * 255);

% Prewitt算子
prewittX = [-1 -1 -1; 0 0 0; 1 1 1];
prewittY = [-1 0 1; -1 0 1; -1 0 1];
prewittEdgeX = imfilter(grayImg, prewittX, 'replicate');
prewittEdgeY = imfilter(grayImg, prewittY, 'replicate');
prewittEdgeX = double(prewittEdgeX);
prewittEdgeY = double(prewittEdgeY);
prewittEdge = sqrt(prewittEdgeX.^2 + prewittEdgeY.^2);
prewittEdge = uint8(mat2gray(prewittEdge) * 255);

% Sobel算子
sobelX = [-1 -2 -1; 0 0 0; 1 2 1];
sobelY = [-1 0 1; -2 0 2; -1 0 1];
sobelEdgeX = imfilter(grayImg, sobelX, 'replicate');
sobelEdgeY = imfilter(grayImg, sobelY, 'replicate');
sobelEdgeX = double(sobelEdgeX);
sobelEdgeY = double(sobelEdgeY);
sobelEdge = sqrt(sobelEdgeX.^2 + sobelEdgeY.^2);
sobelEdge = uint8(mat2gray(sobelEdge) * 255);

% 拉普拉斯算子
laplacianKernel = [0 -1 0; -1 4 -1; 0 -1 0];
laplacianEdge = imfilter(grayImg, laplacianKernel, 'replicate');
laplacianEdge = double(laplacianEdge);
laplacianEdge = sqrt(laplacianEdge);
laplacianEdge = uint8(mat2gray(laplacianEdge) * 255);

% 显示结果
subplot(2, 2, 1);
imshow(robertEdge);
title('Robert算子边缘提取');
subplot(2, 2, 2);
imshow(prewittEdge);
title('Prewitt算子边缘提取');
subplot(2, 2, 3);
imshow(sobelEdge);
title('Sobel算子边缘提取');
subplot(2, 2, 4);
imshow(laplacianEdge);
title('拉普拉斯算子边缘提取');