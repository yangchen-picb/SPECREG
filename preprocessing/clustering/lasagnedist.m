function dv = lasangedist(x, X, alpha)
% dv = lasangedist(x, X, alpha)
%

    if nargin < 3
        alpha = 2;
    end
    if isempty(alpha)
        alpha = 2;
    end

    n = size(X,1);
    t = 1 - abs(repmat(x, [n 1]) - X).^alpha;
    dv = (1 - prod(t'))';

end

