function sppos_array = drawrect(im, allpos, allsiz, allangle, colors)
% drawrect(im, allpos, allsiz, allangle, colors)
% give empty variable 'im' if add to the exist image
% 
% use this drawrect if the pos is retrived from rotate the stim
% the angle is the angle stim rotated through imrotate, which is also tau(3)
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
%     if ~isempty(im)
%         H = imshow(im);
%     end

    sppos_array = zeros(Nim, 2);
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
        tl = pos;
        bl = [rectx(2) recty(2)];
        br = [rectx(3) recty(3)];
        tr = [rectx(4) recty(4)];

        %imrotated = imrotate(im, angle);
        imrotated = imrotate(ones(bsiz), angle);
        ori = [size(imrotated, 2) / 2, size(imrotated, 1) / 2];


        tl = tl - ori;
        bl = bl - ori;
        br = br - ori;
        tr = tr - ori;

        transtl(1) = tl(1) * cosd(angle) + tl(2) * sind(angle);
        transtl(2) = - tl(1) * sind(angle) + tl(2) * cosd(angle);
        transbl(1) = bl(1) * cosd(angle) + bl(2) * sind(angle);
        transbl(2) = - bl(1) * sind(angle) + bl(2) * cosd(angle);
        transbr(1) = br(1) * cosd(angle) + br(2) * sind(angle);
        transbr(2) = - br(1) * sind(angle) + br(2) * cosd(angle);
        transtr(1) = tr(1) * cosd(angle) + tr(2) * sind(angle);
        transtr(2) = - tr(1) * sind(angle) + tr(2) * cosd(angle);

        transct = mean([transtl; transbl; transbr; transtr]);

        %transori = [size(im, 2) / 2, size(im, 1) / 2];
        transori = [bsiz(2) / 2, bsiz(1) / 2];

        transtl = transtl + transori;
        transbl = transbl + transori;
        transbr = transbr + transori;
        transtr = transtr + transori;
        transct = transct + transori;

%         transtl

        rectx = [transtl(1); transbl(1); transbr(1); transtr(1); transtl(1)];
        recty = [transtl(2); transbl(2); transbr(2); transtr(2); transtl(2)];
        rectct = transct;
    end

    line(rectx, recty, 'linewidth', 0.5, 'color', color);
    % upper left indication
    hold on;
    plot(rectct(1), rectct(2), 'o', 'color', color);
    hold off;
    text(rectct(1), rectct(2), num2str(i), 'fontsize', 10, 'color', color);

    sppos_array(i,:) = [rectx(1), recty(1)];
    end % end for

end

