function E = pred_encode(X, mode)
%PRED_ENCODE  图像预测编码（DPCM）
%   E = PRED_ENCODE(X) 对灰度图像 X 做一阶预测编码（左邻预测）
%   E = PRED_ENCODE(X, MODE) 可以指定预测模式：
%       MODE = 'left'     使用左邻像素作为预测（默认）
%       MODE = 'average'  使用左邻和上邻的平均值作为预测
%
%   输出结构体 E 包含：
%       E.residual   预测误差图（int16）
%       E.mode       使用的预测模式
%       E.origSize   原图尺寸

    if nargin < 2
        mode = 'left';
    end

    if ndims(X) ~= 2
        error('这里的预测编码假定 X 为灰度图（二维矩阵）。彩色图可对每个通道分别调用。');
    end

    X = double(X);
    [M, N] = size(X);

    res = zeros(M, N);   % 预测误差

    switch lower(mode)
        case 'left'
            % 行内一维预测：x_hat(i,j) = x(i,j-1)
            for i = 1:M
                % 行首像素没有左邻，一般直接原样存储
                res(i,1) = X(i,1);
                for j = 2:N
                    pred = X(i,j-1);
                    res(i,j) = X(i,j) - pred;
                end
            end

        case 'average'
            % 简单二维预测：x_hat(i,j) = (左邻 + 上邻)/2
            for i = 1:M
                for j = 1:N
                    if i == 1 && j == 1
                        % 第一个像素没有邻域，直接存储
                        res(i,j) = X(i,j);
                    elseif i == 1      % 第一行，只能用左邻
                        pred = X(i,j-1);
                        res(i,j) = X(i,j) - pred;
                    elseif j == 1      % 第一列，只能用上邻
                        pred = X(i-1,j);
                        res(i,j) = X(i,j) - pred;
                    else
                        pred = (X(i,j-1) + X(i-1,j)) / 2;
                        res(i,j) = X(i,j) - pred;
                    end
                end
            end

        otherwise
            error('未知的预测模式：%s', mode);
    end

    E.residual = int16(res);   % 误差一般取 int16 足够
    E.mode     = mode;
    E.origSize = [M N];
end
