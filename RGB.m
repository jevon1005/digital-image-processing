function RGB(rgb_image)
%% RGB.m - RGB模型操作
% 输入: rgb_image - RGB彩色图像

% 检查输入
if size(rgb_image, 3) ~= 3
    error('输入必须是RGB彩色图像(3通道)');
end

% 转换为double类型用于计算
rgb_double = im2double(rgb_image);

figure('Name', 'RGB模型操作', 'NumberTitle', 'off', 'Position', [50, 50, 1400, 900]);

%% 1. 显示原始RGB图像和各个通道
subplot(3, 4, 1);
imshow(rgb_image);
title('原始RGB图像');
xlabel(sprintf('%dx%dx%d', size(rgb_image,1), size(rgb_image,2), size(rgb_image,3)));

% 显示各个通道
channels = {'红色通道(R)', '绿色通道(G)', '蓝色通道(B)'};
for i = 1:3
    subplot(3, 4, i+1);
    channel_img = zeros(size(rgb_image));
    channel_img(:,:,i) = rgb_image(:,:,i);
    imshow(uint8(channel_img));
    title(channels{i});
    
    % 显示单通道灰度图
    subplot(3, 4, i+5);
    imshow(rgb_image(:,:,i));
    colormap(gca, gray);
    title(sprintf('%s灰度图', channels{i}(1)));
    colorbar;
end

%% 2. 新增：RGB转HSI图（替换原来的RGB分量直方图位置）
subplot(3, 4, 5);
% 计算HSI
R = rgb_double(:,:,1);
G = rgb_double(:,:,2);
B = rgb_double(:,:,3);

% 计算强度I
I = (R + G + B) / 3;

% 计算饱和度S
min_RGB = min(min(R, G), B);
S = 1 - 3./(R + G + B + eps) .* min_RGB;
S(R + G + B == 0) = 0;

% 计算色调H
num = 0.5 * ((R - G) + (R - B));
den = sqrt((R - G).^2 + (R - B).*(G - B) + eps);
theta = acos(num./(den + eps));

H = theta;
H(G < B) = 2*pi - theta(G < B);
H = H / (2*pi);  % 归一化到[0,1]

% 显示HSI合成图
hsi_display = cat(3, H, S, I);
imshow(hsi_display);
title('RGB转HSI图');
colorbar;

%% 3. 新增：红灰度图（替换原来的RGB颜色立方体位置）
subplot(3, 4, 6);
% 只保留红色通道的灰度图
red_gray = rgb_double(:,:,1);
imshow(red_gray);
colormap(gca, gray);
colorbar;
title('红灰度图');

%% 4. RGB到灰度的转换（不使用rgb2gray）
subplot(3, 4, 9);
% 使用标准转换公式: Y = 0.299R + 0.587G + 0.114B
gray_custom = 0.299 * rgb_double(:,:,1) + ...
              0.587 * rgb_double(:,:,2) + ...
              0.114 * rgb_double(:,:,3);
imshow(gray_custom);
title('自定义RGB转灰度');
colorbar;

% 与MATLAB内置函数比较
subplot(3, 4, 10);
gray_matlab = rgb2gray(rgb_double);
imshow(gray_matlab);
title('MATLAB rgb2gray');
colorbar;

% 显示差异
subplot(3, 4, 11);
diff = abs(gray_custom - gray_matlab);
imshow(diff, []);
title('转换差异');
colorbar;
fprintf('自定义转换与MATLAB转换的最大差异: %.6f\n', max(diff(:)));

%% 5. 删除：RGB图像生成示例（原subplot(3,4,12)位置留空或显示其他信息）
subplot(3, 4, 12);
% 显示统计信息
stats_text = sprintf('RGB统计信息:\n');
stats_text = [stats_text sprintf('尺寸: %dx%dx%d\n', size(rgb_image,1), size(rgb_image,2), size(rgb_image,3))];
stats_text = [stats_text sprintf('红色通道: 均值=%.2f\n', mean2(rgb_double(:,:,1)))];
stats_text = [stats_text sprintf('绿色通道: 均值=%.2f\n', mean2(rgb_double(:,:,2)))];
stats_text = [stats_text sprintf('蓝色通道: 均值=%.2f\n', mean2(rgb_double(:,:,3)))];
text(0.1, 0.3, stats_text, 'FontSize', 10);
axis off;
title('统计信息');

%% 6. RGB统计信息
fprintf('\nRGB模型操作:\n');
fprintf('  图像尺寸: %dx%dx%d\n', size(rgb_image,1), size(rgb_image,2), size(rgb_image,3));
fprintf('  红色通道: 均值=%.2f, 方差=%.2f\n', mean2(rgb_double(:,:,1)), std2(rgb_double(:,:,1)));
fprintf('  绿色通道: 均值=%.2f, 方差=%.2f\n', mean2(rgb_double(:,:,2)), std2(rgb_double(:,:,2)));
fprintf('  蓝色通道: 均值=%.2f, 方差=%.2f\n', mean2(rgb_double(:,:,3)), std2(rgb_double(:,:,3)));

fprintf('RGB模型操作完成!\n');
end