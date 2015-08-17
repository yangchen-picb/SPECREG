function HSVspace(stim, samplesize)
% HSVspace(stim, samplesize = 2000)
%

    if nargin < 2
        samplesize = 2000;
    end

    H = size(stim, 1);
    W = size(stim, 2);
    
    rgbs = reshape(stim, [H*W size(stim, 3)]);
    hsv = rgb2hsv(rgbs);

    ind = randsample(H*W, samplesize);

    scatter3(hsv(ind,1), hsv(ind,2), hsv(ind,3), 10, double(rgbs(ind,:)) / 255, 'fill');
    xlabel('hue');
    ylabel('saturate');
    zlabel('value');

end

