function stpart = loadstpart(id)
% stpart = loadstpart(id)
%
%

    if nargin < 1
        id = 1:7;
    end

    % trueTheta
    load trueTheta_of_Wi73501_with_scaled_stim.mat trueTheta

    % stim
    stim = loadstim('Wi73501', true);
    [stim, stMask] = background_correction(stim);

    % spim
    spim = loadspim('Wi73501');
    siz = allsize(spim, 2);

    stpart = cell(length(id), 1);
    for i = 1:length(id)
        stpart{i} = subimage_by_theta(stim, trueTheta(:,id(i)), siz(id(i),:));
    end

    if length(id) == 1
        stpart = stpart{1};
    end
end
