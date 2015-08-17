function heim = RGB2HE(stim, stainvec, mask)
% heim = RGB2HE(stim, stainvec, mask)
%

    H = size(stim, 1);
    W = size(stim, 2);

    if nargin < 3
       mask = true(H, W); 
        %[stim, mask] = background_correction(stim, 0.05);
    end

    odim = RGB2OD(stim);

    ods = reshape(odim, [H*W 3]);
    ind = reshape(mask, [H*W 1]);
    ods = ods(ind,:);

    hes = ods * pinv(stainvec);

    heim = zeros([H*W, 2]);
    heim(ind,:) = hes;
    heim = reshape(heim, [H W 2]);

    heim(heim < 0) = 0;

end

