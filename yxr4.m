%仅有噪声的复原-空间滤波
clear all;
close all;
clc;

%% 1. 读取图像并添加噪声
I = imread('C:\Users\小仓\Desktop\Lena.jpg');
I_gray = rgb2gray(I);
[M, N] = size(I_gray);

%% 2. 添加噪声（用于复原实验）
% 2.1 添加椒盐噪声
density_sp = 0.03;
I_saltpepper = imnoise(I_gray, 'salt & pepper', density_sp);

% 2.2 添加高斯噪声
var_gaussian = 0.02;
I_gaussian = imnoise(I_gray, 'gaussian', 0, var_gaussian);

% 或者更平衡的比例
I_mixed = imnoise(I_gray, 'gaussian', 0, 0.02);  % 增加高斯噪声强度
I_mixed = imnoise(I_mixed, 'salt & pepper', 0.02); % 适当降低椒盐噪声

%% 3. 空间滤波复原实现
% 滤波器窗口大小
window_size = 3;
pad_size = floor(window_size/2);

%% 3.1 均值滤波器
% 3.1.1 算术均值滤波器
I_saltpepper_padded = padarray(double(I_saltpepper), [pad_size pad_size], 'replicate');
I_arithmetic = zeros(M, N);
for i = 1:M
    for j = 1:N
        window = I_saltpepper_padded(i:i+window_size-1, j:j+window_size-1);
        I_arithmetic(i, j) = mean(window(:));
    end
end
I_arithmetic = uint8(I_arithmetic);

% 在3.1.1节后添加
% 3.1.1b 算术均值滤波器（对高斯噪声）
I_gaussian_arithmetic = zeros(M, N);
I_gaussian_padded_arith = padarray(double(I_gaussian), [pad_size pad_size], 'replicate');
for i = 1:M
    for j = 1:N
        window = I_gaussian_padded_arith(i:i+window_size-1, j:j+window_size-1);
        I_gaussian_arithmetic(i, j) = mean(window(:));
    end
end
I_gaussian_arithmetic = uint8(I_gaussian_arithmetic);

% 3.1.2 几何均值滤波器
I_gaussian_padded = padarray(double(I_gaussian), [pad_size pad_size], 'replicate');
I_geometric = zeros(M, N);
for i = 1:M
    for j = 1:N
        window = I_gaussian_padded(i:i+window_size-1, j:j+window_size-1);
        window(window == 0) = 1;
        I_geometric(i, j) = exp(mean(log(window(:))));
    end
end
I_geometric = uint8(I_geometric);
%3.1.2b 几何均值滤波器（对椒盐噪声）
I_saltpepper_geometric = zeros(M, N);
I_sp_geo_padded = padarray(double(I_saltpepper), [pad_size pad_size], 'replicate');
for i = 1:M
    for j = 1:N
        window = I_sp_geo_padded(i:i+window_size-1, j:j+window_size-1);
        window(window == 0) = 1;
        I_saltpepper_geometric(i, j) = exp(mean(log(window(:))));
    end
end
I_saltpepper_geometric = uint8(I_saltpepper_geometric);

% 3.1.3 谐波均值滤波器
I_saltpepper_padded2 = padarray(double(I_saltpepper), [pad_size pad_size], 'replicate');
I_harmonic = zeros(M, N);
for i = 1:M
    for j = 1:N
        window = I_saltpepper_padded2(i:i+window_size-1, j:j+window_size-1);
        window(window == 0) = 0.001;
        I_harmonic(i, j) = numel(window) / sum(1./window(:));
    end
end
I_harmonic = uint8(I_harmonic);

% 3.1.4 逆谐波均值滤波器
I_saltpepper_padded3 = padarray(double(I_saltpepper), [pad_size pad_size], 'replicate');
I_inv_harmonic_pos = zeros(M, N);
I_inv_harmonic_neg = zeros(M, N);
Q_pos = 1.5;
Q_neg = -1.5;
for i = 1:M
    for j = 1:N
        window = I_saltpepper_padded3(i:i+window_size-1, j:j+window_size-1);
        % Q>0（去除胡椒噪声）
        numerator_pos = sum(window(:).^(Q_pos+1));
        denominator_pos = sum(window(:).^Q_pos);
        if denominator_pos ~= 0
            I_inv_harmonic_pos(i, j) = numerator_pos / denominator_pos;
        end
        % Q<0（去除盐噪声）
        window_no_zero = window;
        window_no_zero(window_no_zero == 0) = 0.001;
        numerator_neg = sum(window_no_zero(:).^(Q_neg+1));
        denominator_neg = sum(window_no_zero(:).^Q_neg);
        if denominator_neg ~= 0
            I_inv_harmonic_neg(i, j) = numerator_neg / denominator_neg;
        end
    end
