function vu = get_variation_unit_of_rotation(targim, resol)
% vu = get_variation_unit_of_rotation(targim, resol = 0.01)
%
% 2013-04-25
%

    if nargin < 2
        resol = 0.01;
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
            vu = dt;
            break;
        end
    end
end
