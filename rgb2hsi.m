function hsi = rgb2hsi(rgb)
%RGB2HSI  将 RGB 图像转换为 HSI 空间
%   输入：rgb  - M×N×3，uint8/uint16/double 均可
%   输出：hsi  - M×N×3，double，H,S,I 均在 [0,1]

    rgb = im2double(rgb);

    R = rgb(:,:,1);
    G = rgb(:,:,2);
    B = rgb(:,:,3);

    num   = 0.5*((R - G) + (R - B));
    den   = sqrt((R-G).^2 + (R-B).*(G-B)) + eps;
    theta = acos(num ./ den);

    H = theta;
    H(B > G) = 2*pi - H(B > G);
    H = H / (2*pi);

    minRGB = min(min(R,G),B);
    sumRGB = R + G + B;
    S      = 1 - 3 .* minRGB ./ (sumRGB + eps);
    S(sumRGB == 0) = 0;

    I = sumRGB / 3;

    hsi = cat(3, H, S, I);
end
