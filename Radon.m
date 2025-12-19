function [R, rho] = Radon(I)
%% radon_transform.m - Radon变换
% 输入: I - 灰度图像
% 输出: R - Radon变换结果
%       rho - 距离坐标

% 设置投影角度
theta = 0:179;  % 从0到179度

% 执行Radon变换
[R, rho] = radon(I, theta);

% 显示结果 - 改为3x3布局以容纳9个子图
figure('Name', 'Radon变换', 'NumberTitle', 'off', 'Position', [100, 100, 1400, 800]);

% 原始图像
subplot(3,3,1);
imshow(I, []);
title('原始图像');
xlabel(sprintf('尺寸: %dx%d', size(I,1), size(I,2)));

% 正弦图
subplot(3,3,2);
imshow(R, [], 'XData', theta, 'YData', rho);
xlabel('\theta (度)');
ylabel('x''');
title('Radon变换 - 正弦图');
colormap(gca, hot);
colorbar;

% 显示不同角度的投影（增加0, 30, 60, 90度）
subplot(3,3,3);
angles_to_show = [0, 30, 60, 90];
colors = {'r', 'g', 'b', 'm'};
hold on;
for i = 1:length(angles_to_show)
    idx = find(theta == angles_to_show(i));
    if ~isempty(idx)
        plot(rho, R(:, idx), colors{i}, 'LineWidth', 1.5, ...
             'DisplayName', sprintf('%d°', angles_to_show(i)));
    end
end
hold off;
xlabel('距离');
ylabel('投影值');
title('不同角度的投影曲线');
legend('show');
grid on;

% 新增：显示0, 30, 60, 90度的变换图
angles_display = [0, 30, 60, 90];
for i = 1:4
    subplot(3,3,3+i);  % 现在使用3x3布局，位置4-7
    current_angle = angles_display(i);
    idx = find(theta == current_angle);
    if ~isempty(idx)
        % 显示该角度的投影图像
        projection = R(:, idx);
        % 创建投影可视化图像
        proj_image = repmat(projection, 1, 50);  % 扩展成图像
        
        imshow(proj_image, []);
        title(sprintf('%d°投影图', current_angle));
        colorbar;
    else
        text(0.3, 0.5, sprintf('无%d°数据', current_angle));
        axis off;
    end
end

% 显示投影数据的统计信息（使用最后两个子图位置8和9）
subplot(3,3,8);
projection_mean = mean(R(:));
projection_std = std(R(:));
projection_max = max(R(:));
projection_min = min(R(:));

text(0.1, 0.9, sprintf('Radon变换统计:'), 'FontSize', 12, 'FontWeight', 'bold');
text(0.1, 0.7, sprintf('均值: %.2f', projection_mean), 'FontSize', 10);
text(0.1, 0.6, sprintf('标准差: %.2f', projection_std), 'FontSize', 10);
text(0.1, 0.5, sprintf('最大值: %.2f', projection_max), 'FontSize', 10);
text(0.1, 0.4, sprintf('最小值: %.2f', projection_min), 'FontSize', 10);
text(0.1, 0.3, sprintf('角度数: %d', length(theta)), 'FontSize', 10);
axis off;
title('统计信息');

% 显示角度分布信息
subplot(3,3,9);
% 计算每个角度的平均投影值
mean_projections = mean(R, 1);
plot(theta, mean_projections, 'b-', 'LineWidth', 1.5);
xlabel('角度 (°)');
ylabel('平均投影值');
title('各角度平均投影');
grid on;

% 输出信息
fprintf('Radon变换完成:\n');
fprintf('  投影角度范围: 0° - %d°\n', max(theta));
fprintf('  投影角度数: %d\n', length(theta));
fprintf('  正弦图尺寸: %d x %d\n', size(R, 1), size(R, 2));
fprintf('  特定角度: 0°, 30°, 60°, 90°变换图已显示\n');
end