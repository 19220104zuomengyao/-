% 清除工作区变量、命令行窗口内容以及关闭所有图形窗口
clear;
clc;
close all;

% 打开文件选择对话框，让用户选择图片文件
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp'},'Select a color image');
if isequal(filename,0) && isequal(pathname,0)
    disp('User canceled the file selection.');
    return;
end

% 读取选中的彩色图片
full_path = fullfile(pathname, filename);
color_image = imread(full_path);

% 将彩色图片转换为灰度图像
gray_image = rgb2gray(color_image);

% 进行二值化处理（这里采用自适应阈值的二值化方法，你也可以选择其他合适的阈值设定方式）
binary_image = imbinarize(gray_image, 'adaptive');

% 定义击中部分的结构元素
se_hit = strel('disk', 3);

% 定义未击中部分的结构元素
disk_matrix = zeros(5); % 先创建一个5x5的全0矩阵，对应外径为5的圆形结构元素尺寸
[rows, cols] = find(imerode(ones(5), strel('disk', 2))); % 找到内径为2的圆形区域位置
disk_matrix(sub2ind(size(disk_matrix), rows, cols)) = 1; % 将环形区域对应的位置设为1
se_miss = strel('arbitrary', disk_matrix); % 用自定义矩阵初始化结构元素

% 对图像进行击中部分的腐蚀操作
eroded_hit = imerode(binary_image, se_hit);

% 对图像取反
complemented_image = ~binary_image;

% 对取反后的图像进行未击中部分的腐蚀操作
eroded_miss = imerode(complemented_image, se_miss);

% 再将腐蚀后的背景取反回来
eroded_miss = ~eroded_miss;

% 执行逻辑与操作，得到击中与否变换的结果
result = eroded_hit & eroded_miss;

% 显示原始彩色图像、二值化图像、击中部分腐蚀结果、未击中部分腐蚀结果以及最终提取结果
subplot(2, 3, 1);
imshow(color_image);
title('原始图像');

subplot(2, 3, 2);
imshow(result);
title('目标提取结果');

% 提取原始图像的LBP特征（这里使用Matlab自带的lbp函数，若版本不同可能函数有差异）
original_lbp = extractLBPFeatures(gray_image);
disp('原始图像的LBP特征：');
disp(original_lbp);

% 绘制原始图像的LBP特征图像（将LBP特征矩阵可视化，这里简单将其以图像形式展示，每个像素对应一个LBP值）
original_lbp_image = mat2gray(original_lbp); % 将特征矩阵归一化到[0,1]便于显示
subplot(2, 3, 3);
imshow(original_lbp_image);
title('Original Image LBP Feature Image');

% 提取原始图像的HOG特征（这里使用Matlab自带的extractHOGFeatures函数）
[original_hog_feat, visualization] = extractHOGFeatures(gray_image);
disp('原始图像的HOG特征：');
disp(original_hog_feat);

% 绘制原始图像的HOG特征图像（利用HOG特征可视化信息展示，通过合适方式获取图像数据）
if isstruct(visualization) && isfield(visualization, 'Visualization')
    hog_image_data = visualization.Visualization; % 对于较新Matlab版本，获取可视化数据部分
    subplot(2, 3, 4);
    imshow(hog_image_data);
    title('Original Image HOG Feature Image');
else
    warning('无法正确解析HOG特征可视化数据，可能版本不兼容');
end

% 提取提取目标图像（result）的LBP特征（需确保result为二值图像，若不是可能要进一步处理）
target_lbp = extractLBPFeatures(result);
disp('提取目标图像的LBP特征：');
disp(target_lbp);

% 绘制提取目标图像的LBP特征图像（同样进行归一化并展示）
target_lbp_image = mat2gray(target_lbp);
subplot(2, 3, 5);
imshow(target_lbp_image);
title('Target Image LBP Feature Image');

% 提取提取目标图像（result）的HOG特征
[target_hog_feat, visualization_target] = extractHOGFeatures(result);
disp('提取目标图像的HOG特征：');
disp(target_hog_feat);

% 绘制提取目标图像的HOG特征图像（利用其可视化信息展示，通过合适方式获取图像数据）
if isstruct(visualization_target) && isfield(visualization_target, 'Visualization')
    hog_image_data_target = visualization_target.Visualization; % 对于较新Matlab版本，获取可视化数据部分
    subplot(2, 3, 6);
    imshow(hog_image_data_target);
    title('Target Image HOG Feature Image');
else
    warning('无法正确解析HOG特征可视化数据，可能版本不兼容');
end