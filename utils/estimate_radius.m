function [radius] = estimate_radius(targim, targmask, metric, vu)
% [radius] = estimate_radius(targim, targmask, metric, vu)
%
% 2013-04-25
%

    if nargin < 4
        vu = [1 1 get_variation_unit_of_rotation(targim, 0.1) get_variation_unit_of_scaling(targim)];
    end
    
    if nargin < 3
        metric = RestrictedMutualInformationMetric;
    end
    
    tau = [0 0 0 0];
    
    %txrange = (tau(1)-rad:1:tau(1)+rad) * vu(1);
    %tyrange = (tau(2)-rad:1:tau(2)+rad) * vu(2);
    %tarange = (tau(3)-rad:1:tau(3)+rad) * vu(3);
    rad = ([size(targim,2), size(targim,1), 90, 2]/2);
    txrange = tau(1)-rad(1):vu(1):tau(1)+rad(1);
    tyrange = tau(2)-rad(2):vu(2):tau(2)+rad(2);
    tarange = tau(3)-rad(3):vu(3):tau(3)+rad(3);
    tsrange = tau(4)-rad(4):vu(4):tau(4)+rad(4);
    dim = [length(txrange), length(tyrange), length(tarange), length(tsrange)];
    
    trans = SimilaritySpace(targim, targim);
    trans.set_lim(targim, targim, 0);
    eva = Evaluator(targim, targim, 'metric', metric, 'transform', trans);
    eva.set_mask(targmask, targmask);
    
    %ht = -eva.eval_unbound(tau);
    
    taux = [txrange' repmat(tau(2:4),dim(1),1)];
    tauy = [repmat(tau(1),dim(2),1) tyrange' repmat(tau(3:4),dim(2),1)];
    taua = [repmat(tau(1:2),dim(3),1) tarange' repmat(tau(4),dim(3),1)];
    taus = [repmat(tau(1:3),dim(4),1) tsrange'];
    
    vx = -eva.eval(taux)';
    vy = -eva.eval(tauy)';
    va = -eva.eval(taua)';
    vs = -eva.eval(taus)';
        
    mid = ceil(dim/2);
    vx(mid(1)-1:mid(1)+1) = min(vx(mid(1)-1), vx(mid(1)+1));
    vy(mid(2)-1:mid(2)+1) = min(vy(mid(2)-1), vy(mid(2)+1));
    va(mid(3)-1:mid(3)+1) = min(va(mid(3)-1), va(mid(3)+1));
    vs(mid(4)-1:mid(4)+1) = min(vs(mid(4)-1), vs(mid(4)+1));
    
    %thresx = min(vx) + (min(vx(mid(1)-1), vx(mid(1)+1)) - min(vx))/2;
    %thresy = min(vy) + (min(vy(mid(2)-1), vy(mid(2)+1)) - min(vx))/2;
    %thresa = min(va) + (min(va(mid(3)-1), va(mid(3)+1)) - min(va))/2;
    %thress = min(vs) + (min(vs(mid(4)-1), vs(mid(4)+1)) - min(vs))/2;
    
    %[ex, lx, rx] = peak_width(vx, ceil(dim(1)/2));
    %[ey, ly, ry] = peak_width(vy, ceil(dim(2)/2));
    %[ea, la, ra] = peak_width(va, ceil(dim(3)/2));
    %[es, ls, rs] = peak_width(vs, ceil(dim(4)/2));
    
    [ex, lx, rx, thresx] = fwhm(vx, ceil(dim(1)/2));
    [ey, ly, ry, thresy] = fwhm(vy, ceil(dim(2)/2));
    [ea, la, ra, thresa] = fwhm(va, ceil(dim(3)/2));
    [es, ls, rs, thress] = fwhm(vs, ceil(dim(4)/2));
    
    %bw = [ex ey ea es] / 2;
    %ibw = floor(bw);
    radius = [ex ey ea es];  % only for making it an even number
    %radius = floor([ex ey ea es] / 2)

    if nargout < 1
        figure; plot(txrange, vx);
        %hold on; plot(txrange(lx), vx(lx), 'rx'); plot(txrange(rx), vx(rx), 'rx');
        %line([txrange(lx), txrange(rx)], [vx(lx), vx(rx)], 'color', 'r');
        line([txrange(1), txrange(end)], [thresx, thresx], 'color', 'r');
        %hold on; plot(tau(1) + [-bw(1) 0 bw(1)], [0, ht 0], 'r-');
        %title('\tx'); 
        xlabel('\tau_x', 'fontsize', 15); ylabel('Mutual Information', 'fontsize', 15);
        savefigure('etx.eps');
        
        figure; plot(tyrange, vy);
        %hold on; plot(tyrange(ly), vy(ly), 'r+'); plot(tyrange(ry), vy(ry), 'r+');
        %hold on; plot(tau(2) + [-bw(2) 0 bw(2)], [0, max(vy) 0], 'r-');
        line([tyrange(1), tyrange(end)], [thresy, thresy], 'color', 'r');
        %hold on; plot(tau(2) + [-bw(2) 0 bw(2)], [0, ht 0], 'r-');
        %title('ty');
        xlabel('\tau_y', 'fontsize', 15); ylabel('Mutual Information', 'fontsize', 15);
        savefigure('ety.eps');
        
        figure; plot(tarange, va);
        %hold on; plot(tarange(la), va(la), 'r+'); plot(tarange(ra), va(ra), 'r+');
        %hold on; plot(tau(3) + [-bw(3) 0 bw(3)], [0, max(va) 0], 'r-');
        line([tarange(1), tarange(end)], [thresa, thresa], 'color', 'r');
        %hold on; plot(tau(3) + [-bw(3) 0 bw(3)], [0, ht 0], 'r-');
        %title('ta');
        xlabel('\tau_a', 'fontsize', 15); ylabel('Mutual Information', 'fontsize', 15);
        savefigure('eta.eps');
        
        figure; plot(tsrange, vs);
        %hold on; plot(tsrange(ls), vs(ls), 'r+'); plot(tsrange(rs), vs(rs), 'r+');
        %hold on; plot(tau(4) + [-bw(4) 0 bw(4)]*vu(4), [0, max(vs) 0], 'r-');
        line([tsrange(1), tsrange(end)], [thress, thress], 'color', 'r');
        %hold on; plot(tau(3) + [-bw(3) 0 bw(3)], [0, ht 0], 'r-');
        %title('ts');
        xlabel('\tau_s', 'fontsize', 15); ylabel('Mutual Information', 'fontsize', 15);
        savefigure('ets.eps');

    end
end

function [w, left, right] = peak_width(v, loc, thres)
    if nargin < 3
        thres = 0.01;
    end
    % abs is not correct£?
    dv = abs(sgdiff(v, 1, 5, 2));
    left = find(dv(loc-1:-1:1) < thres, 1);
    right = find(dv(loc+1:end) < thres, 1);
    w = left + right - 1;
    left = loc - left;
    right = loc + right;
end

function [w, left, right, thres] = fwhm(v, loc, thres)
    if nargin < 3
        %thres = (min(v(loc-1:loc+1)))/2;
        btm = max(min(v(:)), 0); top = min(v(loc-1:loc+1));
        thres = btm + (top - btm)/2;
    end
    left = find(v(loc-1:-1:1) < thres, 1);
    if isempty(left), left = floor((length(v)-1) / 4); end
    right = find(v(loc+1:end) < thres, 1);
    if isempty(right), right = floor((length(v)-1) / 4); end
    w = left + right;
    left = loc - left;
    right = loc + right;
end

function [di, ddi] = sgdiff(C, p, F, N)
%[di, ddi] = sgdiff(C, order, F = 9, N = 4)
%

    if nargin < 4
        N = 4;                 % Order of polynomial fit
    end
    if nargin < 3
        F = 9;                 % Window length
    end
    if nargin < 2
        p = 1;
    end

    [b,g] = sgolay(N,F);   % Calculate S-G coefficients

    Nm = size(C,1);
    Na = size(C,2);

    w  = ((F+1)/2) -1;
    di = zeros(Nm, Na);
    ddi = zeros(Nm, Na);
    for i=(F+1)/2:Na-(F-1)/2
        di(:,i) = factorial(p) * C(:,i-w:i+w) * g(:,p+1); 
        ddi(:,i) = factorial(p+1) * C(:,i-w:i+w) * g(:,p+2);
    end
        
end
