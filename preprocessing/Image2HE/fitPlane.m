function [A, threepoints] = fitPlane(points, ori)
% [A, U] = fitPlane(points)
%
% A * [x y z 1]' = 0
%

    if nargin < 2
        ori = [0 0 0]';
    end

    % no V for saving the storage
    [U, S] = svd(points');

    threepoints = [ori U(:,1:2)];

    A = threePoints2plane(threepoints);

end

