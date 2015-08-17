classdef ConditionalEntropyMetric2 < handle
    % Conditional Entropy Metric class
    
    properties
    end
    
    methods
        function CE = ConditionalEntropyMetric2()
        end
                
        function dist = compute(CE, x, y, xb, yb)
            % dist = compute(CE, x, y)
            %            
            dist = CE.compute_conditional_entropy(x, y, xb, yb);
        end
        
        function dist = compute_multi_channel(CE, x, y, xb, yb)
            % dist = compute(CE, x, y)
            %
            % x, y is two vector, y can be a matrix.
            %
            dist = 0;
            for i = 1:size(y, 2)
                dist = dist + CE.compute_conditional_entropy(x, y(:,i), xb, yb);
            end
        end
    end
    
    methods(Access = private)        
        % restricted mutual information
        function H = compute_conditional_entropy(~, X, Y, Xb, Yb)
            % H = compute_conditional_entropy(X, Y)
            %
            % Compute the conditional entropy H(X|Y).
            % X, Y should be double, and contains only positive integers.
            %
            % 2013-05-02
            %
            
            thres = 0.5;
                        
            XY(:, 1) = X;
            XY(:, 2) = Y;
            
            % TODO: should put outside
            h = accumarray(XY, 1, [max([X(:); Xb]), max([Y(:); Yb])]); % joint histogram
            
            hm = h;
            st = sum(hm(Xb, :)) + sum(hm(:, Yb)) - hm(Xb, Yb);
            hm(Xb, :) = hm(Xb, :) * (1 - thres);
            hm(:, Yb) = hm(:, Yb) * (1 - thres);
            hm(Xb, Yb) = hm(Xb, Yb) + thres * st;
            
            Pxy = h./sum(h(:));  % joint distribution
            Pm = hm./sum(hm(:));  % modified joint distribution
            Py = sum(Pxy, 1);
            %Px = sum(Pxy, 2);
            
            Hy = -sum(Py .* log2(Py + eps)); % Entropy of Y
            %Hx = -sum(Px .* log2(Px + eps)); % Entropy of X
            Hxy = -sum(Pxy(:) .* (log2(Pm(:) + eps))); % joint entropy
            
            H = Hxy - Hy;
            %I = Hx + Hy - Hxy; % mutual information
        end

    end
end
