function plotPlane(A, range)
% plotPlane(A, range)
% 
% A * [x y z 1]' = 0
%

    if nargin < 2
        range = 0:0.1:1;
    end

    a = A(1);
    b = A(2);
    c = A(3);
    d = A(4);

    % TODO: if c = 0

    [x, y] = meshgrid(range, range);
    z = -(a*x + b*y + d) / c;

    mesh(x, y, z)

end
 
