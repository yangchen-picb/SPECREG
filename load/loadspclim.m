function [spclimArray, spmaskArray] = loadspclim(sample, nCl)
% [spclimArray, spmaskArray] = loadspclim(sample, nCl)

    % filename compatibility
    filepat = {['spclim_' sample '_nCl=' num2str(nCl) '.mat'], ...
               ['spclim_' sample '_ncl=' num2str(nCl) '.mat'] };

    ex = false;
    for pat = filepat
        pat = pat{1};
        if exist(pat, 'file')
            s = load(pat);
            ex = true;
            break;
        end
    end
    if ~ex
        error('file not found');
    end
                
    %% variable name compatibility
    % name difference
    try
        spclimArray = s.spclimArray;
        spmaskArray = s.spmaskArray;
    catch
        try
            spclimArray = s.climArray;
        catch
            spclimArray = {s.spclim};
            spmaskArray = {s.spmask};
        end
    end
    
    % some index image have gray format
    for i = 1:length(spclimArray)
        spclim = spclimArray{i};
        ind = unique(spclim);
        [~, spclim] = histc(spclim, ind);
        if ind(1) == 0, spclim = spclim - 1; end;
        spclimArray{i} = spclim;
    end
    
end

