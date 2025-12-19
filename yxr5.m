%逆滤波和维纳滤波
%% 读取并显示原始图像
I = imread('D:\素材\每日照片\IMG_0415 拷贝 2.jpg');
if size(I, 3) == 3
    I = rgb2gray(I);
end

%% 模拟运动模糊退化
LEN = 25;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
Blurred = imfilter(I, PSF, 'circular', 'conv');

%% 添加噪声（模拟实际情况）
noise_var = 0.001; % 噪声方差
Blurred_noisy = imnoise(Blurred, 'gaussian', 0, noise_var);

%% 1. 传统逆滤波（失败版本）
H1 = psf2otf(PSF, size(Blurred_noisy));
H1_abs = abs(H1);  % 只取幅度，丢失相位信息
F_blurred1 = fft2(Blurred_noisy);
F_hat_inv1 = F_blurred1 ./ H1_abs; % 逆滤波公式 F_hat = G / H
inv_restored1 = real(ifft2(F_hat_inv1));
inv_restored1 = mat2gray(inv_restored1); % 归一化到[0,1]

%% 2. 改进逆滤波方法1：阈值处理法
H2 = psf2otf(PSF, size(Blurred_noisy));
F_blurred2 = fft2(Blurred_noisy);

% 设置阈值，避免除以接近零的值
threshold = 0.05; % 可以调整这个值，通常在0.01-0.1之间
H_mag2 = abs(H2);
H_reg2 = H2; % 复制原始H
% 小于阈值的设为阈值，保持相位信息
H_reg2(H_mag2 < threshold) = threshold .* exp(1i * angle(H2(H_mag2 < threshold)));

F_hat_inv2 = F_blurred2 ./ H_reg2;
inv_restored2 = real(ifft2(F_hat_inv2));
inv_restored2 = mat2gray(inv_restored2);

%% 3. 改进逆滤波方法2：频率限制法
H3 = psf2otf(PSF, size(Blurred_noisy));
F_blurred3 = fft2(Blurred_noisy);

% 限幅逆滤波：当|H|太小时，直接置零（不放大）
limit_factor = 0.05; % 限制因子
H_mag3 = abs(H3);
F_hat_inv3 = zeros(size(F_blurred3));

% 只在|H|足够大的频率上进行逆滤波
valid_idx = H_mag3 > limit_factor * max(H_mag3(:));
F_hat_inv3(valid_idx) = F_blurred3(valid_idx) ./ H3(valid_idx);

inv_restored3 = real(ifft2(F_hat_inv3));
inv_restored3 = mat2gray(inv_restored3);

%% 4. 改进逆滤波方法3：正则化逆滤波
H4 = psf2otf(PSF, size(Blurred_noisy));
F_blurred4 = fft2(Blurred_noisy);

% 正则化参数
alpha = 0.02; % 正则化参数，控制平滑程度

% 正则化逆滤波公式：F_hat = (H* / (|H|^2 + alpha)) * G
H_conj4 = conj(H4);
H_abs2_4 = abs(H4).^2;
F_hat_inv4 = (H_conj4 ./ (H_abs2_4 + alpha)) .* F_blurred4;

inv_restored4 = real(ifft2(F_hat_inv4));
inv_restored4 = mat2gray(inv_restored4);


%% 6. 维纳滤波复原
H6 = psf2otf(PSF, size(Blurred_noisy));
F_blurred6 = fft2(Blurred_noisy);

% 使用近似公式：F_hat = [1/H * (|H|^2) / (|H|^2 + K)] * G
K = 0.01; % 可调参数，根据噪声程度调整
H_abs2_6 = abs(H6).^2;
F_hat_wiener = (1 ./ H6) .* (H_abs2_6 ./ (H_abs2_6 + K)) .* F_blurred6;
wiener_restored = real(ifft2(F_hat_wiener));
wiener_restored = mat2gray(wiener_restored);

%% 7. 对比显示
figure('Position', [100, 100, 1200, 800]);

subplot(2, 4, 1), imshow(I), title('原始图像');
subplot(2, 4, 2), imshow(Blurred), title('运动模糊');
subplot(2, 4, 3), imshow(Blurred_noisy), title('模糊+噪声');

% 显示各种逆滤波结果
subplot(2, 4, 4), imshow(inv_restored1), title('传统逆滤波 (取|H|)');
subplot(2, 4, 5), imshow(inv_restored2), title(sprintf('改进1: 阈值法\nthreshold=%.3f', threshold));
subplot(2, 4, 6), imshow(inv_restored3), title(sprintf('改进2: 频率限制法\nlimit=%.2f', limit_factor));
subplot(2, 4, 7), imshow(inv_restored4), title(sprintf('改进3: 正则化法\nalpha=%.3f', alpha));
subplot(2, 4, 8), imshow(wiener_restored), title(sprintf('维纳滤波\nK=%.3f', K));
