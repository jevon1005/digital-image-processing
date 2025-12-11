function rgb = gray2pseudo_hsi(grayImg)
%GRAY2PSEUDO_HSI  用 HSI 模型将灰度图转换为伪彩色图
%   输入：grayImg - 灰度图，uint8/uint16/double
%   输出：rgb      - 伪彩色 RGB 图，double，[0,1]

    I = im2double(grayImg);           % 亮度分量
    H = I;                            % 灰度越大，色调越往后转
    S = ones(size(I));                % 饱和度设为 1（最鲜艳）

    hsi = cat(3, H, S, I);
    rgb = hsi2rgb(hsi);
end
