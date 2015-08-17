classdef MeanSquareDifferenceMetric < handle
    
    properties
    end
    
    methods
        function MI = MeanSquareDifferenceMetric()
        end
        
        function dist = compute(MI, x, y)
            dist = mean((x - y) .^ 2);
        end
    end
end
