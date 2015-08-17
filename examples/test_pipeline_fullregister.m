
    % full registration

    clear;

    % 0 options
    %opt.sample = 'B107';
    %opt.sample = 'E138207';  % lung sample
    %opt.sample = '88180'
    opt.sample = 'A1';
    %opt.sample = '78878';
    
    opt.isResize = true;
    opt.nClSp = 10;
    opt.nClSt = 10;
    
    % parameters for registration
    opt.params = reg_defaults('full registration');
    opt.params.pyramidLevel = 5;
    opt.params.overlapThres = 0.8;
    opt.params.alim = [-180 180];
    opt.params.slim = [-0.2 0.2];
    %opt.params.radius = 8;  % default: auto selected
    opt
    
    % 1. refrim
    %stim = loadstim(opt.sample, opt.isResize);  % for demostration
    % segmentation
    %[stim, refrmask] = background_correction(stim, opt.distThres, opt.rgbThres);
    [stclim, refrmask] = loadstclim(opt.sample, opt.nClSt);
    refrim = stclim;
    refrmask = imfillsmall(refrmask);

    % 2. targim
    %[spimArray, targmaskArray] = loadspim(opt.sample);
    [targimArray, targmaskArray] = loadspclim(opt.sample, opt.nClSp);
    
    % 3. trueTheta
    trueTheta = loadtheta(opt.sample, opt.isResize);

%% end of interactive
    tic;

    % const var
    targSiz = allsize(targimArray, 2);
    nTarg = length(targimArray);
    
    tauArray = zeros(nTarg, 4);
    valArray = zeros(nTarg, 1);
    candCell = cell(nTarg, 1);
    spCell = cell(nTarg, 1);
    dmCell = cell(nTarg, 1);
    for i = 1:nTarg
        i
        %i = 7;
        targim = targimArray{i};
        targmask = targmaskArray{i};
        
        %[tau, fval, tauCand, valCand, startCand, tauCoarse, dm] = imregistration(targim, refrim, targmask, refrmask, opt.params);
        [tau] = imregistration(targim, refrim, targmask, refrmask, opt.params);
        
        tauArray(i,1:size(tau,2)) = tau;
        %valArray(i) = fval;
        %candCell{i} = [tauCand, valCand];
        %spCell{i} = startCand;
        %dmCell{i} = dm;
    end
    
    % plot
    theta = tau2theta(tauArray);
    
    targimAligned = transform_image(targimArray{1}, refrim, tau);
    figure; imshowpair(refrim, targimAligned,'Scaling','joint');
        
    % save scheme
    %save test_pipeline.mat theta tauArray valArray candCell spCell dmCell opt trueTheta targSiz
    
    duration = toc
    
