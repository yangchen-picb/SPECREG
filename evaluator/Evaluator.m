classdef Evaluator < handle
    % Image Dissimilarity Evaluator
    % image should be index image
    
    % sample before computing the mask overlap
    
    properties(SetAccess = protected)
        mvim
        fxim
        mvmask
        fxmask
        metric
        transform
        interpolator
        maskOverlapThres  % for fast filter out bad regions
        sampleInd  
        
        mvind
        fxind
        mvback
        fxback
    end
    
    properties(Access = protected)
        mvx
        mvy
        mvv
    end
    
    methods
        function E = Evaluator(mvim, fxim, varargin)
            ip = inputParser;
            
            % default inputs
            ip.addRequired('mvim');
            ip.addRequired('fxim');
            ip.addParamValue('metric', RestrictedMutualInformationMetric);
            ip.addParamValue('transform', SimilaritySpace(mvim, fxim));
            ip.addParamValue('interpolator', 'nearest');
            ip.addParamValue('metricSample', 1);  % spatialSample
            ip.addParamValue('maskFilterThres', 0.6);
            
            ip.parse(mvim, fxim, varargin{:});
            inputs = ip.Results;
            
            % image should be double format
            if isinteger(inputs.mvim)
                E.mvim = double(inputs.mvim);
            else
                E.mvim = inputs.mvim;
            end
            if isinteger(inputs.fxim)
                E.fxim = double(inputs.fxim);
            else
                E.fxim = inputs.fxim;
            end
            
            % reduce the index of index image
            mvind = unique(mvim);
            fxind = unique(fxim);
            [~, E.mvim] = histc(E.mvim, mvind);
            [~, E.fxim] = histc(E.fxim, fxind);
            E.mvind = unique(E.mvim);
            E.fxind = unique(E.fxim);
            
            % inputs
            E.metric = inputs.metric;
            E.transform = inputs.transform;
            E.interpolator = inputs.interpolator;
            [E.mvx, E.mvy] = meshgrid(1:size(E.mvim,2), 1:size(E.mvim,1));
            E.maskOverlapThres = inputs.maskFilterThres;
            
            % TODO : ugly
            E.set_metricSample(inputs.metricSample);
        end
        
        function set_metricSample(E, metricSample)
            nPix = numel(E.mvim);
            if isscalar(metricSample)
                if metricSample <= 1
                    sampleInd = randsample(nPix, round(nPix * metricSample));
                else
                    sampleInd = randsample(nPix, metricSample);
                end
            else
                sampleInd = metricSample;
            end
            [x, y] = meshgrid(1:size(E.mvim,2), 1:size(E.mvim,1));
            E.mvx = x(sampleInd);
            E.mvy = y(sampleInd);
            E.mvv = E.mvim(sampleInd);
            E.sampleInd = sampleInd;
        end
        
        function set_metric(E, metric)
            E.metric = metric;
        end
        
        function set_transform(E, transform)
            E.transform = transform;
        end
        
        function set_interpolator(E, interpolator)
            E.interpolator = interpolator;
        end
        
        function set_mask(E, mvmask, fxmask)
            E.mvmask = mvmask;
            E.fxmask = fxmask;
            E.maskOverlapThres = E.maskOverlapThres * sqrt(sum(E.mvmask(:))/numel(E.mvmask));
            
            % background ind
            E.mvback = mode(E.mvim(~E.mvmask));
            E.fxback = mode(E.fxim(~E.fxmask));
            % no background
            if isnan(E.mvback), E.mvback = max(E.mvind) + 1; end;  % outerind
            if isnan(E.fxback), E.fxback = max(E.fxind) + 1; end; 
            
            % ask whether the metric wants to know about the background ind
            if isprop(E.metric, 'restrictedind')
                E.metric.set_restrictedind([E.mvback E.fxback]);
            end
        end
        
        function fval = eval(E, tau)
            fval = zeros(size(tau,1), 1);
            for i = 1:size(tau,1)
                [fxx, fxy] = E.transform.mapping(E.mvx, E.mvy, tau(i,:));

                % bound
                rx = round(fxx); ry = round(fxy);
                if sum(rx < 1 | ry < 1 | rx > size(E.fxim,2) | ry > size(E.fxim,1)) / numel(E.mvv) > 1 - E.transform.overlapThres
                    fval(i) = Inf;
                    continue;
                end

                fxv = interp2(E.fxim, fxx, fxy, E.interpolator);
                
                % bound
                %if sum(~isnan(fxv(:))) / numel(E.mvv) < E.overlapThres
                %    fval(i) = Inf;
                %    continue;
                %end
                
                fval(i) = E.metric.compute(E.mvv(~isnan(fxv)), fxv(~isnan(fxv)));
            end
        end
                
        function fval = eval_with_mask(E, tau)
            fval = zeros(size(tau,1), 1);
            for i = 1:size(tau,1)
                [fxx, fxy] = E.transform.mapping(E.mvx, E.mvy, tau(i,:));
                
                % bound
                rx = round(fxx); ry = round(fxy);
                if sum(rx < 1 | ry < 1 | rx > size(E.fxim,2) | ry > size(E.fxim,1)) / numel(E.mvv) > 1 - E.transform.overlapThres
                    fval(i) = Inf;
                    continue;
                end
                
                % fast filter by mask
                maskv = interp2(E.fxmask, fxx, fxy, 'nearest', 2);
                if sum(maskv(maskv < 2) == E.mvmask(maskv < 2)) / sum(maskv < 2) < E.maskOverlapThres
                    fval(i) = Inf;
                    continue;
                end
                
                fxv = interp2(E.fxim, fxx, fxy, E.interpolator);
                
                % bound
                %if sum(~isnan(fxv(:))) / numel(E.mvv) < E.overlapThres
                %    fval(i) = Inf;
                %    continue;
                %end
                fval(i) = E.metric.compute(E.mvv(~isnan(fxv)), fxv(~isnan(fxv)));
            end
        end
        
        function estimate_radius(rad)
            
        end
    end
    
end
