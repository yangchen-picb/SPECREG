classdef TransformSpace < handle
    % Transform Space base class
    
    properties
        lb
        ub
        varunit
        overlapThres
        targsiz
        refrsiz
    end
    
    methods
        function set_varunit(TS, varunit)
            if length(varunit) == length(TS.lb)
                TS.varunit = varunit;
            else
                error('The length of input varunit is incorrect');
            end
        end
        
        function set_lim(TS, mvim, fxim, overlap, talim, tslim)
            TS.lb(1:2) = [0 0];
            TS.ub(1:2) = [size(fxim,2), size(fxim,1)] - 1;

            %TODO: this place is strange
            if nargin > 3
                TS.lb(1:2) = TS.lb(1:2) - [(1-overlap) * size(mvim, 2) (1-overlap) * size(mvim,1)];
                TS.ub(1:2) = TS.ub(1:2) + [(1-overlap) * size(mvim, 2) (1-overlap) * size(mvim,1)];
                TS.overlapThres = overlap;
            end
            if nargin > 4
                TS.set_talim(talim);
            end
            if nargin > 5
                TS.set_tslim(tslim);
            end
        end
        
        %{
        function set_lim(TS, mvim, fxim, ttlim, talim, tslim)
            TS.lb(1:2) = [0 0];
            TS.ub(1:2) = [size(fxim,2), size(fxim,1)] - 1;
            if nargin > 3
                ttlim = ttlim .* [size(mvim,2) size(mvim,1)];
                TS.set_ttlim(ttlim);
            end
            if nargin > 4
                TS.set_talim(talim);
            end
            if nargin > 5
                TS.set_tslim(tslim);
            end
        end
        %}
        
        % Depracated
        function set_lim_by_image(TS, mvim, fxim)
            TS.lb(1:2) = [0 0];
            TS.ub(1:2) = [size(fxim,2), size(fxim,1)] - 1;
        end
        
        % Depracated
        function set_ttlim(TS, ttlim)
            % set the translation limit
            TS.lb(1:2) = TS.lb(1:2) - ttlim(1:2);
            TS.ub(1:2) = TS.ub(1:2) + ttlim(1:2);
        end
                
        function set_talim(TS, talim)
            % set the rotation limit
            if length(TS.lb) >= 3
                TS.lb(3) = talim(1);
                TS.ub(3) = talim(2);
            else
                error('The transform space doesnot include rotation!');
            end
        end
        
        function set_tslim(TS, tslim)
            % set the scaling limit
            if length(TS.lb) >= 4
                TS.lb(4) = tslim(1);
                TS.ub(4) = tslim(2);
            else
                error('The transform space doesnot include scaling!');
            end
        end
        
        function tauArray = rand_tau(TS, n)
            tauArray = zeros(n, length(TS.lb));
            for i = 1:length(TS.lb)
                range = (TS.lb(i):TS.varunit(i):TS.ub(i))';
                tauArray(:,i) = range(randi(length(range), n, 1));
            end
        end
        
        function vu = compute_varunit(TS, targim, resol)
            vu = ones(1, 4);
            
            if nargin < 3
                resol = 0.1;
            end
            
            %r = sqrt(x0(1)^2 + x0(2)^2);
            %theta = atand(x0(2)/x0(1));
            x0(1) = (size(targim,2)+1) / 2;
            x0(2) = (size(targim,1)+1) / 2;
            
            dt = 0;
            while true
                dt = dt + resol;
                
                xp = [cosd(dt) -sind(dt); sind(dt) cosd(dt)] * x0';
                xn = [cosd(dt) sind(dt); -sind(dt) cosd(dt)] * x0';
                
                % if sum(round(xp)==x0') < 2 || sum(round(xn)==x0') < 2
                if sum(abs(xp-x0') > 0.5) > 0 || sum(abs(xn-x0') > 0.5) > 0
                    %[xp xn]
                    vu(3) = dt;
                    break;
                end
            end
            vu(4) = 1 / min(x0);
            
            vu = vu(1:length(TS.lb));
        end
        
    end
end
