%% test_my_part.m
% 测试自己负责的几个算法模块：
% 1) 灰度 -> 伪彩色
% 2) RGB 各通道分别处理
% 3) 在 HSI 中只处理 I 分量（视作“调用现成 HSI 转换函数”）
% 4) Huffman 编码 / 解码
% 5) 预测编码 / 解码 + 预测残差 Huffman 编码

clear; clc; close all;

%% 1. 灰度 -> 伪彩色 (gray2pseudo_hsi)

fprintf('=== 1. 灰度 -> 伪彩色 测试 ===\n');
I = imread('cameraman.tif');    % 灰度图（或换成课程要求的图像）

J = gray2pseudo_hsi(I);         % 你写的函数

% 基本检查：尺寸、通道数
fprintf('灰度图尺寸：%d x %d\n', size(I,1), size(I,2));
fprintf('伪彩色图尺寸：%d x %d x %d\n', size(J,1), size(J,2), size(J,3));

figure; 
subplot(1,2,1); imshow(I); title('原灰度图');
subplot(1,2,2); imshow(J); title('伪彩色图 (gray2pseudo\_hsi)');

%% 2. RGB 各通道分别处理 (process_rgb_channels)

fprintf('\n=== 2. RGB 各通道处理 测试 ===\n');
rgb = imread('peppers.png');    % 任意彩色图像
rgb2 = process_rgb_channels(rgb);

fprintf('原 RGB 图尺寸：%d x %d x %d\n', size(rgb,1), size(rgb,2), size(rgb,3));
fprintf('处理后 RGB 图尺寸：%d x %d x %d\n', size(rgb2,1), size(rgb2,2), size(rgb2,3));

figure;
subplot(1,2,1); imshow(rgb);  title('原 RGB 图');
subplot(1,2,2); imshow(rgb2); title('RGB 各通道处理后');

%% 3. 在 HSI 中只处理 I 分量 (process_hsi_intensity)
% 注意：这里默认 rgb2hsi / hsi2rgb 函数是别的同学/老师提供的，
% 你只需要保证 process_hsi_intensity 这个“调用逻辑”正确。

fprintf('\n=== 3. HSI 中只处理 I 分量 测试 ===\n');
rgb3 = process_hsi_intensity(rgb);

fprintf('处理前后图像尺寸一致性检查：%d\n', isequal(size(rgb), size(rgb3)));

figure;
subplot(1,2,1); imshow(rgb);  title('原 RGB 图');
subplot(1,2,2); imshow(rgb3); title('HSI 中调整 I 分量后');

%% 4. Huffman 编码 / 解码 (mat2huff / huff2mat)

fprintf('\n=== 4. Huffman 编码/解码 测试 ===\n');
G = imread('cameraman.tif');       % 灰度图 (uint8)

H = mat2huff(G);                   % 你写的 Huffman 编码
G_rec = huff2mat(H);               % 解码

ok_huff = isequal(G, G_rec);
fprintf('Huffman 解码是否与原图完全一致：%d\n', ok_huff);

bits_raw   = numel(G) * 8;         % 原始按 8bit 像素
bits_huff  = numel(H.bitstream);   % 霍夫曼码长度
ratio_huff = bits_raw / bits_huff;

fprintf('原始比特数 = %d\n', bits_raw);
fprintf('Huffman 后比特数 = %d\n', bits_huff);
fprintf('Huffman 压缩比 (raw/huff) = %.3f\n', ratio_huff);

%% 5. 预测编码 / 解码 + 预测残差 Huffman 编码

fprintf('\n=== 5. 预测编码 + Huffman 测试 ===\n');

% 5.1 预测编码 + 解码
E = pred_encode(G, 'left');        % 或 'average'
G_pred_rec = pred_decode(E);

ok_pred = isequal(G, G_pred_rec);
fprintf('预测解码是否与原图完全一致：%d\n', ok_pred);

% 5.2 观察预测误差分布
figure;
histogram(double(E.residual(:)));
title('预测误差分布 (pred\_encode residual)');
xlabel('预测误差值'); ylabel('频数');

% 5.3 对预测误差做 Huffman 编码
% residual 是 int16，为了复用 mat2huff，偏移成非负整数
res_shift = uint16(E.residual + 32768);   % [-32768,32767] -> [0,65535]

H_res = mat2huff(res_shift);
len_predH = numel(H_res.bitstream);

fprintf('预测误差 Huffman 码比特数 = %d\n', len_predH);
fprintf('原图 Huffman 码比特数     = %d\n', bits_huff);
fprintf('预测+Huffman 压缩增益 (原图Huff / 残差Huff) = %.3f\n', ...
        bits_huff / len_predH);

fprintf('\n=== 测试完成 ===\n');
