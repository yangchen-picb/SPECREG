classdef ConditionalCumulativeResidualEntropyMetric < handle
    % Conditional Entropy class
    
    properties
        nBins
    end
    
    methods
        function CCRE = ConditionalCumulativeResidualEntropyMetric()
            CCRE.nBins = 256;
        end
        
        function dist = compute(CCRE, x, y)
            % dist = compute(CE, x, y)
            %
            dist = CCRE.compute_conditional_cre(x, y);
        end
    end
    
    methods(Access = private)
        function Ecre = compute_conditional_cre(CCRE, X, Y)
            % H = compute_conditional_cre(X, Y)
            %
            % Compute the conditional cre Ecre(X|Y).
            % X, Y should be double
            %
            % 2013-05-02
            %
            
            X = X(:) - min(X(:)) + 1;
            Y = Y(:) - min(Y(:)) + 1;

            XY(:, 1) = X(:);
            XY(:, 2) = Y(:);
            h = accumarray(XY, 1, [CCRE.nBins, CCRE.nBins]); % joint histogram
            %h = accumarray(XY, 1);
            
            ch = cumsum(h);
            
            Py = ch(end,:) / sum(ch(end,:) + eps);
            Pxcy = ch ./ repmat(ch(end,:) + eps, size(ch,1), 1);
            ccre = -sum(Pxcy .* log2(Pxcy + eps));
            Ecre = sum(ccre .* Py);
        end
    end
end
