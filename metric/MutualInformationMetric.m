classdef MutualInformationMetric < handle
    % Mutual Information class
    
    properties
        %nBins
    end
    
    methods
        function MI = MutualInformationMetric()
            %MI.nBins = 20;
        end
        
        %{
        function set_nBins(MI, nBins)
            MI.nBins = nBins;
        end
        
        function dist = compute(MI, x, y)
            edges = linspace(min(x(:)), max(x(:))+eps, MI.nBins+1);
            [c, X] = histc(x, edges);
            edges = linspace(min(y(:)), max(y(:))+eps, MI.nBins+1);
            [c, Y] = histc(y, edges);
            
            Hm = -log2(1/numel(x));
            dist = Hm - MI.compute_mutual_information(X, Y);
        end
        %}
        function dist = compute(MI, x, y)
            dist = - MI.compute_mutual_information(x, y);
        end
    end
    
    methods(Access = private)
        function I = compute_mutual_information(MI, X, Y)
            % mi = compute_mutual_information(im1, im2)
            %
            % Compute the mutual information of two images X and Y.
            % X, Y should be double
            %
            % 2013-02-05
            % 2013-03-24
            %
            
            X = X(:) - min(X(:)) + 1;
            Y = Y(:) - min(Y(:)) + 1;

            XY(:, 1) = X;
            XY(:, 2) = Y;
            h = accumarray(XY, 1); % joint histogram
            
            Pxy = h./sum(h(:)); % normalized joint histogram
            Py = sum(Pxy, 1);
            Px = sum(Pxy, 2);
            %Py = sum(Pxy, 1) / sum(Pxy(:));
            %Px = sum(Pxy, 2) / sum(Pxy(:));
            
            Hy = -sum(Py .* log2(Py + eps)); % Entropy of Y
            Hx = -sum(Px .* log2(Px + eps)); % Entropy of X
            Hxy = -sum(Pxy(:) .* (log2(Pxy(:) + eps))); % joint entropy
            
            I = Hx + Hy - Hxy; % mutual information
        end
    end
end

