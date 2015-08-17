function [tau, fval, tauCand, valCand, startCand, tauCoarse] = imregistration(targim, refrim, targmask, refrmask, params)
    % wrapper function of registration with full image pyramid
    % [tau, fval, tauCand, valCand, startCand, tauCoarse] = imregistration(targim, refrim, targmask, refrmask, params)
    % 
    
    pyramidLevel = params.pyramidLevel;
    
    metric = RestrictedMutualInformationMetric;
    metric.set_adjustFactor(params.adjustment_factor);
    %metric = MutualInformationMetric;
    
    %% coarse registration
    targReduced = imresize(targim, 1/(2^pyramidLevel), 'nearest');
    refrReduced = imresize(refrim, 1/(2^pyramidLevel), 'nearest');
    targmaskRed = imresize(targmask, 1/(2^pyramidLevel), 'nearest');
    refrmaskRed = imresize(refrmask, 1/(2^pyramidLevel), 'nearest');
    
    % transform
    if isscalar(params.slim) || params.slim(1) == params.slim(2)
        transform = RigidSpace(targReduced, refrReduced);
        transform.set_lim(targReduced, refrReduced, params.overlapThres, params.alim);
    else
        transform = SimilaritySpace(targReduced, refrReduced);
        transform.set_lim(targReduced, refrReduced, params.overlapThres, params.alim, params.slim);
    end

    % radius
    radius = estimate_radius(targReduced, targmaskRed, metric);
    radius = radius(1:length(transform.lb));
    radius = params.radius(1) * radius + params.radius(2:end);
    if params.radius(1) > 0 && all(radius >= 16)
        warning('estimated radius is large, try [16 16 16 16]');
        radius = 16 * ones(size(radius));
    end
    
    % evaluator
    evaluator = Evaluator(targReduced, refrReduced, 'metric', metric, 'transform', transform, 'metricSample', params.subsample, 'maskFilterThres', params.maskFilterThres);
    evaluator.set_mask(targmaskRed, refrmaskRed);
    
    % optimizer
    optimizer = SparseSearchOptimizer;
    optimizer.set_radius(radius);
    optimizer.set_keeping_factor(params.kf_init, params.kf_decr);
    optimizer.set_divergence_threshold(params.divergenceThres);

    [tauCoarse, fvalCoarse, tauCandCoarse, valCandCoarse, computedSub, computedVal] = optimizer.run(@evaluator.eval_with_mask, transform, []);
    %[tauCoarse, fvalCoarse, tauCandCoarse, valCandCoarse, computedSub, computedVal] = optimizer.run(@evaluator.eval, transform, []);
    
    startCand = [tauCandCoarse(:,1:2)*2 tauCandCoarse(:,3:end)];
    fprintf('  number of candidates = ');
    disp(size(startCand,1));
    fprintf('\n');
    
    % debug
    %theta = tau2theta(tauCoarse);
    %figure; imshow(ind2rgb(refrReduced, [0 0 0;hsv(10)]));
    %drawrect(targReduced, theta, size(targReduced));

    %% fine registration
    level = pyramidLevel - 1;
    while level >= 0
        
        targReduced = imresize(targim, 1/(2^level), 'nearest');
        refrReduced = imresize(refrim, 1/(2^level), 'nearest');
        targmaskRed = imresize(targmask, 1/(2^level), 'nearest');
        refrmaskRed = imresize(refrmask, 1/(2^level), 'nearest');
        
        %theta = tau2theta(startCand(1,:));
        %figure; imshow(ind2rgb(refrReduced, [0 0 0;hsv(10)]));
        %drawrect(targReduced, theta, size(targReduced));
        
        % TODO: do I need to make a new instance for transform?
        if isscalar(params.slim) || params.slim(1) == params.slim(2)
            transform = RigidSpace(targReduced, refrReduced);
            transform.set_lim(targReduced, refrReduced, params.overlapThres, params.alim);
        else
            transform = SimilaritySpace(targReduced, refrReduced);
            transform.set_lim(targReduced, refrReduced, params.overlapThres, params.alim, params.slim);
        end
        
        evaluator = Evaluator(targReduced, refrReduced, 'metric', metric, 'transform', transform, 'metricSample', params.subsample * 1/2^(pyramidLevel-level-1));
        evaluator.set_mask(targmaskRed, refrmaskRed);
        
        optimizer.set_radius(2^level);
        
        % TODO: eval without mask at lower level pyramid, or else it will
        % get inf at lower level pyramid
        [tau, fval, tauCand, valCand] = optimizer.run(@evaluator.eval, transform, startCand);
        
        %theta = tau2theta(tau);
        %figure; imshow(ind2rgb(refrReduced, [0 0 0;hsv(10)]));
        %drawrect(targReduced, theta, size(targReduced));
    
        startCand = [tauCand(:,1:2)*2 tauCand(:,3:end)];
        
        level = level - 1;
    end
    
end

