function tau = theta2tau(theta)
% theta = tau2theta(tau)
%

% 2013-11-13
%

    tau = zeros(size(theta,2), 4);
    tau(:,1:2) = theta(3:4,:)';
    
    tau(:,3) = atand(theta(2,:) ./ theta(1,:));
    tau(:,4) = sqrt(theta(1,:) .^2 + theta(2,:) .^ 2) - 1;
end