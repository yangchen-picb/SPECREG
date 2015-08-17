function A = threePoints2plane(points)
% plotPlane(points)
% 
% use three points to plot a plane
% each column of the points is a point
%
% ax+by+cz+d=0
%

    p1 = points(:,1);
    p2 = points(:,2);
    p3 = points(:,3);

    x1 = p1(1); y1 = p1(2); z1 = p1(3);
    x2 = p2(1); y2 = p2(2); z2 = p2(3);
    x3 = p3(1); y3 = p3(2); z3 = p3(3);

    a = ( (y2-y1)*(z3-z1)-(z2-z1)*(y3-y1) );
    b = ( (z2-z1)*(x3-x1)-(x2-x1)*(z3-z1) );
    c = ( (x2-x1)*(y3-y1)-(y2-y1)*(x3-x1) );
    d = ( 0-(a*x1+b*y1+c*z1) );

    A = [a b c d];

end
