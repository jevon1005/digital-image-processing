%频率高通滤波器（理想、高斯、巴特沃斯）
clear all;
close all;
clc;

I = imread('C:\Users\小仓\Desktop\Lena.jpg');
Ig = rgb2gray(I);
FI = fft2(Ig);
Fc = fftshift(FI);
[M,N] = size(Ig);
center1 = floor(M/2);
center2 = floor(N/2);
D0 = 50;
n = 2; % 巴特沃斯滤波器阶数

% 初始化高通滤波器
H_ideal_hp = zeros(M,N);    % 理想高通滤波器
H_gaussian_hp = zeros(M,N); % 高斯高通  
H_butterworth_hp = zeros(M,N); % 巴特沃斯高通

for i = 1:M
    for j = 1:N
        d = sqrt((i-center1).^2 + (j-center2).^2);
        if d == 0
            d = 0.001;
        end

        %%高通滤波器
        % 理想高通滤波
        if d > D0
            H_ideal_hp(i,j) = 1;
        end
        % 高斯高通滤波
        H_gaussian_hp(i,j) = 1 - exp(-d^2/(2*D0^2));
        % 巴特沃斯高通滤波
        H_butterworth_hp(i,j) = 1/(1 + (D0/d)^(2*n));
    end
end

%% 高通滤波处理
% 理想高通滤波
Fh_ideal_hp = Fc .* H_ideal_hp;
I_ideal_hp = real(ifft2(ifftshift(Fh_ideal_hp)));

% 高斯高通滤波
Fh_gaussian_hp = Fc .* H_gaussian_hp;
I_gaussian_hp = real(ifft2(ifftshift(Fh_gaussian_hp)));

% 巴特沃斯高通滤波
Fh_butterworth_hp = Fc .* H_butterworth_hp;
I_butterworth_hp = real(ifft2(ifftshift(Fh_butterworth_hp)));

%% 显示结果 - 高通滤波器
subplot(2,2,1); imshow(Ig); title('原图');
subplot(2,2,2); imshow(I_ideal_hp, []); title('理想高通滤波');
subplot(2,2,3); imshow(I_gaussian_hp, []); title('高斯高通滤波');
subplot(2,2,4); imshow(I_butterworth_hp, []); title('巴特沃斯高通滤波');