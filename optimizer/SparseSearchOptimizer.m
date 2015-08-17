classdef SparseSearchOptimizer < handle
    % SparseSearchOptimizer class
    % radius means how many varunit, instead of absolute value of the
    % transform parameters
    
    properties
        radius
        kfinit
        kfdecr
        kffinal
        extremumRadius
        divergenceThres
    end
    
    methods
        function SS = SparseSearchOptimizer()
            SS.radius = 8;
            SS.kfinit = 0.6;
            SS.kfdecr = 0.5;
            SS.kffinal = 0.125;
            SS.extremumRadius = 8;
            SS.divergenceThres = Inf;
        end
        
        function set_radius(SS, radius)
            SS.radius = radius;
        end
        
        function set_keeping_factor(SS, kfinit, kfdecr, kffinal)
            if nargin < 4
                kffinal = [];
            end
            if nargin < 3
                kfdecr = [];
            end
            if ~isempty(kfinit)
                SS.kfinit = kfinit;
            end
            if ~isempty(kfdecr)
                SS.kfdecr = kfdecr;
            end
            if ~isempty(kffinal)
                SS.kffinal = kffinal;
            end
        end
        
        function set_divergence_threshold(SS, divergenceThres)
            SS.divergenceThres = divergenceThres;
        end
        
        function [x, fval, xCand, vCand, computedSub, computedVal] = run(SS, fun, space, startPoints)
            if nargin < 4
                startPoints = [];
            end
                        
            lb = space.lb;
            ub = space.ub;
            varunit = space.varunit;
            if isscalar(SS.radius)
                rad = repmat(SS.radius, size(lb));
            else
                rad = SS.radius;
            end
            
            mapx = @(s)repmat(lb,size(s,1),1) + (s - 1) .* repmat(varunit,size(s,1),1);
            
            dim = floor((ub - lb) ./ varunit) + 1;
            
            if isempty(startPoints)
                lind = floor(rad/2) + 1;
                uind = dim + lind;
                % if rad = 1, it becomes complete search
                %lind = [1 1 1];
                %uind = dim + rad - 1;
                
                range = arrayfun(@(s,i,e) s:i:e, lind, rad, uind, 'UniformOutput', false);
                sub = cell(size(lb));
                [sub{:}] = ndgrid(range{:});
                sub = cellfun(@(x) x(:), sub, 'UniformOutput', false);
                sub = cell2mat(sub);
                sub = bound_sub(sub, dim);
            else
                % TODO: the relationship between radius and startPoints are not so clear
                rad = rad * 2;
                sub = round((startPoints - repmat(lb,size(startPoints,1),1)) ./ repmat(varunit,size(startPoints,1),1)) + 1;
            end
            
            % currently computed sub and values
            computedSub = sub;
            fprintf('  radius = ');
            disp(rad);
            fprintf('  evaluate');
            disp(size(computedSub,1));
            
            computedVal = fun(mapx(sub));
            
            % for demo 
            %dm = space.space2mat(computedSub, computedVal);
            %figure; imagesc(-dm);
            
            % find out the value range
            minv = min(computedVal);
            maxv = max(computedVal(~isinf(computedVal)));

            if ~isempty(startPoints)
                candSub = computedSub;
            elseif isinf(minv)
                if any(rad > 8)
                    % TODO: ugly
                    warning('round 1 sparse search get all invalid value, try radius [8 8 8 8]');
                    SS.radius = 8;
                    [x, fval, xCand, vCand, computedSub, computedVal] = SS.run(fun, space, startPoints);
                    return;
                else
                    error('round 1 sparse search get all invalid value, maybe you want to reduce the pyramidLevel or maskFilterThres');
                end
            else
                thres = minv + (maxv-minv) * SS.kfinit;
                candSub = computedSub(computedVal<=thres,:);  % if all points have the same value, all will be chosen.
            end
                                    
            % how to pick neighbors affect speed and accuracy
            %neighbors = get_neighbors_coord(1, length(dim));
            neighbors = get_neighbors_coord2(1, length(dim));
            %neighbors = [-1*eye(length(dim)); 1*eye(length(dim))];
            
            i = 0;
            while any(rad > 1)
            %while i < 3
                i = i + 1;
            %for i = 1:ceil(max(log2(rad)))+1;
                rad = ceil(rad/2);
                fprintf('  radius = ');
                disp(rad);
                nbs = neighbors .* repmat(rad, size(neighbors,1), 1);
                nbi = repmat(1:size(nbs,1), size(candSub,1), 1);
                newsub = repmat(candSub, size(nbs,1), 1) + nbs(nbi(:),:);
                
                % bound subscript
                % using arrayfun is slower
                %newsub = arrayfun(@(x, y) min(x, y), repmat([dimx dimy dima], size(newsub,1), 1));
                newsub = bound_sub(newsub, dim);
                
                % unique first is faster
                newsub = unique(newsub, 'rows');
                newsub = setdiff(newsub, computedSub, 'rows');
                if size(newsub,1) == 0, continue; end
                
                fprintf('  evaluate');
                disp(size(newsub,1));
                
                %tauArray = [txrange(newsub(:,1)) tyrange(newsub(:,2)) tarange(newsub(:,3))];
                if size(newsub, 1) > SS.divergenceThres
                    warning('optimizer diverged');
                    break;
                end
                values = fun(mapx(newsub));
                
                minv = min([minv; values]);
                maxv = max([maxv; values(~isinf(values))]);
                %thres = minv + (maxv-minv) * 1/2^i;
                thres = minv + (maxv-minv) * SS.kfinit * SS.kfdecr^i;
                
                computedSub = [computedSub; newsub];
                computedVal = [computedVal; values];
                
                % It's strange that even selecting cand from computed needs more
                % evaluation, but faster then selecting only from new.
                candSub = computedSub(computedVal<=thres,:);
                %candSub = newsub(values<thres,:);
                
                % for demo
                %dm = space.space2mat(computedSub, computedVal);
                %figure; imagesc(-dm);
            
            end
            
            [fval, mi] = min(computedVal);
            x = mapx(computedSub(mi,:));

            thres = minv + (maxv-minv) * SS.kffinal;
            ind = computedVal<=thres;
            left = [computedSub(ind,:) computedVal(ind)];
            xCand = zeros(size(left,1), length(dim));
            vCand = zeros(size(left,1), 1);
            i = 0;
            while ~isempty(left)
                i = i + 1;
                [mv, mi] = min(left(:,end));
                xCand(i,:) = left(mi,1:end-1);
                vCand(i) = left(mi,end);
                left = left(dist(xCand(i,:), left(:,1:end-1)') > SS.extremumRadius, :);
                % you can simply use squre instead of dist
            end
            xCand = mapx(xCand(1:i,:));
            vCand = vCand(1:i); 
                      
            %{
            dm = Inf * ones(dim);
            sub = mat2cell(computedSub, size(computedSub,1), ones(size(dim)));
            ind = sub2ind(size(dm), sub{:});
            dm(ind) = computedVal;
            
            thres = minv + (maxv-minv) * SS.kffinal;
            isMum = (dm < thres) & find_minimum_3d(dm);
            ind = find(isMum);
            sub = cell(size(dim));
            [sub{:}] = ind2sub(size(dm), ind);
            sub = cell2mat(sub);
            xCand = mapx(sub);
            vCand = dm(ind);
            %}
            
            function sub = bound_sub(sub, dim)
                bound = repmat(dim, size(sub,1), 1);
                sub(sub<1) = 1;
                bi = sub > bound;
                sub(bi) = bound(bi);
            end
        end
    end
end

