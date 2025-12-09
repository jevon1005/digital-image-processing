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

% 2.3 添加混合噪声
I_mixed = imnoise(I_gray, 'gaussian', 0, 0.01);
I_mixed = imnoise(I_mixed, 'salt & pepper', 0.03);

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
imshow(I_geometric);
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

subplot(2, 4, 7);
imshow(I_alpha_trimmed);
title('阿尔法均值滤波器', 'FontSize', 11);
box on;

% 显示滤波器信息
subplot(2, 4, 8);
axis off;
text(0.1, 0.7, '滤波器参数:', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'k');
text(0.1, 0.5, sprintf('窗口大小: %d×%d', window_size, window_size), 'FontSize', 10, 'Color', 'k');
text(0.1, 0.3, sprintf('阿尔法均值d值: %d', d), 'FontSize', 10, 'Color', 'k');
box on;

%% 4.4 几何均值滤波器对高斯噪声的效果
figure('Name', '几何均值滤波器对高斯噪声的效果', 'Position', [50, 200, 800, 400]);

subplot(1, 3, 1);
imshow(I_gaussian);
title('高斯噪声图像', 'FontSize', 12);
xlabel(sprintf('噪声方差: %.3f', var_gaussian));
box on;

subplot(1, 3, 2);
imshow(I_geometric);
title('几何均值滤波结果', 'FontSize', 12);
xlabel(sprintf('%d×%d窗口', window_size, window_size));
box on;

subplot(1, 3, 3);
imshow(I_arithmetic);
title('算术均值滤波对比', 'FontSize', 12);
xlabel(sprintf('%d×%d窗口', window_size, window_size));
box on;

%% 4.5 阿尔法均值滤波器对混合噪声的效果
figure('Name', '阿尔法均值滤波器对混合噪声的效果', 'Position', [50, 250, 800, 400]);

subplot(1, 3, 1);
imshow(I_mixed);
title('混合噪声图像', 'FontSize', 12);
xlabel('高斯+椒盐混合噪声');
box on;

subplot(1, 3, 2);
imshow(I_alpha_trimmed);
title('阿尔法均值滤波结果', 'FontSize', 12);
xlabel(sprintf('d=%d, 窗口%d×%d', d, window_size, window_size));
box on;

subplot(1, 3, 3);
imshow(I_median);
title('中值滤波对比', 'FontSize', 12);
xlabel(sprintf('%d×%d窗口', window_size, window_size));
box on;