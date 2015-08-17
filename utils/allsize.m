function siz = allsize(ca, d)
% siz = allsize(ca, d)
%
% get all the size of the elements from a cell array.
% d is dimension specified.
%
% 2013-03-12
%

    if nargin < 2
        d = 2;
    end

    N = numel(ca);

    siz = ones(N, d);
    
    for i =1:N
        s = size(ca{i});
        siz(i,:) = s(1:d);
    end
end
