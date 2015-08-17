classdef WardMetric < handle
    % Ward
    
    methods
        function dist = compute(WD, cl, v)
            %dist = sum(var(v) * (numel(cl) - 1));
            dist = 0;
            for c = unique(cl)'
                ci = cl==c;
                dist = dist + sum(var(v(ci,:))*(sum(ci)-1));
            end
            dist = dist / sum(var(v) * (numel(cl) - 1));
        end
    end
end
 