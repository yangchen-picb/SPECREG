function [cl, k] = gmeans(X, maxk)
    istest = false(1, maxk);
    istest(1) = true;
    k = 1;
    cl = ones(size(X,1),1);
    while any(istest)
        testc = find(istest)
        for c = testc
            if gfit(X(cl==c,:))
                istest(c) = false;
            else
                subcl = kmeans(X(cl==c,:), 2);
                subcl = subcl + k;
                subcl(subcl==k+2) = c;
                cl(cl==c) = subcl;
                istest(c) = true;
                istest(k+1) = true;
                k = k + 1;
            end
        end
        
        if k >= maxk
            disp 'maxk reached';
            break;
        end
    end
    
    function isg = gfit(subset)
        [coeff, score] = princomp(subset);
        pc = subset * coeff(:,1:2);
        isg = false;
        figure; hist(pc(:,1))
        %if ~adtest(pc(:,1)) && ~adtest(pc(:,2))
        [h, p] = adtest(pc(:,1))
        if p < 0.00001;
            isg = true;
            return;
        end
    end
end
