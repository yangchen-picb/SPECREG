function [reducedim, mask, backod] = background_correction(stim, distThreshold, rgbThreshold)
% segmentation/background_subtraction of stained image, 
% pixel brighter than rgbThreshold will be regard as background 
% rgbThreshold = [] will estimate the threshold by Ostu method
%
% [reducedim, mask] = background_correction(stim, distthreshold = 0.01, rgbThreshold = [])
%

% 2013-03-20
% 2013-03-28 handle when norm(backod) = 0
% 2014-07-18 using Ostu method for rgbThreshold
%

    if nargin < 3
        rgbThreshold = [];
    end

    if nargin < 2
        distThreshold = 0.01;
    end

    H = size(stim, 1);
    W = size(stim, 2);
    
    rgbs = double(reshape(stim, [H * W size(stim, 3)]));
    
    if isempty(rgbThreshold)
        rlevel = graythresh(stim(:,:,1));
        glevel = graythresh(stim(:,:,2));
        blevel = graythresh(stim(:,:,3));
        level = max([rlevel, glevel, blevel]);
        %level = graythresh(rgb2gray(stim));
        %rlevel = level; glevel = level; blevel = level;
        %rbw = im2bw(stim(:,:,1), rlevel);
        %gbw = im2bw(stim(:,:,2), glevel);
        %bbw = im2bw(stim(:,:,3), blevel);
        %mask = (rbw & gbw & bbw);
        mask = im2bw(stim, level);
        backind = mask(:);
    else
        backind = (rgbs(:,1) > rgbThreshold(1)) & (rgbs(:,2) > rgbThreshold(2)) & (rgbs(:,3) > rgbThreshold(3));
    end

    if numel(backind) == 0
        warning('cannot find any background, try smaller threshold.');
        reducedim = stim;
        mask = zeros(size(stim,1), size(stim,2));
        return;
    end
    
    backrgbs = rgbs(backind, :);

    backcolor = mode(backrgbs);

    ods = -log10((rgbs + 1) / 256);

    backod = -log10((double(backcolor) + 1) / 256);

    ods = ods - repmat(backod, [H*W 1]);

    if norm(backod) > 0

    backod = backod / norm(backod);
    % the euclidean distance to the backod vector (deduced)
    distVec = sqrt(sum((ods .^ 2)') - sum((repmat(backod, [H*W 1]) .* ods)') .^ 2);

    try
        figure; ODspace(stim, 2048);
        hold on;
        line([0; backod(1)], [0; backod(2)], [0; backod(3)], 'color', 'red');
        %[x, y, z] = cylinder2([0; backod(1)], [0; backod(2)], [0; backod(3)], [distThreshold; distThreshold], 10);
        %mesh(x, y, z);
        hold off;
    catch
    end

    backind = backind | distVec' < distThreshold;

    end % norm

    ods(backind, :) = repmat([0 0 0], [sum(backind) 1]);
    odim = reshape(ods, [H W size(stim, 3)]);
    reducedim = OD2RGB(odim);

    mask = reshape(~backind, [H W]);

end

