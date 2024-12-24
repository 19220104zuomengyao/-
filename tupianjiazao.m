% 清除工作区变量、命令行窗口以及关闭所有图形窗口
clear;clc;close all;

% 图像读取
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp'},'选择图像文件');
if isequal(filename,0) || isequal(pathname,0)
    return;
end
img = imread(fullfile(pathname,filename));
grayImg = rgb2gray(img); % 转换为灰度图像

% 输入参数，控制噪声类型（1表示高斯噪声，2表示椒盐噪声）
noise_type = input('请输入噪声类型（1表示高斯噪声，2表示椒盐噪声）：');

% 根据选择添加不同噪声
switch noise_type
    case 1
        % 添加高斯噪声
        mu = 0; % 均值
        sigma = 0.02; % 标准差
        noisyImg = imnoise(grayImg, 'gaussian', mu, sigma);
    case 2
        % 添加椒盐噪声
        density = 0.02; % 噪声密度
        noisyImg = imnoise(grayImg, 'salt & pepper', density);
    otherwise
        error('输入的噪声类型参数不正确，请重新输入');
end

% 显示原始灰度图像
subplot(2, 2, 1);
imshow(grayImg);
title('原始图像');

% 显示添加噪声后的图像
subplot(2, 2, 2);
imshow(noisyImg);
title('添加噪声后的图像');

% 空域滤波（3x3）
filter_size = 3;
h = ones(filter_size) / (filter_size ^ 2); % 生成空域滤波模板
filteredImg_space = imfilter(noisyImg, h);

% 显示空域滤波后的图像
subplot(2, 2, 3);
imshow(filteredImg_space);
title('空域滤波后的图像');

% 频域滤波
% 对图像进行快速傅里叶变换并中心化
fftImg = fftshift(fft2(double(noisyImg)));
[row, col] = size(fftImg);
% 计算截止频率
D0 = min(row, col) / 4;
% 生成理想低通滤波器
H = zeros(row, col);
for u = 1:row
    for v = 1:col
        D = sqrt((u - floor(row / 2) - 1) ^ 2 + (v - floor(col / 2) - 1) ^ 2);
        if D <= D0
            H(u, v) = 1;
        end
    end
end
% 频域滤波
filteredImg_freq = real(ifft2(ifftshift(fftImg.* H)));
filteredImg_freq = uint8(filteredImg_freq);

% 显示频域滤波后的图像
subplot(2, 2, 4);
imshow(filteredImg_freq);
title('频域滤波后的图像');