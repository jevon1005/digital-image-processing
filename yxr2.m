%图像退化模型（运动模糊退化、高斯模糊退化、散焦模糊退化）
clear all;
close all;
clc;

%% 1. 读取图像
I = imread('C:\Users\小仓\Desktop\Lena.jpg');
I_gray = rgb2gray(I);

%% 2. 图像退化模型实现
% 获取图像尺寸
[M, N] = size(I_gray);

%% 2.1 运动模糊退化模型（线性运动模糊）
% 创建运动模糊退化函数（点扩散函数PSF）
LEN = min(21, min(M,N)-10);  % 运动模糊长度，不超过图像尺寸
THETA = 45;                  % 运动角度（度）

% 使用MATLAB内置函数创建PSF
psf_motion = fspecial('motion', LEN, THETA);

% 应用运动模糊退化
I_motion_blurred = imfilter(double(I_gray), psf_motion, 'conv', 'replicate');

%% 2.2 高斯模糊退化模型
% 创建高斯退化函数
sigma = 3;  % 高斯核标准差
hsize = min(11, min(M,N)-10); % 高斯核大小，不超过图像尺寸

psf_gaussian = fspecial('gaussian', hsize, sigma);
I_gaussian_blurred = imfilter(double(I_gray), psf_gaussian, 'conv', 'replicate');

%% 2.3 散焦模糊退化模型
% 创建散焦模糊退化函数（圆盘模糊）
R = min(7, floor(min(M,N)/2)-1);  % 散焦半径

psf_disk = fspecial('disk', R);
I_disk_blurred = imfilter(double(I_gray), psf_disk, 'conv', 'replicate');

%% 3. 显示结果
figure('Name', '图像退化模型展示', 'Position', [100, 100, 1200, 800]);

% 原始图像
subplot(2,4,1);
imshow(I_gray, []);
title('原始图像');
xlabel(sprintf('尺寸：%d×%d', M, N));

% 运动模糊退化
subplot(2,4,2);
imshow(uint8(I_motion_blurred));
title('运动模糊退化');
xlabel(sprintf('长度：%d, 角度：%d°', LEN, THETA));

% 显示运动模糊PSF
subplot(2,4,6);
imagesc(psf_motion);
colormap('gray'); colorbar;
title('运动模糊PSF');
axis image;

% 高斯模糊退化
subplot(2,4,3);
imshow(uint8(I_gaussian_blurred));
title('高斯模糊退化');
xlabel(sprintf('σ=%.1f, 核大小=%d', sigma, hsize));

% 显示高斯模糊PSF
subplot(2,4,7);
imagesc(psf_gaussian);
colormap('gray'); colorbar;
title('高斯模糊PSF');
axis image;

% 散焦模糊退化
subplot(2,4,4);
imshow(uint8(I_disk_blurred));
title('散焦模糊退化');
xlabel(sprintf('半径：%d', R));

% 显示散焦模糊PSF
subplot(2,4,8);
imagesc(psf_disk);
colormap('gray'); colorbar;
title('散焦模糊PSF');
axis image;