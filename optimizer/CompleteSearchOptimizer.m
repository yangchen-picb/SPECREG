classdef CompleteSearchOptimizer < handle
    % Conditional Entropy class
    
    properties
    end
    
    methods
        function CS = CompleteSearchOptimizer()
        end
                
        function [x, fval, dm] = run(CS, fun, space, startPoints)
            
            lb = space.lb;
            ub = space.ub;
            varunit = space.varunit;
            
            mapx = @(s)repmat(lb,size(s,1),1) + (s - 1) .* repmat(varunit,size(s,1),1);
            
            dim = floor((ub - lb) ./ varunit) + 1;
            
            lind = ones(size(dim));
            uind = dim;
            
            range = arrayfun(@(s,e) s:e, lind, uind, 'UniformOutput', false);
            sub = cell(size(lb));
            [sub{:}] = ndgrid(range{:});
            sub = cellfun(@(x) x(:), sub, 'UniformOutput', false);
            sub = cell2mat(sub);
            
            % computed sub and values
            computedSub = sub;
            computedVal = fun(mapx(sub));
            
            dm = space.space2mat(computedSub, computedVal);
            %{
            dm = Inf * ones(dim);
            sub = mat2cell(computedSub, size(computedSub,1), ones(size(dim)));
            ind = sub2ind(size(dm), sub{:});
            dm(ind) = computedVal;
            %}
            [fval, mi] = min(computedVal);
            x = mapx(computedSub(mi));
            
        end
    end
end

