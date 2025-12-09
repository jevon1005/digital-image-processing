%逆滤波和维纳滤波
%% 读取并显示原始图像
I = imread('C:\Users\小仓\Desktop\Lena.jpg');
if size(I, 3) == 3
    I = rgb2gray(I);
end

%% 模拟运动模糊退化（与练习1相同）
LEN = 25;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
Blurred = imfilter(I, PSF, 'circular', 'conv');

%% 添加噪声（模拟实际情况）
noise_var = 0.001; % 噪声方差
Blurred_noisy = imnoise(Blurred, 'gaussian', 0, noise_var);

%% 1. 逆滤波复原
% 计算退化函数H(u,v)的频域表示
H = psf2otf(PSF, size(Blurred_noisy));
F_blurred = fft2(Blurred_noisy);
F_hat_inv = F_blurred ./ H; % 逆滤波公式 F_hat = G / H
inv_restored = real(ifft2(F_hat_inv));
inv_restored = mat2gray(inv_restored); % 归一化到[0,1]

%% 2. 维纳滤波复原
% 使用近似公式：F_hat = [1/H * (|H|^2) / (|H|^2 + K)] * G
K = 0.01; % 可调参数，根据噪声程度调整
H_abs2 = abs(H).^2;
F_hat_wiener = (1 ./ H) .* (H_abs2 ./ (H_abs2 + K)) .* F_blurred;
wiener_restored = real(ifft2(F_hat_wiener));
wiener_restored = mat2gray(wiener_restored);

%% 3. 对比显示
figure;
subplot(2,3,1), imshow(I), title('原始');
subplot(2,3,2), imshow(Blurred), title('模糊');
subplot(2,3,3), imshow(Blurred_noisy), title('模糊+噪声');
subplot(2,3,4), imshow(inv_restored), title('逆滤波');
subplot(2,3,5), imshow(wiener_restored), title('维纳滤波');