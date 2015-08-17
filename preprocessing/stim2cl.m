function [clim, sumdist] = stim2cl(stim, nCl, mask)
% clim = stim2cl(stim, nCl, mask)
%
% pre-segment the stained image using kmeans clustering
% 
% masked value will be an independent class
% returned image will be index image with 0 as masked
% due to the mask, the returned index image will have nCl+1 indexes
%

% 2013-04-22
% 2013-11-20
%

if nargin < 3
    mask = ones(size(stim,1), size(stim,2));
end

if isinteger(stim)
    im = im2double(stim);
end

h = size(stim,1);
w = size(stim,2);
values = double(reshape(stim, h*w, size(stim,3)));
validind = find(mask);

options.MaxIter = 1000;
options.Display = 'final';
%seeds = kmeanspp_seed(values(validind,:), nCl, [], 2);
[cl, ~, sumdist] = kmeans(values(validind,:), nCl, 'Options', options, 'Start', 'cluster', 'EmptyAction', 'singleton');
%[cl, ~, sumdist] = kmeans(values(validind,:), nCl, 'Options', options, 'Start', seeds, 'EmptyAction', 'singleton');
%[cl, ~, sumdist] = fkmeans(values(validind,:), nCl);

clim = zeros(h*w, 1);
clim(validind) = cl;

clim = reshape(clim, h, w);

end
