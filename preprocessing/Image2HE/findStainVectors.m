function [stainvec, stainrgb] = findStainVectors(stim, mask)
% [stainvec, stainrgb] = findStainVectors(stim, mask)
%
% find stain vectors of a stained image by fitting a plane in the OD space
% stain vectors are all unit vectors.
%
%

    H = size(stim, 1);
    W = size(stim, 2);

    odim = RGB2OD(stim);

    ods = reshape(odim, [H*W 3]);
    ind = reshape(mask, [H*W 1]);

    points = ods(ind, :);

    % test
    samplesize = 10000;
    samples = randsample(size(points, 1), samplesize);
    points = points(samples, :);

    % CALL
    [A, tp] = fitPlane(points);

    % if X is available
    try
        % show the fitted plane
        figure;

        samplesize = 2000;
        ODspace(stim, samplesize, mask);
 
        hold on;
 
        a = A(1);
        b = A(2);
        c = A(3);
        d = A(4);
 
 
        range = 0:0.1:1;
        [x, y] = meshgrid(range, range);
        zft = -(a*x + b*y + d) / c;
 
        mesh(x, y, zft)
 
        hold off;

    catch
    end

    % angle hist
    refvec = [-A(2) A(1) 0];

    ppoints = project_point2plane(points, A);

    cosa = zeros(size(ppoints, 1), 1);
    for i = 1:size(ppoints, 1)
        cosa(i) = dot(refvec, ppoints(i,:)) / norm(refvec) / norm(ppoints(i,:));
    end

    alpha = acos(cosa);

    %line([0; refvec(1)], [0; refvec(2)], [0; refvec(3)], 'color', 'red');

    [t, order] = sort(alpha);
    v1i = order(round(length(alpha) * 5 / 100));
    v2i = order(round(length(alpha) * 95 / 100));

    v1 = ppoints(v1i,:) / norm(ppoints(v1i,:));
    v2 = ppoints(v2i,:) / norm(ppoints(v2i,:));

    stainvec = [v1; v2];
    stainrgb = OD2RGB(stainvec);

    try
        line([0; v1(1)], [0; v1(2)], [0; v1(3)], 'color', stainrgb(1,:) / 255);
        line([0; v2(1)], [0; v2(2)], [0; v2(3)], 'color', stainrgb(2,:) / 255);
    catch
    end

end

