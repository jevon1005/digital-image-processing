function fourierSliceTheorem(I)
%% fourierSliceTheorem.m - 傅里叶切片定理演示
% 输入: I - 灰度图像

% 检查输入
if size(I, 3) > 1
    I = rgb2gray(I);
end

% 1. 对原始图像进行2D傅里叶变换（保留用于切片，但去掉显示）
F = fft2(double(I));
F_shifted = fftshift(F);  % 零频率移到中心
F_magnitude = log(1 + abs(F_shifted));  % 幅度谱

% 2. 计算不同角度的Radon变换
theta = [0, 30, 60, 90, 120, 150, 180];  % 增加180度
num_angles = length(theta);

figure('Name', '傅里叶切片定理演示', 'NumberTitle', 'off', 'Position', [100, 100, 1400, 900]);

% 新增：180度傅里叶切片图
% 提取180度的切片
angle_180_idx = 7;  % 180度是第7个角度
angle_180_rad = deg2rad(180);

% 创建极坐标网格
[M, N] = size(I);
[X, Y] = meshgrid(1:N, 1:M);
X_center = X - N/2 - 1;
Y_center = Y - M/2 - 1;

% 转换为极坐标
[THETA, RHO] = cart2pol(X_center, Y_center);

% 提取180度切片（容差±1度）
angle_tolerance = deg2rad(1);
slice_idx_180 = abs(THETA - angle_180_rad) < angle_tolerance | ...
                abs(THETA - angle_180_rad - 2*pi) < angle_tolerance | ...
                abs(THETA - angle_180_rad + 2*pi) < angle_tolerance;

% 获取切片数据
slice_data_180 = F_magnitude(slice_idx_180);
rho_slice_180 = RHO(slice_idx_180);

% 对rho进行排序并获取对应的slice值
[rho_sorted_180, sort_idx] = sort(rho_slice_180);
slice_sorted_180 = slice_data_180(sort_idx);

for i = 1:num_angles
    % 计算当前角度的投影
    current_theta = theta(i);
    [R, rho] = radon(I, current_theta);
    
    % 计算投影的1D傅里叶变换
    R_fft = fft(R);
    R_fft_shifted = fftshift(R_fft);
    R_fft_magnitude = log(1 + abs(R_fft_shifted));
    
    % 显示结果
    % 子图1: 原始图像和投影方向
    subplot(3, num_angles, i);
    imshow(I, []);
    hold on;
    % 绘制投影方向线
    center_x = size(I, 2)/2;
    center_y = size(I, 1)/2;
    line_length = min(size(I))/2;
    end_x = center_x + line_length * cosd(current_theta);
    end_y = center_y + line_length * sind(current_theta);
    plot([center_x, end_x], [center_y, end_y], 'r-', 'LineWidth', 2);
    plot(center_x, center_y, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    title(sprintf('投影角度: %d°', current_theta));
    hold off;
    
    % 子图2: 投影曲线
    subplot(3, num_angles, num_angles + i);
    plot(rho, R, 'b-', 'LineWidth', 1.5);
    xlabel('距离');
    ylabel('投影值');
    title(sprintf('%d°投影', current_theta));
    grid on;
    
    % 子图3: 1D傅里叶变换
    subplot(3, num_angles, 2*num_angles + i);
    freq = linspace(-0.5, 0.5, length(R_fft_magnitude));
    plot(freq, R_fft_magnitude, 'r-', 'LineWidth', 1.5);
    
    % 如果是180度，显示切片信息
    if current_theta == 180
        hold on;
        % 显示2D傅里叶变换的切片
        plot(rho_sorted_180/max(rho_sorted_180)*0.5, slice_sorted_180/max(slice_sorted_180)*max(R_fft_magnitude), ...
             'g--', 'LineWidth', 1.5, 'DisplayName', '2D FT切片');
        legend('投影1D FT', '2D FT切片', 'Location', 'best');
        hold off;
        title(sprintf('%d°傅里叶切片', current_theta));
    else
        title(sprintf('%d°投影1D FT', current_theta));
    end
    xlabel('归一化频率');
    ylabel('对数幅度');
    grid on;
end

% 输出定理验证结果
fprintf('\n傅里叶切片定理验证:\n');
fprintf('  定理内容: 投影的1D傅里叶变换 = 2D傅里叶变换沿同方向过原点的切片\n');
fprintf('  演示角度: ');
fprintf('%d° ', theta);
fprintf('\n');
fprintf('  已增加180度傅里叶切片图\n');
end