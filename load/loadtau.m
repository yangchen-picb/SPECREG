function trueTau = loadtau(sample, isResized)
% trueTau = loadtau(sample, isResized)
%
%

    s = load(['trueTau_' sample '.mat'], 'trueTau');
    trueTau = s.trueTau;

end
