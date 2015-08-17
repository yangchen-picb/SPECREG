function heim = RGB2HE(stim, stainvec, mask)
% heim = RGB2HE(stim, stainvec, mask)
%

    H = size(stim, 1);
    W = size(stim, 2);

    if nargin < 3
       mask = true(H, W); 
    end

    %[stim, mask] = background_correction(stim);

    rgbs = double(reshape(stim, [H*W 3])) / 255;
    ind = reshape(mask, [H*W 1]);
    rgbs = rgbs(ind,:);

    hes = rgbs * pinv(stainvec);

    heim = zeros([H*W, 2]);
    heim(ind,:) = hes;
    heim = reshape(heim, [H W 2]);

    heim(heim < 0) = 0;

end

