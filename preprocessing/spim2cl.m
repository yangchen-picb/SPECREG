function [clim, mask] = spim2cl(spim, nCl, mask)
% [clim, mask] = spim2cl(spim, nCl, mask)
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
    mask = ~isnan(spim(:,:,1));
end

h = size(spim,1);
w = size(spim,2);
values = double(reshape(spim, h*w, size(spim,3)));
validind = find(mask);

options.MaxIter = 1000;
options.Display = 'final';
%seeds = kmeanspp_seed(values(validind,:), nCl, 'correlation', 3);
%cl = kmeans(values(validind,:), nCl, 'Options', options, 'Start', seeds, 'EmptyAction', 'singleton', 'Distance', 'correlation');
cl = kmeans(values(validind,:), nCl, 'Options', options, 'EmptyAction', 'singleton','Replicates', 2, 'Distance', 'correlation');
%cl = kmeans(values(validind,:), nCl, 'Options', options, 'Start', 'uniform', 'EmptyAction', 'singleton', 'Distance', 'correlation','Replicates', 5);
%cl = kmeans(values(validind,:), nCl, 'Options', options, 'Start', 'cluster', 'EmptyAction', 'singleton', 'Distance', 'correlation','Replicates', 5);
%z = linkage(values(validind,:), 'ward', 'correlation');
%cl = cluster(z, nCl);

clim = zeros(h*w, 1);
clim(validind) = cl;

clim = reshape(clim, h, w);

end



