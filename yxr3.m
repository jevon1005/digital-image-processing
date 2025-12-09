%噪声模型（高斯、均匀分布、椒盐）
clear all;
close all;
clc;

%% 1. 读取图像
I = imread('C:\Users\小仓\Desktop\Lena.jpg');
I_gray = rgb2gray(I);
[M, N] = size(I_gray);

%% 2. 噪声模型实现
%% 2.1 高斯噪声模型
mu_gaussian = 0;
var_gaussian = 0.02;
sigma_gaussian = sqrt(var_gaussian);

I_gaussian_noise = imnoise(I_gray, 'gaussian', mu_gaussian, var_gaussian);
%% 2.2 均匀分布噪声模型
a_uniform = -30;
b_uniform = 30;

noise_uniform = a_uniform + (b_uniform - a_uniform) * rand(M, N);
I_uniform_noise = double(I_gray) + noise_uniform;
I_uniform_noise = uint8(min(max(I_uniform_noise, 0), 255));

%% 2.3 椒盐噪声模型
density_saltpepper = 0.05;
I_saltpepper_noise = imnoise(I_gray, 'salt & pepper', density_saltpepper);

%% 3. 显示结果
figure('Name', '噪声模型效果对比', 'Position', [50, 50, 1200, 900]);

subplot(2,4,1);
imshow(I_gray);
title('(a) 原图');

subplot(2,4,2);
imshow(I_gaussian_noise);
title('(b) 高斯噪声图像');

subplot(2,4,3);
imshow(I_uniform_noise);
title('(c) 均匀分布噪声图像');

subplot(2,4,4);
imshow(I_saltpepper_noise);
title('(d) 椒盐噪声图像');

subplot(2,4,5);
[counts, centers] = imhist(I_gray);
bar(centers, counts);
title('(e) 原图直方图');
xlabel('灰度值');
ylabel('像素数');
grid on;
xlim([0 255]);

subplot(2,4,6);
[counts, centers] = imhist(I_gaussian_noise);
bar(centers, counts);
title('(f) 高斯噪声直方图');
xlabel('灰度值');
ylabel('像素数');
grid on;
xlim([0 255]);

subplot(2,4,7);
[counts, centers] = imhist(I_uniform_noise);
bar(centers, counts);
title('(g) 均匀分布噪声直方图');
xlabel('灰度值');
ylabel('像素数');
grid on;
xlim([0 255]);

subplot(2,4,8);
[counts, centers] = imhist(I_saltpepper_noise);
bar(centers, counts);
title('(h) 椒盐噪声直方图');
xlabel('灰度值');
ylabel('像素数');
grid on;
xlim([0 255]);