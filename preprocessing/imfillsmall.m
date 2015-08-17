function bw = imfillsmall(bw, thres)
% bw = imfillsmall(bw, areathres = [10 10])
% fill small holes of background and foreground
% areathres = [thres_for_background, thres_for_foreground], 0 means do not perform on background or foreground

% 2014-10-16

if nargin < 2
    thres = [100 100];
end

if isscalar(thres)
    thres = thres * ones(1, 2);
end


% fill small background
if thres(1) > 0
    cc = bwconncomp(~bw, 4);
    stats = regionprops(cc, 'area', 'pixelidxlist');
    rgn = stats([stats.Area] < thres(1));
    bw(cat(1, rgn.PixelIdxList)) = true;
end

% fill small foreground
if thres(2) > 0
    cc = bwconncomp(bw, 4);
    stats = regionprops(cc, 'area', 'pixelidxlist');
    rgn = stats([stats.Area] < thres(2));
    bw(cat(1, rgn.PixelIdxList)) = false;
end
