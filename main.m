clear all;
close all;
clc;

%% 1. 读取图像
% 如果是彩色图像
rgb_image = imread('1.png');  % 示例图像
if size(rgb_image, 3) == 1
    rgb_image = cat(3, rgb_image, rgb_image, rgb_image);  % 转换为RGB
end

% 转换为灰度图像用于Radon变换
gray_image = rgb2gray(rgb_image);

fprintf('图像处理开始...\n');
fprintf('图像大小: %d x %d x %d\n', size(rgb_image, 1), size(rgb_image, 2), size(rgb_image, 3));

%% 2. 调用各个功能模块

% 功能1: Radon变换
fprintf('\n=== 功能1: Radon变换 ===\n');
radon_result = Radon(gray_image);
title('Radon变换结果 - 正弦图');

% 功能2: 傅里叶切片定理演示
fprintf('\n=== 功能2: 傅里叶切片定理演示 ===\n');
fourierSliceTheorem(gray_image);

% 功能3: 反投影重建
fprintf('\n=== 功能3: 反投影重建 ===\n');
filteredBackProjectionRecon(radon_result, 0:179);

% 功能4: RGB模型操作
fprintf('\n=== 功能4: RGB模型操作 ===\n');
RGB(rgb_image);

% 功能5: HSI模型操作
fprintf('\n=== 功能5: HSI模型操作 ===\n');
HSI(rgb_image);

fprintf('\n所有处理完成!\n');