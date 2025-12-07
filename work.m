%% work.m  主脚本：彩色/灰度自适应 + 5/6 种变换
clear all; close all; clc;

%% 1. 读入并自动判别
file = '1.png';       % 可换成任意路径
I = imread(file);

% 判别是否为灰度
if ndims(I)==2 || (ndims(I)==3 && size(I,3)==1)
    isGray = true;
    Igray = I;
    if ndims(I)==3, Igray = squeeze(I); end
else
    isGray = false;      % 真彩色
    Igray = rgb2gray(I);
end
Igray = im2double(Igray);

%% 2. 灰度图统一做三种投影重建
theta = 0:179;
[R, rho] = radon(Igray, theta);        % Radon
% 2.1 正弦图
figure; imagesc(theta, rho, R); axis xy; colormap(gray); colorbar;
xlabel('角度 (°)'); ylabel('ρ'); title('Radon 变换（正弦图）');

% 2.2 傅里叶切片定理（45°）
ang  = 45;
proj = radon(Igray, ang);
F1   = fftshift(fft(proj(:)));
F2   = fft2(Igray);
[M,N] = size(Igray);
[U,V] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
omega = linspace(-pi, pi, length(F1));
slice = interp2(U,V,abs(F2), omega*cosd(ang), omega*sind(ang));
figure; plot(abs(F1),'r-','LineWidth',2); hold on;
plot(slice,'b--','LineWidth',1.5); grid on;
legend('投影一维 FFT','二维 FFT 切片'); title('傅里叶切片定理验证（45°）');

% 2.3 滤波反投影重建
Irec = iradon(R, theta, 'linear', 'Ram-Lak', 1, size(Igray,1));
figure;
subplot(1,2,1); imshow(Igray,[]); title('原灰度图');
subplot(1,2,2); imshow(Irec,[]); title('滤波反投影重建');

%% 3. 彩色/灰度分支显示
if ~isGray          % --------- 彩色图分支 ---------
    % 3.1 RGB 原图
    figure; imshow(I); title('RGB 原图');
    % 3.2 RGB↔HSI
    hsi = rgb2hsi(I);
    figure;
    subplot(1,3,1); imshow(hsi(:,:,1),[]); title('H 通道');
    subplot(1,3,2); imshow(hsi(:,:,2),[]); title('S 通道');
    subplot(1,3,3); imshow(hsi(:,:,3),[]); title('I 通道');
    Ihsi2rgb = hsi2rgb(hsi);
    figure; imshow(Ihsi2rgb); title('HSI→RGB 复原图');
    % 3.3 灰度假彩色
    RGBpseudo = hsi2rgb(cat(3,Igray,ones(size(Igray)),Igray));
    figure;
    subplot(1,2,1); imshow(Igray,[]); title('灰度图');
    subplot(1,2,2); imshow(RGBpseudo); title('密度分割伪彩色（HSI 色环）');
else                % --------- 灰度图分支 ---------
    % 直接做 5 种变换
    figure; imshow(Igray,[]); title('原灰度图');   % 相当于“RGB 显示”
    RGBpseudo = hsi2rgb(cat(3,Igray,ones(size(Igray)),Igray));
    figure; imshow(RGBpseudo); title('密度分割伪彩色（HSI 色环）');
end

%% ----------  局部函数  ----------
function hsi = rgb2hsi(rgb)
    rgb = im2double(rgb);
    R = rgb(:,:,1); G = rgb(:,:,2); B = rgb(:,:,3);
    I = (R+G+B)/3;
    S = 1 - 3.*min(min(R,G),B)./(R+G+B+eps);
    num = 0.5*((R-G)+(R-B));
    den = sqrt((R-G).^2 + (R-B).*(G-B));
    theta = acos(num./(den+eps));
    H = theta;  H(B>G) = 2*pi - H(B>G);  H = H/(2*pi);
    hsi = cat(3,H,S,I);
end

function rgb = hsi2rgb(hsi)
    H = hsi(:,:,1)*2*pi; S = hsi(:,:,2); I = hsi(:,:,3);
    R = zeros(size(H)); G = R; B = R;
    idx = (0<=H)&(H<2*pi/3);
    B(idx) = I(idx).*(1-S(idx));
    R(idx) = I(idx).*(1 + S(idx).*cos(H(idx))./cos(pi/3-H(idx)));
    G(idx) = 3*I(idx)-(R(idx)+B(idx));
    idx = (2*pi/3<=H)&(H<4*pi/3);
    H2 = H(idx)-2*pi/3;
    R(idx) = I(idx).*(1-S(idx));
    G(idx) = I(idx).*(1 + S(idx).*cos(H2)./cos(pi/3-H2));
    B(idx) = 3*I(idx)-(R(idx)+G(idx));
    idx = (4*pi/3<=H)&(H<=2*pi);
    H2 = H(idx)-4*pi/3;
    G(idx) = I(idx).*(1-S(idx));
    B(idx) = I(idx).*(1 + S(idx).*cos(H2)./cos(pi/3-H2));
    R(idx) = 3*I(idx)-(G(idx)+B(idx));
    rgb = cat(3,R,G,B);
    rgb = max(min(rgb,1),0);
end