classdef TranslationSpace < TransformSpace
    % Translation Transform Space
    
    methods
        function TS = TranslationSpace(mvim, fxim)
            TS.lb = [0, 0];
            TS.ub = [size(fxim,2)-size(mvim,2), size(fxim,1)-size(mvim,1)];
            TS.varunit = [1 1];
        end
        
        function [fxx, fxy] = mapping(~, mvx, mvy, tau)
            fxx = mvx + tau(1);
            fxy = mvy + tau(2);
        end
                
        function m = space2mat(RS, sub, val)
            dim = floor((RS.ub - RS.lb) ./ RS.varunit) + 1;
            m = Inf * ones(dim(2), dim(1));
            ind = sub2ind(size(m), sub(:,2), sub(:,1));
            m(ind) = val;
        end
    end
end
