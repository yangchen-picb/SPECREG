function subim = subimage_by_theta(im, theta, siz)
% subim = subimage_by_theta(im, theta, siz)
%
% 2013-03-12
% 2013-03-21
%

    if nargin < 4
        interpolator = 'nearest';
    end

    %CALL
    [x, y] = mapping_RST(1, 1, 1, theta);
    pos = [x, y];
    [scale, angle, transl] = get_params_from_theta(theta);

    ima = imresize(im, 1/scale, interpolator);
    % the alignment point is (1,1)
    pos = (pos - [1,1]) * 1/scale + [1,1];

    %CALL
    posR = round(find_pos_after_imrotate(ima, pos, angle));
    ima = imrotate(ima, angle);

    subim = ima(posR(2):posR(2)+siz(1)-1, posR(1):posR(1)+siz(2)-1, :);

end

