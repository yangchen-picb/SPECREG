function trim = transform_image(mvim, fxim, tau, backcolor)
% trim = transform_image(mvim, fxim, tau, backcolor = 0)
% transform the mving image given the transformation parameters tau and the fixed image is needed for size information
%
% if input mvim is colored image, it should be in uint8 format

% 2013-10-29
% 2014-10-07 add color support

% TODO: depend on the backind?

if nargin < 4
    backcolor = 0;
end
    
    trim = zeros(size(fxim));

    % for color images
    iscolor = false;
    if size(mvim, 3) > 1
        rgbs = reshape(mvim, [size(mvim,1)*size(mvim,2) size(mvim,3)]);
        mvim = sum(mvim, 3);
        iscolor = true;
    end
    
    transform = SimilaritySpace(mvim, fxim);
        
    [fxx, fxy] = meshgrid(1:size(fxim,2), 1:size(fxim,1));
    [mvx, mvy] = transform.back_mapping(fxx, fxy, tau);
    
    rx = round(mvx); ry = round(mvy);
    validind = ~(rx < 1 | ry < 1 | rx > size(mvim,2) | ry > size(mvim,1));
    ind = sub2ind(size(mvim), ry(validind), rx(validind));
    
    trim(validind) = mvim(ind);

    % for color images
    if iscolor
        trim = backcolor * ones(size(fxim,1)*size(fxim,2), size(rgbs,2));
        trim(validind,:) = rgbs(ind,:);
        trim = reshape(trim, [size(fxim,1) size(fxim,2) size(rgbs,2)]);
        trim = uint8(trim);
    end
    
end