end
I_inv_harmonic_pos = uint8(I_inv_harmonic_pos);
I_inv_harmonic_neg = uint8(I_inv_harmonic_neg);

%% 3.2 顺序统计滤波器
% 3.2.1 中值滤波器
I_median = medfilt2(I_saltpepper, [window_size window_size]);

% 3.2.1b 中值滤波器（混合噪声）- 新增
I_median_mixed = medfilt2(I_mixed, [window_size window_size]);

% 3.2.2 最大/最小滤波器
I_saltpepper_padded4 = padarray(double(I_saltpepper), [pad_size pad_size], 'replicate');
I_max = zeros(M, N);
I_min = zeros(M, N);
for i = 1:M
    for j = 1:N
        window = I_saltpepper_padded4(i:i+window_size-1, j:j+window_size-1);
        I_max(i, j) = max(window(:));
        I_min(i, j) = min(window(:));
    end
end
I_max = uint8(I_max);
I_min = uint8(I_min);

% 3.2.3 中点滤波器
I_midpoint = zeros(M, N);
for i = 1:M
    for j = 1:N
        window = I_saltpepper_padded4(i:i+window_size-1, j:j+window_size-1);
        I_midpoint(i, j) = 0.5 * (max(window(:)) + min(window(:)));
    end
end
I_midpoint = uint8(I_midpoint);

% 3.2.4 修正的阿尔法均值滤波器
I_mixed_padded = padarray(double(I_mixed), [pad_size pad_size], 'replicate');
I_alpha_trimmed = zeros(M, N);
d = 6;
for i = 1:M
    for j = 1:N
        window = I_mixed_padded(i:i+window_size-1, j:j+window_size-1);
        window_vector = sort(window(:));
        if d > 0 && d < numel(window_vector)
            start_idx = floor(d/2) + 1;
            end_idx = numel(window_vector) - floor(d/2);
            trimmed_values = window_vector(start_idx:end_idx);
            I_alpha_trimmed(i, j) = mean(trimmed_values);
        else
            I_alpha_trimmed(i, j) = mean(window_vector);
        end
    end
end
I_alpha_trimmed = uint8(I_alpha_trimmed);

% 3.2.4b 修正的阿尔法均值滤波器（对椒盐噪声）
I_saltpepper_alpha = zeros(M, N);
I_sp_alpha_padded = padarray(double(I_saltpepper), [pad_size pad_size], 'replicate');
for i = 1:M
    for j = 1:N
        window = I_sp_alpha_padded(i:i+window_size-1, j:j+window_size-1);
        window_vector = sort(window(:));
        if d > 0 && d < numel(window_vector)
            start_idx = floor(d/2) + 1;
            end_idx = numel(window_vector) - floor(d/2);
            trimmed_values = window_vector(start_idx:end_idx);
            I_saltpepper_alpha(i, j) = mean(trimmed_values);
        else
            I_saltpepper_alpha(i, j) = mean(window_vector);
        end
    end
end
I_saltpepper_alpha = uint8(I_saltpepper_alpha);
%% 4. 显示结果 - 重新组织显示
%% 4.1 显示均值滤波器结果（针对椒盐噪声）
figure('Name', '均值滤波器对椒盐噪声的复原效果', 'Position', [50, 100, 1400, 500]);

subplot(2, 3, 1);
imshow(I_saltpepper);
title('椒盐噪声原图', 'FontSize', 11);
ylabel('输入图像', 'FontSize', 11, 'FontWeight', 'bold');
box on;

subplot(2, 3, 2);
imshow(I_arithmetic);
title('算术均值滤波', 'FontSize', 11);
ylabel('均值滤波器', 'FontSize', 11, 'FontWeight', 'bold');
box on;

subplot(2, 3, 3);
imshow(I_harmonic);
title('谐波均值滤波', 'FontSize', 11);
box on;

subplot(2, 3, 4);
imshow(I_inv_harmonic_pos);
title(['逆谐波滤波(Q=' num2str(Q_pos) ')'], 'FontSize', 11);
box on;

subplot(2, 3, 5);
imshow(I_inv_harmonic_neg);
title(['逆谐波滤波(Q=' num2str(Q_neg) ')'], 'FontSize', 11);
box on;

subplot(2, 3, 6);
imshow(I_saltpepper_geometric);  % 改为对椒盐噪声的几何均值滤波
title('几何均值滤波', 'FontSize', 11);
box on;

