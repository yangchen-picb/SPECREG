classdef RigidSpace < TransformSpace
    % Rigid Transform Space
    % transform parameters t = [tx, ty, ta]
    
    methods
        function RS = RigidSpace(mvim, fxim)
            RS.lb = [0, 0, -180];
            RS.ub = [size(fxim,2)-1, size(fxim,1)-1, 180];
            RS.varunit = RS.compute_varunit(mvim);
            RS.overlapThres = 0.5;
        end
        
        function [fxx, fxy] = mapping(RS, mvx, mvy, tau)
            RM = [cosd(tau(3)), -sind(tau(3)); sind(tau(3)), cosd(tau(3))];
            rotxy = [mvx(:), mvy(:)] * RM';
            fxx = rotxy(:,1) + tau(1);
            fxy = rotxy(:,2) + tau(2);
        end
        
        function m = space2mat(RS, sub, val)
            dim = floor((RS.ub - RS.lb) ./ RS.varunit) + 1;
            m = Inf * ones(dim(2), dim(1), dim(3));
            ind = sub2ind(size(m), sub(:,2), sub(:,1), sub(:,3));
            m(ind) = val;
        end
    end
end
