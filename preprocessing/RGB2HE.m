function [heim, stainvec] = RGB2HE(stim, mask)
% [heim, stainvec] = RGB2HE(stim, mask)
%
% If mask if not given, background_correction will perform first.
% This function will not normalize the heim.
%
% 2013-03-23 do not include background_correction here.
%

    if nargin < 2
        [stim, mask] = background_correction(stim, 0.05);
    end

    %TODO: should put the RGB2OD outside.
    % CALL
    stainvec = findStainVectors(stim, mask);
    % CALL
    heim = estimateHE(stim, stainvec, mask);

end

