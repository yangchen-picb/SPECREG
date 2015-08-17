function ppoints = project_point2plane(points, A);
% ppoints = project_point2plane(points, A);
% 
%
    x = points(:,1);
    y = points(:,2);
    z = points(:,3);

    a = A(1); b = A(2); c = A(3); d = A(4);

    t = (a*x + b*y + c*z + d) / (a*a + b*b + c*c);

    ppoints = zeros(size(points));
    ppoints = [x - a*t, y - b*t, z - c*t];

end
