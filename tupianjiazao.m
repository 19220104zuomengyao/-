% 清除工作区变量、命令行窗口以及关闭所有图形窗口
clear;clc;close all;

% 打开图像文件
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp'},'选择图像文件');
if isequal(filename,0) || isequal(pathname,0)
    return;
end
img = imread(fullfile(pathname,filename));

% 加噪选择
noiseType = input('请输入噪声类型（如''gaussian''表示高斯噪声）：','s');
if strcmp(noiseType,'gaussian')
    meanVal = 0; % 均值
    varVal = 0.01; % 方差
    noisyImg = imnoise(img,'gaussian',meanVal,varVal);