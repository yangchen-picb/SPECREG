function stim = loadstim(sample, isResized)
% load stained image
% just for the sake of convenient
% stim = loadstim(sample, isResized)
%
% 2013-03-23
%
    
    %basepath = '/picb/patterns/yangchen/Dataset';
    %currentFile = mfilename('fullpath');
    %sep = strfind(currentFile, filesep);
    %currentPath = currentFile(1:sep(end));
    %basepath = [currentPath '../../Dataset/'];

    if nargin < 2
        isResized = true;
    end

    if nargin < 1
        sample = 'Wi73501';
    end
    
    disp '  loading stained images';
    
    if isResized
        impath = which(['stim_' sample '_scaled.tif']);
    else
        
    end

    stim = imread(impath);

    % remove alpha channel
    if size(stim, 3) > 3
        stim = stim(:,:,1:3);
    end

    disp '  finish loading stained images';

end

