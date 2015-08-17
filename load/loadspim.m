function [spim, spmask] = loadspim(sample, id)
% spim = loadspim(sample, id = 'all')
%
% if id is a vector, return a cell array.
%

    if nargin < 2
        id = [];
    end

    disp '  loading spectral images';

    C = load(['spim_' sample]);
    spim = C.spimArray;
    spmask = C.spmaskArray;

    if isscalar(id)
        spim = spim{id};
        spmask = spmask{id};
    end

    disp '  finish loading spectral images';

end
