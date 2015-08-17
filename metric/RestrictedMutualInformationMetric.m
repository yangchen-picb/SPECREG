classdef RestrictedMutualInformationMetric < handle
    % RestrictedMutualInformationMetric class
    
    properties
        restrictedind
        adjustFactor
    end
    
    methods
        function MI = RestrictedMutualInformationMetric()
            MI.adjustFactor = 0.25;
			MI.restrictedind = [];
        end

        function dist = compute(MI, x, y)
            dist = - MI.compute_mutual_information(x, y);
        end

        function MI = set_restrictedind(MI, resind)
            MI.restrictedind = resind;
        end

        function MI = set_adjustFactor(MI, af)
            MI.adjustFactor = af;
        end
    end
            
    % restricted mutual information
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
            
            thres = MI.adjustFactor;
            Xb = MI.restrictedind(1);
            Yb = MI.restrictedind(2);
                        
            XY(:, 1) = X;
            XY(:, 2) = Y;
            
            % TODO: should put outside
            h = accumarray(XY, 1, [max([X(:); Xb]), max([Y(:); Yb])]); % joint histogram
            
            hm = h;
            st = sum(hm(Xb, :)) + sum(hm(:, Yb)) - 2 * hm(Xb, Yb);
            hm(Xb, :) = h(Xb, :) * (1 - thres);
            hm(:, Yb) = h(:, Yb) * (1 - thres);
            hm(Xb, Yb) = h(Xb, Yb) + thres * st;
            
            Pxy = h./sum(h(:));  % joint distribution
            Pm = hm./sum(hm(:));  % modified joint distribution
            Py = sum(Pxy, 1);
            Px = sum(Pxy, 2);
            
            Hy = -sum(Py .* log2(Py + eps));  % Entropy of Y
            Hx = -sum(Px .* log2(Px + eps));  % Entropy of X
            %Hy = -sum(Py .* log2(sum(Pm, 1) + eps));  % Entropy of Y
            %Hx = -sum(Px .* log2(sum(Pm, 2) + eps));  % Entropy of X
            Hxy = -sum(Pxy(:) .* (log2(Pm(:) + eps)));  % joint entropy
            
            %H = Hxy - Hy;
            I = Hx + Hy - Hxy; % mutual information
            
            % bound, uncool
            if I < 0, I = 0; end
        end

    end
end
