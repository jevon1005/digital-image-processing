function reconstructed =filteredBackProjectionRecon(R, theta)
%% back_projection.m - 反投影重建
% 输入: R - Radon变换结果
%       theta - 投影角度数组
% 输出: reconstructed - 重建图像

% 使用iradon进行滤波反投影重建
fprintf('进行反投影重建...\n');
fprintf('  可用滤波器: ram-lak, shepp-logan, cosine, hamming, hann, none\n');

% 正确的滤波器名称
filters = {'ram-lak', 'shepp-logan', 'cosine', 'hamming', 'hann'};
num_filters = length(filters);

figure('Name', '反投影重建比较', 'NumberTitle', 'off', 'Position', [100, 100, 1400, 800]);

for i = 1:num_filters
    current_filter = filters{i};
    
    % 执行反投影重建
    tic;
    reconstructed = iradon(R, theta, 'linear', current_filter);
    elapsed_time = toc;
    
    % 显示重建结果
    subplot(2, 3, i);
    imshow(reconstructed, []);
    title(sprintf('%s滤波器\n重建时间: %.2f秒', current_filter, elapsed_time));
    
    % 计算重建质量指标
    if i == 1  % 使用ram-lak滤波器作为参考
        reference = reconstructed;
    end
    
    % 输出信息
    fprintf('  滤波器: %-15s | 时间: %.3f秒 | 尺寸: %dx%d\n', ...
            current_filter, elapsed_time, size(reconstructed, 1), size(reconstructed, 2));
end

% 显示原始投影数据
subplot(2, 3, 6);
imshow(R, [], 'XData', theta);
xlabel('\theta (度)');
ylabel('距离');
title('原始投影数据');
colormap(gca, hot);
colorbar;

% 比较不同滤波器的效果
figure('Name', '重建图像剖面线比较', 'NumberTitle', 'off');

% 获取中心行剖面
center_row = floor(size(reconstructed, 1)/2);
profiles = zeros(size(reconstructed, 2), num_filters);

for i = 1:num_filters
    temp_recon = iradon(R, theta, 'linear', filters{i});
    profiles(:, i) = temp_recon(center_row, :)';
end

% 绘制剖面线
plot(1:size(profiles, 1), profiles, 'LineWidth', 1.5);
xlabel('像素位置');
ylabel('灰度值');
title(sprintf('重建图像中心行剖面线 (第%d行)', center_row));
legend(filters, 'Location', 'best');
grid on;

% 显示星状伪迹分析
figure('Name', '星状伪迹分析', 'NumberTitle', 'off');
recon_none = iradon(R, theta, 'linear', 'none');  % 无滤波器
recon_ramlak = iradon(R, theta, 'linear', 'ram-lak');   % ram-lak滤波器

subplot(2,2,1);
imshow(recon_none, []);
title('无滤波器 - 存在星状伪迹');

subplot(2,2,2);
imshow(recon_ramlak, []);
title('Ram-lak滤波器 - 减少星状伪迹');

subplot(2,2,3);
imhist(uint8(mat2gray(recon_none) * 255));
title('无滤波器的直方图');

subplot(2,2,4);
imhist(uint8(mat2gray(recon_ramlak) * 255));
title('有滤波器的直方图');

% 计算重建质量指标
fprintf('\n重建质量比较:\n');
for i = 1:num_filters
    temp_recon = iradon(R, theta, 'linear', filters{i});
    % 计算图像熵
    entropy_val = entropy(temp_recon);
    % 计算对比度
    contrast_val = std(temp_recon(:));
    
    fprintf('  滤波器: %-12s | 熵: %.4f | 对比度: %.4f\n', ...
            filters{i}, entropy_val, contrast_val);
end

fprintf('\n反投影重建完成!\n');
fprintf('  最佳滤波器推荐: ram-lak 或 shepp-logan\n');
fprintf('  滤波器作用: 减少星状伪迹，提高重建质量\n');
end