%% 4.3 显示顺序统计滤波器结果（针对椒盐噪声）
figure('Name', '顺序统计滤波器对椒盐噪声的复原效果', 'Position', [50, 150, 1200, 500]);

subplot(2, 4, 1);
imshow(I_saltpepper);
title('椒盐噪声原图', 'FontSize', 11);
ylabel('输入图像', 'FontSize', 11, 'FontWeight', 'bold');
box on;

subplot(2, 4, 2);
imshow(I_median);
title('中值滤波器', 'FontSize', 11);
ylabel('顺序统计滤波器', 'FontSize', 11, 'FontWeight', 'bold');
box on;

subplot(2, 4, 3);
imshow(I_max);
title('最大值滤波器', 'FontSize', 11);
box on;

subplot(2, 4, 4);
imshow(I_min);
title('最小值滤波器', 'FontSize', 11);
box on;

subplot(2, 4, 6);
imshow(I_midpoint);
title('中点滤波器', 'FontSize', 11);
box on;

% 修改4.3节的显示
subplot(2, 4, 7);
imshow(I_saltpepper_alpha);  % 改为对椒盐噪声的阿尔法均值滤波
title('阿尔法均值滤波器', 'FontSize', 11);

% 显示滤波器信息
subplot(2, 4, 8);
axis off;
text(0.1, 0.7, '滤波器参数:', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'k');
text(0.1, 0.5, sprintf('窗口大小: %d×%d', window_size, window_size), 'FontSize', 10, 'Color', 'k');
text(0.1, 0.3, sprintf('阿尔法均值d值: %d', d), 'FontSize', 10, 'Color', 'k');
box on;

%% 4.4 补充：均值滤波器对高斯噪声的复原效果（完整对比）
figure('Name', '均值滤波器对高斯噪声的复原效果对比', 'Position', [50, 300, 1400, 500]);

subplot(2, 4, 1);
imshow(I_gaussian);
title('高斯噪声图像', 'FontSize', 11);
ylabel('输入图像', 'FontSize', 11, 'FontWeight', 'bold');
box on;

subplot(2, 4, 2);
imshow(I_gaussian_arithmetic);
title('算术均值滤波', 'FontSize', 11);
ylabel('均值滤波器', 'FontSize', 11, 'FontWeight', 'bold');
box on;

subplot(2, 4, 3);
imshow(I_geometric);
title('几何均值滤波', 'FontSize', 11);
box on;

subplot(2, 4, 4);
% 需要计算谐波均值滤波器对高斯噪声的效果（补充代码）
I_gaussian_harmonic = zeros(M, N);
I_gaussian_padded_h = padarray(double(I_gaussian), [pad_size pad_size], 'replicate');
for i = 1:M
    for j = 1:N
        window = I_gaussian_padded_h(i:i+window_size-1, j:j+window_size-1);
        window(window == 0) = 0.001;
        I_gaussian_harmonic(i, j) = numel(window) / sum(1./window(:));
    end
end
I_gaussian_harmonic = uint8(I_gaussian_harmonic);
imshow(I_gaussian_harmonic);
title('谐波均值滤波', 'FontSize', 11);
box on;


subplot(2, 4, 5);
% 逆谐波均值滤波器对高斯噪声（Q=0.5）
I_inv_harmonic_gauss = zeros(M, N);
Q_gauss = 0.5;
for i = 1:M
    for j = 1:N
        window = I_gaussian_padded_h(i:i+window_size-1, j:j+window_size-1);
        numerator = sum(window(:).^(Q_gauss+1));
        denominator = sum(window(:).^Q_gauss);
        if denominator ~= 0
            I_inv_harmonic_gauss(i, j) = numerator / denominator;
        end
    end
end
I_inv_harmonic_gauss = uint8(I_inv_harmonic_gauss);
imshow(I_inv_harmonic_gauss);
title(['逆谐波滤波(Q=' num2str(Q_gauss) ')'], 'FontSize', 11);
box on;


subplot(2, 4, 8);
axis off;
text(0.1, 0.7, '滤波器参数:', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'k');
text(0.1, 0.5, sprintf('窗口大小: %d×%d', window_size, window_size), 'FontSize', 10, 'Color', 'k');
text(0.1, 0.3, sprintf('高斯噪声方差: %.3f', var_gaussian), 'FontSize', 10, 'Color', 'k');
box on;

%% 4.5 补充：顺序统计滤波器对高斯噪声的复原效果
% 计算顺序统计滤波器对高斯噪声的效果
I_gaussian_padded_os = padarray(double(I_gaussian), [pad_size pad_size], 'replicate');

