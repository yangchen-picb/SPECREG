function tau = tform2tau(tform)
% tau = tform2tau(tform)
% convert tform structure to tau, only for similarity transformation

% 2014-10-14

tau = zeros(1, 4);

a = tform.T(1,1);  %s\cos\theta
b = tform.T(1,2);  %s\sin\theta

tau(4) = sqrt(a*a + b*b);
tau(:,3) = atand(b/a);
tau(2) = tform.T(3,2);
tau(1) = tform.T(3,1);

tau(4) = tau(4) - 1;

