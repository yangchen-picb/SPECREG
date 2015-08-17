function [imArray, maskArray, tauArray] = cutout(fullim, fullmask, n, siz, alim, validThres)
% randomly cutout 'n' subimage with size 'siz' in 'fullim'
% [imArray, maskArray, tauArray] = cutout(fullim, fullmask, n/tauArray, siz, alim, validThres)
%

% 2013-10-29
    
    if nargin < 6
        validThres = 0.6;  % reject the cutout that more than 'validThres' pixels are background 
    end
    if nargin < 5
        alim = [-180 180];
    end
    if nargin < 4
        siz = [180 320];
    end

    if ~isscalar(n)
        tauArray = n;
        n = size(tauArray,1);
        imArray = cell(n, 1);
        maskArray = cell(n, 1);
        for ii = 1:size(tauArray,1)
            tau = tauArray(ii,:);
            theta = tau2theta(tau);
            tim = subimage_by_theta(fullim, theta, siz);
            tmask = subimage_by_theta(fullmask, theta, siz);
            imArray{ii} = tim;
            maskArray{ii} = tmask;
        end
        return
    end
    
    tim = zeros(siz);
    tmask = false(siz);
    
    %[x, y] = meshgrid(1:siz(2), 1:siz(1));
    transform = RigidSpace(tim, fullim);
    transform.set_lim(tim, fullim, 1, alim);
    
    imArray = cell(n, 1);
    maskArray = cell(n, 1);
    tauArray = zeros(n, 3);
    % the implementation of the transform is not so perfect, compromise
    ii = 1;
    while ii <= n
        ii
        tau = transform.rand_tau(1);
        theta = tau2theta(tau);

        %{
        [fxx, fxy] = transform.mapping(x, y, tau);
        try
            ind = sub2ind(size(fullim), round(fxy), round(fxx));
        catch
            continue;
        end
        tim(:) = fullim(ind);
        tmask(:) = fullmask(ind);
        %}
        try
            tmask = subimage_by_theta(fullmask, theta, siz);
        catch
            disp 'wrong tau';
            continue;
        end
        if sum(tmask(:)) / numel(tmask) < validThres
            disp 'bad tau'
            continue;
        end
        tim = subimage_by_theta(fullim, theta, siz);
        imArray{ii} = tim;
        maskArray{ii} = tmask;
        tauArray(ii,:) = tau;
        ii = ii + 1;
    end
end

