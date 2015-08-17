function regopt = reg_options(txt)
    % default options of spectral-stained registration
    % regopt = reg_options(txt)
    % txt can be:
    %   'template matching'  (default)
    %   'full registration'
    %

    if strcmp(txt, 'full registration')
        regopt.nClSp = 10;  % number of clusters of spectral image
    else
        regopt.nClSp = 8;  
    end  %just for keeping consistency
    regopt.nClSt = 10;  % number of clusters of stained image
    regopt.rgbThres = [];  % color above which is regarded as background, [] empty vector for estimating from Otsu's method using graythresh function.
    regopt.distThres = 0.01;  % pixels around background color vector within this threshold will also be regard as background.
    
    % registration parameters
    regopt.params = reg_defaults(txt);

end