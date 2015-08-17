function drawrect(im, allpos, allsiz, allangle, colors)
% drawrect(im, pos, siz, angle)
%
% use this drawrect if the pos is retrived by rotate the spim
% angle is spim rotated through imrotate, which is -tau(3)
%

    Nim = size(allpos, 1);
    bsiz = size(im);

    if nargin < 5
        colors = repmat([0.1 0.1 0.1], [Nim 1]);
    end
    if size(colors, 1) == 1;
        colors = repmat(colors, [Nim 1]);
    end

    if nargin < 4
        allangle = zeros(Nim, 1);
    end

    allangle = - allangle;

    %H = imshow(im);

    % for multiple position
    for i = 1:Nim
        pos = allpos(i,:);
        siz = allsiz(i,:);
        angle = allangle(i);
        color = colors(i,:);


    rectx = pos(1) * ones(5, 1);
    recty = pos(2) * ones(5, 1);

    rectx(1) = pos(1);
    recty(1) = pos(2);
    rectx(2) = pos(1);
    recty(2) = pos(2) + siz(1);
    rectx(3) = pos(1) + siz(2);
    recty(3) = pos(2) + siz(1);
    rectx(4) = pos(1) + siz(2);
    recty(4) = pos(2);
    rectx(5) = pos(1);
    recty(5) = pos(2);
    rectct = [pos(1)+siz(2)/2 pos(2)+siz(1)/2];

    if angle ~= 0
        imrotated = imrotate(ones(siz), angle);
        rotsiz = size(imrotated);
        ori = [pos(1)+rotsiz(2)/2 pos(2)+rotsiz(1)/2];

        %t = ori(2) - siz(1)/2;
        %b = ori(2) + siz(1)/2;
        %l = ori(1) - siz(2)/2;
        %r = ori(1) + siz(2)/2;
        t = - siz(1)/2;
        b = + siz(1)/2;
        l = - siz(2)/2;
        r = + siz(2)/2;

        tl = [l t];
        bl = [l b];
        br = [r b];
        tr = [r t];

        transtl(1) = tl(1) * cosd(-angle) + tl(2) * sind(-angle);
        transtl(2) = - tl(1) * sind(-angle) + tl(2) * cosd(-angle);
        transbl(1) = bl(1) * cosd(-angle) + bl(2) * sind(-angle);
        transbl(2) = - bl(1) * sind(-angle) + bl(2) * cosd(-angle);
        transbr(1) = br(1) * cosd(-angle) + br(2) * sind(-angle);
        transbr(2) = - br(1) * sind(-angle) + br(2) * cosd(-angle);
        transtr(1) = tr(1) * cosd(-angle) + tr(2) * sind(-angle);
        transtr(2) = - tr(1) * sind(-angle) + tr(2) * cosd(-angle);

        transtl = transtl + ori;
        transbl = transbl + ori;
        transbr = transbr + ori;
        transtr = transtr + ori;

        rectx = [transtl(1); transbl(1); transbr(1); transtr(1); transtl(1)];
        recty = [transtl(2); transbl(2); transbr(2); transtr(2); transtl(2)];
        rectct = ori;
    else
        transtl = [rectx(1) recty(1)];
    end

    line(rectx, recty, 'linewidth', 0.5, 'color', color);
    
    % upper left indication
    hold on;
    plot(transtl(1), transtl(2), 'o', 'color', color);
    hold off;

    text(rectct(1), rectct(2), num2str(i), 'fontsize', 10, 'color', color);

    end % end for

end

