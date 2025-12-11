function H = mat2huff(X)
%MAT2HUFF  对矩阵 X 进行霍夫曼编码
%   H = MAT2HUFF(X)
%   输入：
%       X - 任意数值 / 逻辑矩阵（灰度图、预测误差等）
%   输出结构体 H 包含：
%       H.origSize   原矩阵大小
%       H.symbols    符号集合（列向量）
%       H.codewords  每个符号对应的霍夫曼码（cell 数组里的 '0''1' 字符串）
%       H.bitstream  整个矩阵编码后的比特流 (uint8 行向量，元素为 0 或 1)

    if ~(isnumeric(X) || islogical(X))
        error('X 必须是数值或逻辑矩阵。');
    end

    %----------------------------------------------------------
    % 1. 统计符号及其概率
    %----------------------------------------------------------
    origSize = size(X);
    x = X(:);                        % 展成一列

    [symbols, ~, idx] = unique(x);   % idx: 每个元素对应第几个 symbol
    counts = accumarray(idx, 1);
    p = counts / numel(x);

    nSym = numel(symbols);

    %----------------------------------------------------------
    % 2. 构造霍夫曼码字（不再用 struct 数组拼接）
    %    经典做法：维护“符号组 + 概率”的 cell 数组
    %----------------------------------------------------------
    % 每个基本符号是一个组，组里存的是它在 symbols 中的下标
    groupIndex = num2cell(1:nSym);      % 例如 { [1], [2], [3], ... }
    probs      = num2cell(p(:)');       % 每组对应的概率
    codes      = repmat({''}, 1, nSym); % 最终每个符号的码字初始化为空串

    if nSym == 1
        % 特殊情况：只有一个符号，就分配一个 '0'
        codes{1} = '0';
    else
        % 正常情况：每次取概率最小的两个组合并
        while numel(probs) > 1
            % 找出概率最小的两个组
            [~, order] = sort(cell2mat(probs));
            i1 = order(1);          % 概率最小
            i2 = order(2);          % 第二小

            % 这两个组里各自的符号 index
            g1 = groupIndex{i1};
            g2 = groupIndex{i2};

            % 对组1里的符号代码前面加 '0'
            for k = g1
                codes{k} = ['0' codes{k}];
            end
            % 对组2里的符号代码前面加 '1'
            for k = g2
                codes{k} = ['1' codes{k}];
            end

            % 合并这两个组
            groupIndex{i1} = [g1 g2];
            probs{i1}      = probs{i1} + probs{i2};

            % 删除第二小的组
            groupIndex(i2) = [];
            probs(i2)      = [];
        end
    end

    % 把 codes 变为列向量形式（和 symbols 对应）
    codewords = codes(:);

    %----------------------------------------------------------
    % 3. 根据码字表，把整幅图编码成比特流
    %----------------------------------------------------------
    % 对于 x 中的每个元素，找到它对应的码字，然后全部拼接
    strCodes = strings(numel(x), 1);
    for k = 1:numel(x)
        strCodes(k) = string(codewords{idx(k)});
    end

    bigStr = join(strCodes, "");      % "010101..." 的长串
    bigStr = char(bigStr);           % char 行向量

    bitstream = uint8(bigStr - '0'); % '0'->0, '1'->1

    %----------------------------------------------------------
    % 4. 打包输出
    %----------------------------------------------------------
    H.origSize  = origSize;
    H.symbols   = symbols;
    H.codewords = codewords;
    H.bitstream = bitstream;
end
