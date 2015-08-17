function im = OD2RGB(odim)
% im = OD2RGB(odim)
%

    im = 10 .^ -odim;
    %im = uint8(im * 256 - 1);
    im = im2uint8(im);

end

