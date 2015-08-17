function RGBspace(stim, samplesize, mask)
% RGBspace(stim, samplesize = 2000)
%

    H = size(stim, 1);
    W = size(stim, 2);
    
    if nargin < 3
        mask = true(H, W);
    end

    if nargin < 2
        samplesize = 2000;
    end

    rgbs = double(reshape(stim, [H*W size(stim, 3)])) / 255;
    ind = reshape(mask, [H*W 1]);

    rgbs = rgbs(ind,:);

    ind = randsample(size(rgbs, 1), samplesize);

    scatter3(rgbs(ind,1), rgbs(ind,2), rgbs(ind,3), 10, rgbs(ind,:), 'fill');
    xlabel('red');
    ylabel('green');
    zlabel('blue');

end

