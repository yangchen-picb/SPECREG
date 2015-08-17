classdef ConditionalEntropyMetric < handle
    % Conditional Entropy Metric class
    
    properties
    end
    
    methods
        function CE = ConditionalEntropyMetric()
        end
        
        function dist = compute(CE, x, y)
            % dist = compute(CE, x, y)
            %            
            dist = CE.compute_conditional_entropy(x, y);
        end
        
        function dist = compute_multi_channel(CE, x, y)
            % dist = compute(CE, x, y)
            %
            % x, y is two vector, y can be a matrix.
            %
            dist = 0;
            for i = 1:size(y, 2)
                dist = dist + CE.compute_conditional_entropy(x, y(:,i));
            end
        end
    end
    
    methods(Access = private)
        function H = compute_conditional_entropy(~, X, Y)
            % H = compute_conditional_entropy(X, Y)
            %
            % Compute the conditional entropy H(X|Y).
            % X, Y should be double
            %
            % 2013-05-02
            %
            
            X = X(1:length(Y));
            X = X(:) - min(X(:)) + 1;
            Y = Y(:) - min(Y(:)) + 1;
            
            XY(:, 1) = X;
            XY(:, 2) = Y;
            h = accumarray(XY, 1); % joint histogram
            
            Pxy = h./sum(h(:)); % normalized joint histogram
            Pxy = h/4;
            Py = sum(Pxy, 1);
            %Px = sum(Pxy, 2);
            
            Hy = -sum(Py .* log2(Py + eps)); % Entropy of Y
            %Hx = -sum(Px .* log2(Px + eps)); % Entropy of X
            Hxy = -sum(Pxy(:) .* (log2(Pxy(:) + eps))); % joint entropy
            
            H = Hxy - Hy;
            %I = Hx + Hy - Hxy; % mutual information
        end
    end
end
