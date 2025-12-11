function outImg = process_hsi_intensity(inImg)
%PROCESS_HSI_INTENSITY  在 HSI 空间中只处理 I 分量
%   步骤：
%   1. RGB → HSI
%   2. 对 I 做灰度处理（例如直方图均衡）
%   3. H,S 不动，I 换成处理后的
%   4. HSI → RGB

    hsi = rgb2hsi(inImg);

    H = hsi(:,:,1);
    S = hsi(:,:,2);
    I = hsi(:,:,3);

    % 示例：对 I 做直方图均衡
    I8   = im2uint8(I);
    Ieq8 = histeq(I8);
    Ieq  = im2double(Ieq8);

    hsi2 = cat(3, H, S, Ieq);
    outImg = hsi2rgb(hsi2);
end
