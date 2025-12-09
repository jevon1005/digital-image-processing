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

%% 2.4 退化模型在频域的实现（验证PPT中的频域公式）
% 原始图像的傅里叶变换
F = fft2(double(I_gray));
F_shifted = fftshift(F);

% 创建高斯滤波器的频域表示
% 先创建空间域的高斯滤波器
sigma_freq = min(15, min(M,N)/4);  % 自适应选择sigma
psf_gaussian_freq = fspecial('gaussian', [M, N], sigma_freq);
% 转换到频域
H_gaussian_freq = fft2(psf_gaussian_freq);
H_gaussian_freq_shifted = fftshift(H_gaussian_freq);

% 频域退化：G(u,v) = H(u,v)F(u,v)
G_gaussian_freq = F .* H_gaussian_freq;

% 逆傅里叶变换得到退化图像
I_gaussian_freq_blurred = real(ifft2(G_gaussian_freq));

%% 2.5 线性移不变系统验证
% 自适应选择测试区域大小
test_size = min(100, floor(min(M,N)/3));  % 测试区域大小

% 确保起始位置不会超出边界
start1 = min(50, M-test_size);
start2 = min(50, N-test_size);

% 创建两个测试图像
test_img1 = double(I_gray(start1:start1+test_size-1, start2:start2+test_size-1));
test_img2 = double(I_gray(start1+test_size:start1+2*test_size-1, start2+test_size:start2+2*test_size-1));

% 检查测试图像是否有效获取
if isempty(test_img1) || isempty(test_img2)
    fprintf('图像太小，跳过线性性验证\n');
    linear_error = 0;
else
    % 测试线性性：H[k1*f1 + k2*f2] = k1*H[f1] + k2*H[f2]
    k1 = 0.3;
    k2 = 0.7;

    % 调整高斯滤波器大小以适应测试图像
    hsize_test = min(hsize, test_size);
    if mod(hsize_test, 2) == 0
        hsize_test = hsize_test - 1;  % 确保为奇数
    end
    psf_gaussian_test = fspecial('gaussian', hsize_test, sigma);

    % 先分别退化再线性组合
    H_f1 = imfilter(test_img1, psf_gaussian_test, 'conv', 'replicate');
    H_f2 = imfilter(test_img2, psf_gaussian_test, 'conv', 'replicate');
    right_side = k1*H_f1 + k2*H_f2;

    % 先线性组合再退化
    combined = k1*test_img1 + k2*test_img2;
    left_side = imfilter(combined, psf_gaussian_test, 'conv', 'replicate');

    % 计算误差
    linear_error = sum(abs(left_side(:) - right_side(:))) / numel(left_side);
    fprintf('线性性验证误差：%.6f\n', linear_error);
end

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

% 频域退化结果单独显示
figure('Name', '频域退化模型', 'Position', [200, 200, 800, 400]);

subplot(1,3,1);
imshow(I_gray, []);
title('原始图像');

subplot(1,3,2);
% 显示频域滤波器
imagesc(log(1 + abs(H_gaussian_freq_shifted)));
colormap('jet'); colorbar;
title('频域滤波器 H(u,v)');
axis image;

subplot(1,3,3);
imshow(uint8(I_gaussian_freq_blurred));
title('频域退化结果');
