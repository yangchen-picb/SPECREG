function theta = tau2theta(tau)
% theta = tau2theta(tau)
%

% 2013-05-22
%

    tau4 = zeros(size(tau,1), 4);
    tau4(:,1:size(tau,2)) = tau;
    tau = tau4;

    theta = zeros(4, size(tau,1));
    theta(1,:) = (1+tau(:,4)') .* cosd(tau(:,3))';
    theta(2,:) = (1+tau(:,4)') .* sind(tau(:,3))';
    theta(3:4,:) = tau(:,1:2)';

end