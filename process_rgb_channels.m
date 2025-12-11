function outImg = process_rgb_channels(inImg)
%PROCESS_RGB_CHANNELS  分别对 RGB 三通道做灰度处理
%   这里示例：对每个通道做直方图均衡（可以换成任意灰度变换）

    if ~isa(inImg,'uint8')
        inImg = im2uint8(inImg);
    end

    R = inImg(:,:,1);
    G = inImg(:,:,2);
    B = inImg(:,:,3);

    % ==== 在这里放你想要的灰度处理 ====
    R2 = histeq(R);      % 例子：直方图均衡
    G2 = histeq(G);
    B2 = histeq(B);
    % ===================================

    outImg = cat(3,R2,G2,B2);
end
