function Xrec = pred_decode(E)
%PRED_DECODE  图像预测解码（DPCM 还原）
%   Xrec = PRED_DECODE(E) 其中 E 是 PRED_ENCODE 的输出结构体

    res  = double(E.residual);
    mode = E.mode;
    M    = E.origSize(1);
    N    = E.origSize(2);

    Xrec = zeros(M, N);

    switch lower(mode)
        case 'left'
            for i = 1:M
                Xrec(i,1) = res(i,1);   % 第一列直接还原
                for j = 2:N
                    pred = Xrec(i,j-1);
                    Xrec(i,j) = res(i,j) + pred;
                end
            end

        case 'average'
            for i = 1:M
                for j = 1:N
                    if i == 1 && j == 1
                        Xrec(i,j) = res(i,j);
                    elseif i == 1
                        pred = Xrec(i,j-1);
                        Xrec(i,j) = res(i,j) + pred;
                    elseif j == 1
                        pred = Xrec(i-1,j);
                        Xrec(i,j) = res(i,j) + pred;
                    else
                        pred = (Xrec(i,j-1) + Xrec(i-1,j)) / 2;
                        Xrec(i,j) = res(i,j) + pred;
                    end
                end
            end

        otherwise
            error('未知的预测模式：%s', mode);
    end

    % 还原到图像常用类型（这里假设原来是 8 位图，可以按需要调整）
    Xrec = uint8(max(min(Xrec, 255), 0));
end
