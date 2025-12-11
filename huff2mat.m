function X = huff2mat(H)
%HUFF2MAT  将 MAT2HUFF 生成的霍夫曼结构体解码为矩阵
%   X = HUFF2MAT(H)  其中 H 为 MAT2HUFF 的输出结构体

    symbols   = H.symbols;
    codewords = H.codewords;
    bits      = H.bitstream(:)';    % 行向量 0/1
    origSize  = H.origSize;

    nSym = numel(symbols);

    % 建一个字典：码字字符串 → 对应行号
    dictCodes = strings(1, nSym);
    for k = 1:nSym
        dictCodes(k) = string(codewords{k});
    end

    % 逐位扫描 bitstream，每当缓冲区里的比特串等于某个码字，就输出一个符号
    buf = "";
    outSymbols = [];                % 动态增长，对作业规模足够

    for b = bits
        buf = buf + string(num2str(b));   % 把 0/1 追加到缓冲区

        % 查看是否与某个码字完全匹配
        idx = find(dictCodes == buf, 1);
        if ~isempty(idx)
            outSymbols(end+1,1) = symbols(idx);  %#ok<AGROW>
            buf = "";
        end
    end

    % 重塑成原来的矩阵大小
    if numel(outSymbols) ~= prod(origSize)
        error('解码后的符号个数与原尺寸不匹配，可能 bitstream 有误。');
    end

    X = reshape(outSymbols, origSize);
end
