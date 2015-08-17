function ODspace(stim, samplesize, mask)
% ODspace(stim, samplesize = 2000)
%

    H = size(stim, 1);
    W = size(stim, 2);

    if nargin < 3
        mask = true(H, W);
    end

    if nargin < 2
        samplesize = 2000;
    end

    odim = RGB2OD(stim);

    rgbs = reshape(stim, [H*W size(stim, 3)]);
    ods = reshape(odim, [H*W size(odim, 3)]);
    ind = reshape(mask, [H*W 1]);

    ods = ods(ind,:);
    rgbs = rgbs(ind,:);

    ind = randsample(size(ods, 1), samplesize);

    scatter3(ods(ind,1), ods(ind,2), ods(ind,3), 10, double(rgbs(ind,:)) / 255, 'fill');

    xlabel('red', 'fontsize', 30);
    ylabel('green', 'fontsize', 30);
    zlabel('blue', 'fontsize', 30);

end

