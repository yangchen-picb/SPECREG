function stim = HE2RGB(heim, stainvec)
% stim = HE2RGB(heim, stainvec)
%
% 2013-03-23
%

    H = size(heim, 1);
    W = size(heim, 2);

    hes = reshape(heim, [H*W size(heim, 3)]); 

    %ods = RGB2OD(hes);
    %rgbs = ods * stainvec;

    ods = hes * stainvec;
    rgbs = OD2RGB(ods);

    stim = reshape(rgbs, [H W size(rgbs, 2)]);

end

