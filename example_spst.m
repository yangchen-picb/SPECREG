    
	loadpath;
	
    clear;

    opt.sample = 'Wi73501';
    opt.spid = 1;
    
    %spim = loadspim(opt.sample, opt.spid);
    s = load('spim_Wi73501_1.mat', 'spim');
	spim = s.spim;
	stim = loadstim(opt.sample);
    
    regopt = reg_options('template matching');
    
    tic;
    [tau1, spclim, stclim, spmask, stmask] = spstregistration(spim, stim, regopt);
    duration1 = toc
    
    tic;
    [tau2, spclim, stclim, spmask, stmask] = spstregistration(spclim, stclim, spmask, stmask, regopt);
    duration2 = toc
    
    %% plot
    theta = tau2theta(tau1);
    figure; imshow(stim);
    drawrect(stim, theta, [size(spim,1) size(spim,2)]);
    