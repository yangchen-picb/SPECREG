function odim = RGB2OD(im)
% odim = RGB2OD(im, isinf = false)
%
% This function does not normalize the odim.
%
% 2013-03-29
% 

    if isinteger(im)
        %im = im2double(im);
        im = (double(im) + 1) / 256;
    end

    odim = -log10(im);

end

