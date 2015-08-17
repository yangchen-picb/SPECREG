function params = reg_defaults(txt)
    % default parameters of imregistration
    % params = reg_defaults(txt)
    % txt can be:
    %   'template matching'  (default)
    %   'full registration'
    %

    if nargin < 1
        txt = 'template matching';
    end

    switch txt,
        case 'full registration',

            params.pyramidLevel = 5;  % highest pyramid level
            
            % define transform limit
            params.overlapThres = 0.8;  % moving image and reference image must overlap this much, 1 for fully contained
            params.alim = [-180 180];  % rotation limit
            params.slim = [-0.2 0.2];  % scaling limit
            
            % optimizer parameters
            params.kf_init = 0.6;  % initial keeping factor of the optimizer
            params.kf_decr = 0.5;  % keeping factor decreased at each round
            params.radius = [1 2];  % radius as $(1) * estimate + $(2)
            params.divergenceThres = Inf;  % optimization will be regarded as 'diverged' when this much evaluations encountered
            
            % metric
            params.adjustment_factor = 0.25;  % adjustment factor for restricted mutual information
            
            % evaluator
            params.maskFilterThres = 0.6;  % discard one transformation right away when the consistency of mask below this
            params.subsample = 1;  % the proportion of pixels to be regarded in the highest level
            
        case 'template matching',
            
            params.pyramidLevel = 2;  % highest pyramid level
            
            % define transform limit
            params.overlapThres = 1;  % 
            params.alim = [-180 180];
            params.slim = [0 0];
            
            % optimizer parameters
            params.kf_init = 0.6;
            params.kf_decr = 0.5;
            params.radius = [1 2];
            params.divergenceThres = Inf;
            
            % metric
            params.adjustment_factor = 0.25;
            
            % evaluator
            params.maskFilterThres = 0.6;
            params.subsample = 1;
    end

    %% candidate paramters 
    % max_radius = [16 16 16 16];
    % min_radius = [8 8 8 8];
    
end
