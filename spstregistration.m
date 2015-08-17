function [tau, spclim, stclim, spmask, stmask] = spstregistration(spclim, stclim, spmask, stmask, opt)
    % [tau, spclim, stclim, spmask, stmask] = spstregistration(spclim, stclim, spmask, stmask, opt)
    % or
    % [tau, spclim, stclim, spmask, stmask] = spstregistration(spim, stim, opt)
    % 
    % about the options, see reg_options.m
    %

    if nargin == 3
        spim = spclim;
        stim = stclim;
        opt = spmask;
        
        [spclim, spmask] = spim2cl(spim, opt.nClSp);
    
        [stim, stmask] = background_correction(stim, opt.distThres, opt.rgbThres);
        stclim = stim2cl(stim, opt.nClSt, stmask);
    end
    
    tau = imregistration(spclim, stclim, spmask, stmask, opt.params);
end

