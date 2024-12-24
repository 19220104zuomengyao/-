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

% 进行二值化处理，采用自适应阈值的二值化方法
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

% 显示原始彩色图像及最终提取结果
subplot(2, 3, 1);
imshow(color_image);
title('原始图像');

subplot(2, 3, 2);
imshow(result);
title('目标提取结果');

% 提取原始图像的LBP特征
image = gray_image;
[N,M] = size(image);
lbp = zeros(N,M);
for j = 2:(N - 1)
    for i = 2:(M - 1)
        neighbor = [image(j - 1, i - 1), image(j - 1, i), image(j - 1, i + 1);
                    image(j, i - 1), image(j, i), image(j, i + 1);
                    image(j + 1, i - 1), image(j + 1, i), image(j + 1, i + 1)];
        count = 0;
        for k = 0:7
            binVal1 = neighbor(mod(k + 1,3)+1,ceil((k + 1)/3));
            binVal2 = image(j, i);
            if binVal1> binVal2
                count = count + 2 ^ (7 - k);
            end
        end
        lbp(j, i) = count;
    end
end
lbp = uint8(lbp);
disp('原始图像的LBP特征：');
disp(lbp);

% 绘制原始图像的LBP特征图像
original_lbp_image = mat2gray(lbp);
subplot(2, 3, 3);
imshow(original_lbp_image);
title('原始图像的LBP特征图像');

% 提取原始图像的HOG特征
% handles = []; % 这里handles没有定义，需要根据实际情况补充
grayImg = gray_image; 
[original_hog_feat, visualization] = extractHOGFeatures(grayImg, 'CellSize', [8 8], 'BlockSize', [2 2]);
disp('原始图像的HOG特征：');
disp(original_hog_feat);

subplot(2, 3, 4);
plot(visualization); 
title('原始图像的HOG特征图像');


% 提取提取目标图像的LBP特征
image = result;
[N,M] = size(image);
lbp = zeros(N,M);
for j = 2:(N - 1)
    for i = 2:(M - 1)
        neighbor = [image(j - 1, i - 1), image(j - 1, i), image(j - 1, i + 1);
                    image(j, i - 1), image(j, i), image(j, i + 1);
                    image(j + 1, i - 1), image(j + 1, i), image(j + 1, i + 1)];
        count = 0;
        for k = 0:7
            binVal1 = neighbor(mod(k + 1,3)+1,ceil((k + 1)/3));
            binVal2 = image(j, i);
            if binVal1> binVal2
                count = count + 2 ^ (7 - k);
            end
        end
        lbp(j, i) = count;
    end
end
lbp = uint8(lbp);
disp('提取目标图像的LBP特征：');
disp(lbp);

% 绘制提取目标图像的LBP特征图像
target_lbp_image = mat2gray(lbp);
subplot(2, 3, 5);
imshow(target_lbp_image);
title('目标图像的LBP特征图像');

% 提取提取目标图像的HOG特征
grayImg = result;
[target_hog_feat, visualization_target] = extractHOGFeatures(grayImg, 'CellSize', [8 8], 'BlockSize', [2 2]);
disp('提取目标图像的HOG特征：');
disp(target_hog_feat);

subplot(2, 3, 6);
plot(visualization_target); 
title('目标图像的HOG特征图像');
