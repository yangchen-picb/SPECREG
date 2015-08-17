function [alpha, cosa, ppoints] = test_planeFitting

    range = -1:0.1:1;

    sigma = 0.1

    samplesize = 1000;

    % a, b, c, d
    A = [1; 1; 1; 0];
    a = A(1);
    b = A(2);
    c = A(3);
    d = A(4);

    simdata = zeros(samplesize, 3);

    [x, y] = meshgrid(range, range);
    z = -(a*x + b*y + d) / c + sigma*randn(size(x));

    simdata = [x(:) y(:) z(:)];
    disp 'a'
    size(simdata)

    %scatter3(simdata(:,1), simdata(:,2), simdata(:,3));

    plot3(x, y, z, '.');
    hold on;

    [A, U] = LS_fitPlane(simdata);
    a = A(1);
    b = A(2);
    c = A(3);
    d = A(4);

    zft = -(a*x + b*y + d) / c;

    surf(x,y,zft,'edgecolor','none')

    hold off;

    ppoints = project_point2plane(simdata, A);

    numerror = a * ppoints(:,1) + b * ppoints(:,2) + c * ppoints(:,3) + d;
    sum(numerror)

    mainv = U(:,1);

    %alpha = zeros(size(ppoints, 1), 1);
    cosa = zeros(size(ppoints, 1), 1);
    for i = 1:size(ppoints, 1)
        %aplha(i) = acos(dot(mainv, ppoints(i,:)) / norm(mainv) / norm(ppoints(i,:)));
        cosa(i) = dot(mainv, ppoints(i,:)) / norm(mainv) / norm(ppoints(i,:));
    end

    alpha = acos(cosa);

end
