function [stclim, stmask] = loadstclim(sample, nCl)
    % only a function help you load 
    
    s = load(['stclim_' sample '_nCl=' num2str(nCl) '.mat']);
    stclim = s.stclim;
    
    %% compatibility
    
    
    % some index image have gray format
    ind = unique(stclim);
    [~, stclim] = histc(stclim, ind);
    if ind(1) == 0, stclim = stclim - 1; end;
    
    % some mat file contains mask, some not
    try stmask = s.stmask; catch, end;
end

