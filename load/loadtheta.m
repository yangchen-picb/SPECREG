function trueTheta = loadtheta(sample, isResized)
% trueTheta = loadtheta(sample, isResized)
%
% if the corresponding file doesnot exist, return [].
%

    switch sample
        case 'Wi73501',
            if isResized
                load trueTheta_of_Wi73501_scaled_stim.mat trueTheta;
            else
                load trueTheta_of_Wi73501.mat trueTheta;
            end
                        
        case 'Wi220100',
            if isResized
                load trueTheta_of_Wi220100_scaled_stim.mat trueTheta;
            else
                load trueTheta_of_Wi220100.mat trueTheta;
            end
            
        otherwise
            try
                s = load(['trueTheta_' sample '.mat'], 'trueTheta');
                trueTheta = s.trueTheta;
            catch
                %trueTheta = get_theta_from_params(ones(nSpim, 2), zeros(nSpim, 1), 1);
                trueTheta = [];
            end
    end

end

