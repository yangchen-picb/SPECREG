%function planeFitting(stim)
% planeFitting(stim)
%


    %{
    H = size(stim, 1);
    W = size(stim, 2);

    odim = RGB2OD(stim);


    ods = reshape(odim, [H*W size(odim, 3)]);

    
    samplesize = 100;
    randind = randsample(size(ods, 1), samplesize);
    ods = ods(randind, :);


    [U, S, V] = svd(ods);

    %p1 = V(1,:);
    p1 = U(:,1);
    x1 = p1(1); y1 = p1(2); z1 = p1(3);
    %p2 = V(2,:);
    p2 = U(:,2);
    x2 = p2(1); y2 = p2(2); z2 = p2(3);

    % plane equation
    a = y1*z2 - y2*z1;
    b = x2*z1 - x1*z2;
    c = x1*y2 - x2*y1;

    ODspace(stim);

    hold on;
    %}

    a = 1;
    b = 0;
    c = 1;

    [x, y] = meshgrid(-1:0.1:1, -1:0.1:1);
    z = (a*x + b*y) / c;
    mesh(z);

    xlabel('x');
    ylabel('y');
    zlabel('z');


%end

