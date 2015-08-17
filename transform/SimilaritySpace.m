classdef SimilaritySpace < TransformSpace
    % Similarity Transform Space
    % transform parameters t = [tx, ty, ta, ts];
    
    methods
        function SS = SimilaritySpace(mvim, fxim)
            % default values in config should be as tight as possible, default values in function should be as loose as possible
            SS.lb = [0, 0, -180, -0.5];
            SS.ub = [size(fxim,2)-1, size(fxim,1)-1, 180, 0.5];
            SS.varunit = SS.compute_varunit(mvim);
            SS.overlapThres = 0.5;
        end
        
        function [fxx, fxy] = mapping(SS, mvx, mvy, tau)
            RM = [cosd(tau(3)), -sind(tau(3)); sind(tau(3)), cosd(tau(3))];
            rotxy = (1 + tau(4)) * [mvx(:), mvy(:)] * RM';
            fxx = rotxy(:,1) + tau(1);
            fxy = rotxy(:,2) + tau(2);
        end
        
        function [mvx, mvy] = back_mapping(SS, fxx, fxy, tau)
            RM = [cosd(tau(3)), sind(tau(3)); -sind(tau(3)), cosd(tau(3))];
            xy = 1/(1+tau(4)) * [fxx(:)-tau(1), fxy(:)-tau(2)] * RM';
            mvx = xy(:,1);
            mvy = xy(:,2);
        end
        
        %TODO: integrate all space2mat
        function m = space2mat(RS, sub, val)
            dim = floor((RS.ub - RS.lb) ./ RS.varunit) + 1;
            m = Inf * ones(dim(2), dim(1), dim(3), dim(4));
            ind = sub2ind(size(m), sub(:,2), sub(:,1), sub(:,3), sub(:,4));
            m(ind) = val;
        end        
    end
end