% 中值滤波
I_gaussian_median = medfilt2(I_gaussian, [window_size window_size]);

% 最大值/最小值滤波
I_gaussian_max = zeros(M, N);
I_gaussian_min = zeros(M, N);
for i = 1:M
    for j = 1:N
        window = I_gaussian_padded_os(i:i+window_size-1, j:j+window_size-1);
        I_gaussian_max(i, j) = max(window(:));
        I_gaussian_min(i, j) = min(window(:));
    end
end
I_gaussian_max = uint8(I_gaussian_max);
I_gaussian_min = uint8(I_gaussian_min);

% 中点滤波
I_gaussian_midpoint = zeros(M, N);
for i = 1:M
    for j = 1:N
        window = I_gaussian_padded_os(i:i+window_size-1, j:j+window_size-1);
        I_gaussian_midpoint(i, j) = 0.5 * (max(window(:)) + min(window(:)));
    end
end
I_gaussian_midpoint = uint8(I_gaussian_midpoint);

% 阿尔法均值滤波对高斯噪声
I_gaussian_alpha = zeros(M, N);
for i = 1:M
    for j = 1:N
        window = I_gaussian_padded_os(i:i+window_size-1, j:j+window_size-1);
        window_vector = sort(window(:));
        if d > 0 && d < numel(window_vector)
            start_idx = floor(d/2) + 1;
            end_idx = numel(window_vector) - floor(d/2);
            trimmed_values = window_vector(start_idx:end_idx);
            I_gaussian_alpha(i, j) = mean(trimmed_values);
        else
            I_gaussian_alpha(i, j) = mean(window_vector);
        end
    end
end
I_gaussian_alpha = uint8(I_gaussian_alpha);

% 显示结果
figure('Name', '顺序统计滤波器对高斯噪声的复原效果', 'Position', [50, 350, 1200, 500]);

subplot(2, 4, 1);
imshow(I_gaussian);
title('高斯噪声图像', 'FontSize', 11);
ylabel('输入图像', 'FontSize', 11, 'FontWeight', 'bold');
box on;

subplot(2, 4, 2);
imshow(I_gaussian_median);
title('中值滤波器', 'FontSize', 11);
ylabel('顺序统计滤波器', 'FontSize', 11, 'FontWeight', 'bold');
box on;

subplot(2, 4, 3);
imshow(I_gaussian_max);
title('最大值滤波器', 'FontSize', 11);
box on;

subplot(2, 4, 4);
imshow(I_gaussian_min);
title('最小值滤波器', 'FontSize', 11);
box on;

subplot(2, 4, 5);
imshow(I_gaussian_midpoint);
title('中点滤波器', 'FontSize', 11);
box on;

subplot(2, 4, 6);
imshow(I_gaussian_alpha);
title(['阿尔法均值滤波器(d=' num2str(d) ')'], 'FontSize', 11);
box on;

subplot(2, 4, 7);
imshow(I_gaussian_arithmetic);
title('算术均值滤波对比', 'FontSize', 11);
box on;

subplot(2, 4, 8);
axis off;
text(0.1, 0.7, '滤波器参数:', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'k');
text(0.1, 0.5, sprintf('窗口大小: %d×%d', window_size, window_size), 'FontSize', 10, 'Color', 'k');
text(0.1, 0.3, sprintf('高斯噪声方差: %.3f', var_gaussian), 'FontSize', 10, 'Color', 'k');
text(0.1, 0.1, sprintf('阿尔法均值d值: %d', d), 'FontSize', 10, 'Color', 'k');
box on;
%% 4.6 阿尔法均值滤波器对混合噪声的效果
%% 4.6 阿尔法均值滤波器对混合噪声的效果
figure('Name', '阿尔法均值滤波器对混合噪声的效果', 'Position', [50, 250, 800, 400]);

subplot(1, 3, 1);
imshow(I_mixed);
title('混合噪声图像', 'FontSize', 12);
xlabel('高斯(0.02)+椒盐(0.02)混合噪声');  % 添加具体参数
box on;

subplot(1, 3, 2);
imshow(I_alpha_trimmed);
title('阿尔法均值滤波结果', 'FontSize', 12);
xlabel(sprintf('d=%d, 窗口%d×%d', d, window_size, window_size));
box on;

subplot(1, 3, 3);
imshow(I_median_mixed);  % 使用正确的混合噪声中值滤波结果
title('中值滤波对比', 'FontSize', 12);
xlabel(sprintf('%d×%d窗口', window_size, window_size));
box on;