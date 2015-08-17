function [mask, gray] = badsortout(C, WN, tails)
% [D, mask, gray] = badsortout(C, WN)
% bad spectra sorting out function using graythresh 

if nargin < 3
    % [1/1000, 1/3] is for zoom in the dark part, we assume at least 1/3 of the image is foreground
    tails = [1/1000, 1/3];
end

[m,n,p]=size(C);
%[C]=reduce_points(C, WN, 950, 1790, 200);

D=reshape(C,m*n,p);

%% sum and trapz makes no difference and sum is faster
intt = sum(D(:,(WN>950) & (WN<1790)), 2);
%intt = sum(C, 3);  % use all wavenumbers seems to be more robust
                   % why not abs, just not necc
%{
% baseline correction
[~, ord] = sort(sum(D, 2));
imin = round(1/1000 * m * n);
baseline = mean(D(ord(1:imin),:));
%intt = sum(D, 2);
%sD = sort(D);
%baseline = mean(sD(1:imin,:));
D = D - repmat(baseline, [m*n 1]);
intt = sum(D.*D, 2);
%}
gr = rescalegd(intt, tails);
level = graythresh(gr);
mask = im2bw(gr, level);

%%% the manually threshold is really not proper
%%% <1 and >2* is not always work
%%% >2* is too small, >2.5* is no difference
%int_ind=trapz(D(:,(1625<WN) == (WN<1696)),2);
%D(int_ind<1,:)=NaN;
%D(int_ind>(2*mean(int_ind)),:)=NaN;
%mask = mask & ~(int_ind>(2.5*mean(int_ind)));

%%% this SNR criteron generates too small holes, which will be eliminated on latter morphological process anyway.
%signal = var(D(:,(1625<WN) == (WN<1696)),[],2);
%noise = var(D(:,(1799<WN) == (WN<1993)),[],2);
%s2n = 10*log10( signal ./ noise );
%D(s2n<(mean(s2n(~isnan(s2n)))/2),:)=NaN;
%mask = mask & ~(s2n<(mean(s2n(~isnan(s2n)))/2));

%D(~mask,:) = NaN;
%D = reshape(D, m, n, p);
mask = reshape(mask, m, n);
gray = reshape(intt, m, n);

