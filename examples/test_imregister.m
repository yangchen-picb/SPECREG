
    % full image registration using matlab imregister function

    clear;

    % 0 options
    %opt.sample = 'E138207';  % lung sample
    %opt.sample = '88180'
    opt.sample = 'A1';
    %opt.sample = '78878'
    
    opt.isResize = true;
    opt.nClSp = 10;
    opt.nClSt = 10;
    
    % for stim background correction
    %opt.distThres = 0.01;
    %opt.rgbThres = [200 200 200];
    %opt.rgbThres = [170 170 170];  %[170 170 170] for 88180, otherwise [200 200 200]
    
    % 
    opt.params.pyramidLevel = 2;
    opt

    % 1. refrim
    [stclim, refrmask] = loadstclim(opt.sample, opt.nClSt);
	refrmask = imfillsmall(refrmask);
    %stclim = loadstclim(opt.sample, opt.nClSt);
    %refrim = stclim;
    %stim = loadstim(opt.sample, opt.isResize);
    %[stim, refrmask] = background_correction(stim);
    %refrim = rgb2gray(stim);
    %stpcim = image2pc(stim, 1);
    %refrim = stpcim;
    %stclim = stim2cl(stim, opt.nClSt);
    refrim = stclim;
    %refrim = image2pc(stim, 1);
    %refrim = bin(double(refrim), 16);

    % try with a different initial state
    %refrim = imrotate(refrim, 180);

    % 2. targim
    [targimArray, targmaskArray] = loadspclim(opt.sample, opt.nClSp);
    %[spimArray, targmaskArray] = loadspim(opt.sample);
    %s = load(['spsumim_' opt.sample '.mat']);
    %s.spsumim = sum(spimArray{1}, 3);
    %targimArray = {normim(s.spsumim)};

    
    % 3. trueTheta
    %trueTheta = loadtheta(opt.sample, opt.isResize);
    
    % index image
    %refrim = gray2ind(refrim, length(unique(refrim)));
    %for i = 1:length(targimArray)
    %    targimArray{i} = gray2ind(targimArray{i}, length(unique(targimArray{i})));
    %end
    
%% end interactive
    
    %%
    tic;
    
    % default options for multimodal in http://www.mathworks.cn/cn/help/images/ref/imregister.html
    [optimizer, metric] = imregconfig('multimodal');
    optimizer.InitialRadius = 0.009;
    optimizer.Epsilon = 1.5e-4;
    optimizer.GrowthFactor = 1.01;
    optimizer.MaximumIterations = 300;
    
    nTarg = length(targimArray);

    for i = 1:nTarg
        i
        %i = 7;
        targim = targimArray{i};
    
        %movingRegistered = imregister(targim, refrim, 'similarity', optimizer, metric, 'PyramidLevels', opt.params.pyramidLevel);
        tform = imregtform(targim, refrim, 'similarity', optimizer, metric, 'PyramidLevels', opt.params.pyramidLevel);
        %movingRegistered = imwarp(targim, tform);
        movingRegistered = imwarp(targim, tform, 'OutputView', imref2d(size(refrim)));
        figure; imshowpair(refrim, movingRegistered,'Scaling','joint');
    end
    
    duration = toc

    % save scheme
    %save(['imregister_' opt.sample runtag '.mat'], 'tform', 'opt', 'duration');
    
%end

