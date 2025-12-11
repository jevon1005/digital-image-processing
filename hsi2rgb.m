function rgb = hsi2rgb(hsi)
%HSI2RGB  将 HSI 图像转换回 RGB 空间
%   输入：hsi  - M×N×3，double，H,S,I ∈ [0,1]
%   输出：rgb  - M×N×3，double，R,G,B ∈ [0,1]

    H = hsi(:,:,1) * 2*pi;  % 还原到 [0,2π]
    S = hsi(:,:,2);
    I = hsi(:,:,3);

    % 预分配
    R = zeros(size(I));
    G = zeros(size(I));
    B = zeros(size(I));

    % ---------- RG 区：0 ≤ H < 2π/3 ----------
    idx = (H >= 0) & (H < 2*pi/3);
    if any(idx(:))
        B(idx) = I(idx) .* (1 - S(idx));
        R(idx) = I(idx) .* (1 + S(idx).*cos(H(idx))./ ...
                           (cos(pi/3 - H(idx)) + eps));
        G(idx) = 3*I(idx) - (R(idx) + B(idx));
    end

    % ---------- GB 区：2π/3 ≤ H < 4π/3 ----------
    idx = (H >= 2*pi/3) & (H < 4*pi/3);
    if any(idx(:))
        H2    = H(idx) - 2*pi/3;
        R(idx)= I(idx) .* (1 - S(idx));
        G(idx)= I(idx) .* (1 + S(idx).*cos(H2)./ ...
                           (cos(pi/3 - H2) + eps));
        B(idx)= 3*I(idx) - (R(idx) + G(idx));
    end

    % ---------- BR 区：4π/3 ≤ H < 2π ----------
    idx = (H >= 4*pi/3) & (H < 2*pi);
    if any(idx(:))
        H3    = H(idx) - 4*pi/3;
        G(idx)= I(idx) .* (1 - S(idx));
        B(idx)= I(idx) .* (1 + S(idx).*cos(H3)./ ...
                           (cos(pi/3 - H3) + eps));
        R(idx)= 3*I(idx) - (G(idx) + B(idx));
    end

    rgb = cat(3, R, G, B);
    rgb = max(min(rgb,1),0);   % 裁剪到 [0,1]
end
