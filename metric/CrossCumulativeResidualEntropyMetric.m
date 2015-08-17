classdef CrossCumulativeResidualEntropyMetric < handle
    % Conditional Entropy class
    
    properties
        nBins
    end
    
    methods
        function CCRE = CrossCumulativeResidualEntropyMetric()
            CCRE.nBins = 256;
        end
        
        function dist = compute(CCRE, x, y)
            % dist = compute(CE, x, y)
            %
            dist = -CCRE.compute_conditional_cre(x, y);
        end
        %{
        function dist = compute(CCRE, x, y)
            dist = 0;
            for i = 1:size(y,2)
                dist = dist - CCRE.compute_conditional_cre(y(:,i), x);
            end
        end
        %}
    end
    
    methods(Access = private)
        function Cxy = compute_conditional_cre(CCRE, X, Y)
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
            %unique(h', 'rows')'
            
            ch = cumsum(h);
            %unique(ch', 'rows')'
            
            Fx = sum(ch, 2) / sum(ch(end,:));
            Rx = -sum(Fx .* log2(Fx + eps));
            
            Py = ch(end,:) / sum(ch(end,:));
            Fxcy = ch ./ repmat(ch(end,:) + eps, size(ch,1), 1);
            Rxcy = -sum(Fxcy .* log2(Fxcy + eps));
            Excy = sum(Rxcy .* Py);
            Cxy = Rx - Excy;
            
            %{
            chy = cumsum(h, 2);
            Fy = sum(chy, 2) / sum(chy(end,:));
            Ry = -sum(Fy .* log2(Fy + eps));
            %Fy = cumsum(Py);
            Px = chy(end,:) / sum(chy(end,:));
            Fycx = chy ./ repmat(chy(end,:) + eps, size(chy,1), 1);
            Rycx = -sum(Fycx .* log2(Fycx + eps));
            Eycx = sum(Rycx .* Px);
            
            Cxy = Rx - Excy + Ry - Eycx;
            %}
        end
    end
end
