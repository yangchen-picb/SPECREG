
    % template matching like registration
    
    clear;

runtag = '';

    % 0 options
    opt.sample = 'Wi73501';
    %opt.sample = 'Wi220100';
    %opt.sample = 'W99205';
    %opt.sample = '3803';
    %opt.sample = 'B107';
    
    opt.isResize = true;
    opt.nClSp = 8;
    opt.nClSt = 10;
    
    opt.params = reg_defaults('template matching');
    opt.params.pyramidLevel = 3;
    opt.params.alim = [-30 30];
    opt.params.radius = [1 2];
    opt.params.adjustment_factor = 0.25;
    opt
    opt.params
    
    % 1. refrim
    stclim = loadstclim(opt.sample, opt.nClSt);
    refrim = stclim;
    stim = loadstim(opt.sample, opt.isResize);
    [~, refrmask] = background_correction(stim);
	%refrmask = imfillsmall(refrmask);

    % 2. targim
    [targimArray, targmaskArray] = loadspclim(opt.sample, opt.nClSp);
    
    % 3. trueTheta
    trueTheta = loadtheta(opt.sample, opt.isResize);
    
%% end of interactive
    %%
    tic;

    % const var
    targSiz = allsize(targimArray, 2);
    nTarg = length(targimArray);
    
    tauArray = zeros(nTarg, 4);
    valArray = zeros(nTarg, 1);
    candCell = cell(nTarg, 1);
    spCell = cell(nTarg, 1);
    for i = 1:nTarg
        i
        targim = targimArray{i};
        targmask = targmaskArray{i};
        
        %[tau, fval, tauCand, valCand, startCand, tauCoarse] = imregistration(targim, refrim, targmask, refrmask, opt.params);
        [tau, fval] = imregistration(targim, refrim, targmask, refrmask, opt.params);

        tauArray(i,1:size(tau,2)) = tau;
        %valArray(i) = fval;
        %candCell{i} = [tauCand, valCand];
        %spCell{i} = startCand;
    end
    
    % plot
    theta = tau2theta(tauArray);
    
        figure; imshow(stim);
        color = [240 255 60] / 255;
        try drawrect(stim, trueTheta, targSiz, color); catch end;
        drawrect(stim, theta, targSiz);
        % savefigure scheme
        % savefigure('register_through_mi_clim_as_targim');
    
    duration = toc

    % save scheme
    %save(['result_theta_' opt.sample '_' runtag '.mat'], 'theta', 'tauArray', 'opt', 'trueTheta', 'targSiz');
