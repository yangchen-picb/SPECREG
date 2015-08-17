function drawrect(im, alltheta, allsiz, color)
% drawrect(im, alltheta, allsiz, color)
%
% a param vector theta should be [cos(alpha); sin(alpha); x-translation; y-translation]
%
% 2013-03-27
%

    if nargin < 4
        color = [.1 .1 .1];
    end

    trans_fun = @mapping_RST;

    Nim = size(allsiz, 1);
    bsiz = size(im);

    if nargin < 4
        allangle = zeros(Nim, 1);
    end

    %H = imshow(im);

    % for multiple position
    for i = 1:Nim
        siz = allsiz(i,:);
        theta = alltheta(:,i);

    tl = [1, 1];
    bl = [1, siz(1)];
    br = [siz(2), siz(1)];
    tr = [siz(2), 1];
    ct = [siz(2)/2, siz(1)/2];

    [transtl(1) transtl(2)] = trans_fun(tl(1), tl(2), 1, theta);
    [transbl(1) transbl(2)] = trans_fun(bl(1), bl(2), 1, theta);
    [transbr(1) transbr(2)] = trans_fun(br(1), br(2), 1, theta);
    [transtr(1) transtr(2)] = trans_fun(tr(1), tr(2), 1, theta);
    [transct(1) transct(2)] = trans_fun(ct(1), ct(2), 1, theta);

    rectx = [transtl(1); transbl(1); transbr(1); transtr(1); transtl(1)];
    recty = [transtl(2); transbl(2); transbr(2); transtr(2); transtl(2)];
    rectct = transct;

    line(rectx, recty, 'linewidth', 0.5, 'color', color, 'LineStyle', '-');

    % upper left indication
    hold on;
    plot(transtl(1), transtl(2), 'o', 'color', color);
    hold off;

    text(rectct(1), rectct(2), num2str(i), 'fontsize', 10, 'color', color);

    end % end for

end

