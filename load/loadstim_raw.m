function stim = loadstim(sample, isResized)
% stim = loadstim(sample)
%
% 2013-03-23
%
    
    %basepath = '/picb/patterns/yangchen/Dataset';
    currentFile = mfilename('fullpath');
    sep = strfind(currentFile, filesep);
    currentPath = currentFile(1:sep(end));
    basepath = [currentPath '../../Dataset/'];

    if nargin < 2
        isResized = true;
    end

    if nargin < 1
        sample = 'Wi73501';
    end
    
    disp '  loading stained images';
    
    switch sample
    case 'Wi73501',
        impath = [basepath '/Wi73501/StainedImage/stained_big.tif'];
        if isResized
            impath = [basepath '/Wi73501/StainedImage/stained_normal.tif'];
        end
    case '3803',
        impath = [basepath '/HEregister/3803/3803_Ubersicht_Krankenhaus.tif'];
        if isResized
            impath = './Resources/stim_3803_scaled.tif';
        end
    case 'W99205',
        impath = [basepath '/HEregister/W99205/HE_images/W99205_Ubersicht_Krankenhaus.tif'];
        if isResized
            %impath = './Resources/stim_W99205_scaled_1.44_cutted.tif';
            impath = './Resources/stim_W99205_manually_scaled_cutted.tif';
        end
    case 'Wi220100',
        impath = [basepath '/HEregister/Wi220100/Wi2201_00_10fach/Wi2201_00_10fach_Overview.tif'];
        if isResized
            impath = './Resources/stim_Wi220100_scaled.tif';
        end
    case 'B107',
        impath = [basepath  'B107/107_2_HE.tif'];
        if isResized
            impath = './Resources/stim_B107_scaled.tif';
        end
        
        case 'E138207',
            impath = [basepath  'newdata2013/lungno5_full.jpg'];
            if isResized
                impath = './Resources/stim_E138207_scaled.tif';
            end
            
        case '88180'
            impath = [basepath  'newdata2013/lungno5_full.jpg'];
            if isResized
                impath = './Resources/stim_88180_scaled.tif';
            end
            
        case 'A1'
            if isResized
                impath = './Resources/stim_A1_scaled.tif';
            end
            
        case '78878'
            if isResized
                impath = './Resources/stim_78878_scaled.tif';
            end

    end

    stim = imread(impath);

    % remove alpha channel
    if size(stim, 3) > 3
        stim = stim(:,:,1:3);
    end

    disp '  finish loading stained images';

end

