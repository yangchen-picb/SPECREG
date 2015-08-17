function [imscale] = rescalegd(im, tails)
% [imscale] = rescalegd(im, tails = [percentmin, percentmax] = [1/100, 1/100])
% get an image and scales it between 0 and 1

if nargin < 2
    tails = [1/100, 1/100];
end

im=double(im);
ss = sort(im(:));
imin = floor(tails(1) * numel(im));
imax = ceil((1-tails(2)) * numel(im));
imscale = mat2gray(im, [ss(imin) ss(imax)]);

