function pcim = image2pc(im, nPc, mask)
% image2pc(im, nPc, mask)
%
% returned pcim is normalized and in the uint8 format
%
% 2013-03-21 
%

    if iscell(im)
        pcim = cell(length(im), 1);
        for i = 1:length(im);
            pcim{i} = image2pc(im{i}, nPc);
        end
        return;
    end

    if nargin < 3
        mask = ~isnan(im(:,:,1));
    end

    if nargin < 2
        nPc = 1;
    end

    if isinteger(im)
        im = im2double(im);
    end

    h = size(im, 1);
    w = size(im, 2);

    values = reshape(im, h*w, size(im,3));
    validind = find(mask);

    validVal = values(validind, :);

    [coeff, score] = princomp(validVal);

    pc = validVal * coeff(:,1:nPc);
    pc = mapminmax(pc', 0, 1)';

    % masked pixel still be zero in the pcim
    pcim = zeros(h*w, nPc);

    pcim(validind, :) = pc;
    pcim = reshape(pcim, h, w, nPc);

    %pcim = im2uint8(pcim);

end
