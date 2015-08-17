classdef RegressionErrorMetric
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function dist = compute(RE, x, y)
            x = reshape(x, size(y,1), numel(x)/size(y,1));
            validind = ~isnan(x(:,1));
            dist = 0;
            for i = 1:size(y,2)
                [~,~,r] = regress(y(validind), x(validind,:));
                dist = dist + sum(r .* r);
            end
        end
        
        function dist = compute_multi_channel(RE, x, y)
            x = reshape(x, size(y,1), numel(x)/size(y,1));
            validind = ~isnan(x(:,1));
            dist = 0;
            for i = 1:size(y,2)
                [~,~,r] = regress(y(validind), x(validind,:));
                dist = dist + sum(r);
            end
        end

    end
    
end

