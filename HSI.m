function HSI(rgb_image)
%% HSI.m - HSI模型操作
% 输入: rgb_image - RGB彩色图像
% 输出: 只保留要求的输出

% 检查输入
if size(rgb_image, 3) ~= 3
    error('输入必须是RGB彩色图像(3通道)');
end

% 转换为double类型
rgb_double = im2double(rgb_image);
R = rgb_double(:,:,1);
G = rgb_double(:,:,2);
B = rgb_double(:,:,3);

figure('Name', 'HSI模型操作', 'NumberTitle', 'off', 'Position', [100, 100, 1400, 600]);

%% 1. RGB到HSI转换
fprintf('\n执行RGB到HSI转换...\n');

% 计算强度I
I = (R + G + B) / 3;

% 计算饱和度S
min_RGB = min(min(R, G), B);
S = 1 - 3./(R + G + B + eps) .* min_RGB;
S(R + G + B == 0) = 0;  % 避免除零

% 计算色调H
num = 0.5 * ((R - G) + (R - B));
den = sqrt((R - G).^2 + (R - B).*(G - B) + eps);
theta = acos(num./(den + eps));

H = theta;
H(G < B) = 2*pi - theta(G < B);
H = H / (2*pi);  % 归一化到[0,1]

%% 2. 原始RGB图像
subplot(2, 4, 1);
imshow(rgb_image);
title('原始RGB图像');

%% 3. HSI重建的RGB图像
subplot(2, 4, 2);

% HSI到RGB转换
% 将H从[0,1]转换到[0,2pi]
H_2pi = H * 2 * pi;

% 初始化RGB
R_recon = zeros(size(H));
G_recon = zeros(size(H));
B_recon = zeros(size(H));

% 情况1: H在[0, 2pi/3]
idx1 = (H_2pi >= 0) & (H_2pi < 2*pi/3);
B_recon(idx1) = I(idx1) .* (1 - S(idx1));
R_recon(idx1) = I(idx1) .* (1 + (S(idx1) .* cos(H_2pi(idx1))) ./ ...
                            (cos(pi/3 - H_2pi(idx1)) + eps));
G_recon(idx1) = 3 * I(idx1) - (B_recon(idx1) + R_recon(idx1));

% 情况2: H在[2pi/3, 4pi/3]
idx2 = (H_2pi >= 2*pi/3) & (H_2pi < 4*pi/3);
H_temp = H_2pi(idx2) - 2*pi/3;
R_recon(idx2) = I(idx2) .* (1 - S(idx2));
G_recon(idx2) = I(idx2) .* (1 + (S(idx2) .* cos(H_temp)) ./ ...
                            (cos(pi/3 - H_temp) + eps));
B_recon(idx2) = 3 * I(idx2) - (R_recon(idx2) + G_recon(idx2));

% 情况3: H在[4pi/3, 2pi]
idx3 = (H_2pi >= 4*pi/3) & (H_2pi <= 2*pi);
H_temp = H_2pi(idx3) - 4*pi/3;
G_recon(idx3) = I(idx3) .* (1 - S(idx3));
B_recon(idx3) = I(idx3) .* (1 + (S(idx3) .* cos(H_temp)) ./ ...
                            (cos(pi/3 - H_temp) + eps));
R_recon(idx3) = 3 * I(idx3) - (G_recon(idx3) + B_recon(idx3));

% 限制在[0,1]
R_recon = min(max(R_recon, 0), 1);
G_recon = min(max(G_recon, 0), 1);
B_recon = min(max(B_recon, 0), 1);

rgb_recon = cat(3, R_recon, G_recon, B_recon);

imshow(rgb_recon);
title('HSI重建的RGB图像');

%% 4. H, S, I分量图
% H分量
subplot(2, 4, 3);
imshow(H, []);
colormap(gca, hsv);
colorbar;
title('色调(H)分量');

% S分量
subplot(2, 4, 4);
imshow(S, []);
colormap(gca, hot);
colorbar;
title('饱和度(S)分量');

% I分量
subplot(2, 4, 5);
imshow(I, []);
colormap(gca, gray);
colorbar;
title('强度(I)分量');

%% 5. 饱和度增强图
subplot(2, 4, 6);
% 增加饱和度
S_enhanced = min(S * 1.5, 1);
rgb_s_enhanced = hsi2rgb_custom(H, S_enhanced, I);
imshow(rgb_s_enhanced);
title('饱和度增强 (S×1.5)');

%% 6. 色调旋转图
subplot(2, 4, 7);
% 修改色调（色相旋转）
H_shifted = mod(H + 0.2, 1);  % 旋转72度
rgb_h_shifted = hsi2rgb_custom(H_shifted, S, I);
imshow(rgb_h_shifted);
title('色调旋转 (+72°)');

%% 7. 亮度降低图
subplot(2, 4, 8);
% 修改亮度
I_darkened = I * 0.7;
rgb_i_darkened = hsi2rgb_custom(H, S, I_darkened);
imshow(rgb_i_darkened);
title('亮度降低 (I×0.7)');

fprintf('HSI模型操作完成!\n');
fprintf('  输出: 原始RGB图像, HSI重建的RGB图像, H/S/I分量图\n');
fprintf('        饱和度增强图, 色调旋转图, 亮度降低图\n');
end

%% 辅助函数: HSI到RGB转换
function rgb = hsi2rgb_custom(H, S, I)
    % 将H从[0,1]转换到[0,2pi]
    H_2pi = H * 2 * pi;
    
    % 初始化RGB
    R = zeros(size(H));
    G = zeros(size(H));
    B = zeros(size(H));
    
    % 情况1: H在[0, 2pi/3]
    idx1 = (H_2pi >= 0) & (H_2pi < 2*pi/3);
    B(idx1) = I(idx1) .* (1 - S(idx1));
    R(idx1) = I(idx1) .* (1 + (S(idx1) .* cos(H_2pi(idx1))) ./ ...
                          (cos(pi/3 - H_2pi(idx1)) + eps));
    G(idx1) = 3 * I(idx1) - (B(idx1) + R(idx1));
    
    % 情况2: H在[2pi/3, 4pi/3]
    idx2 = (H_2pi >= 2*pi/3) & (H_2pi < 4*pi/3);
    H_temp = H_2pi(idx2) - 2*pi/3;
    R(idx2) = I(idx2) .* (1 - S(idx2));
    G(idx2) = I(idx2) .* (1 + (S(idx2) .* cos(H_temp)) ./ ...
                          (cos(pi/3 - H_temp) + eps));
    B(idx2) = 3 * I(idx2) - (R(idx2) + G(idx2));
    
    % 情况3: H在[4pi/3, 2pi]
    idx3 = (H_2pi >= 4*pi/3) & (H_2pi <= 2*pi);
    H_temp = H_2pi(idx3) - 4*pi/3;
    G(idx3) = I(idx3) .* (1 - S(idx3));
    B(idx3) = I(idx3) .* (1 + (S(idx3) .* cos(H_temp)) ./ ...
                          (cos(pi/3 - H_temp) + eps));
    R(idx3) = 3 * I(idx3) - (G(idx3) + B(idx3));
    
    % 限制在[0,1]
    R = min(max(R, 0), 1);
    G = min(max(G, 0), 1);
    B = min(max(B, 0), 1);
    
    rgb = cat(3, R, G, B);
end