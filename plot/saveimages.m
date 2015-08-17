function saveimages(allpredim, filename, fmt)
% saveimages(allpredim, filename, fmt)
%
    if nargin < 3
        fmt = 'tif';
    end

    for i = 1:length(allpredim)
        imwrite(allpredim{i}, [filename '_' num2str(i) '.' fmt], fmt);
    end
end

