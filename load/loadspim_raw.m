function [spim, spmask] = loadspim(sample, id)
% spim = loadspim(sample, id = 'all')
%
% if id is a vector, return a cell array.
%

    disp '  loading spectral images';

    %basepath = '/picb/patterns/yangchen/Dataset/';
    currentFile = mfilename('fullpath');
    sep = strfind(currentFile, filesep);
    currentPath = currentFile(1:sep(end));
    basepath = [currentPath '../../Dataset/'];

    % REF DATASET
    sppath_Wi73501 = { ...
    'Wi73501/SpectralImage/impart1_spectralimage_200wavenumbers.mat'
    'Wi73501/SpectralImage/impart2_spectralimage_200wavenumbers.mat'
    'Wi73501/SpectralImage/impart3_spectralimage_200wavenumbers.mat'
    'Wi73501/SpectralImage/impart4_spectralimage_200wavenumbers.mat'
    'Wi73501/SpectralImage/impart5_spectralimage_200wavenumbers.mat'
    'Wi73501/SpectralImage/impart6_spectralimage_200wavenumbers.mat'
    'Wi73501/SpectralImage/impart7_spectralimage_200wavenumbers.mat' };

    % DATASET 1 - Wi220100:
    sppath_Wi220100 = { ...
    'HEregister/Wi220100/110509_Wi220100/mat_files/110509_Wi220100_3bis27_4_single_hierarchy.mat', ...
    'HEregister/Wi220100/110603_Wi220100/mat_files/110603_W220100_3bis18_4_single_hierarchy.mat', ...
    'HEregister/Wi220100/110610_W220100/mat_files/110610_Wi220100_0bis23_4_single_hierarchy.mat' };

    % DATASET 2 - 3803
    sppath_3803 = { ...
    'HEregister/3803/110512_3803/mat_files/110512_3803_2bis25_4_single_hierarchy.mat', ...
    'HEregister/3803/110519_3803/mat_files/110519_3803_0bis27_4_single_hierarchy.mat', ...		   
    'HEregister/3803/110526_3803/mat_files/110526_3803_1bis29_4_single_hierarchy.mat', ...   
    'HEregister/3803/110530_3803/mat_files/110530_3803_1bis27_4_single_hierarchy.mat', ...	   
    'HEregister/3803/110531_3803/mat_files/110531_3803_0bis30_4_single_hierarchy.mat' };            

    %DATASET 2 - W99205
    sppath_W99205 = { ...
    'HEregister/W99205/110511_W99205/mat_files/110511_W99205_1bis29_4_single_hierarchy.mat', ...
    'HEregister/W99205/110518_W99205/mat_files/110518_W99205_0bis29_4_single_hierarchy.mat', ... 
    'HEregister/W99205/110524_W99205/mat_files/110524_2_W99205_0bis15_4_single_hierarchy.mat', ...  
    'HEregister/W99205/110601_W99205/mat_files/110601_W99205_3bis28_4_single_hierarchy.mat', ...
    'HEregister/W99205/110614_2_W99205/mat_files/110614_2_W99205_0bis3_test_4_single_hierarchy.mat', ...
    'HEregister/W99205/110614_W99205/mat_files/110614_W99205_0bis19_4_single_hierarchy.mat' };   

    wavenumberpath = [basepath 'wavenumbers.mat'];
    
    sppath = eval(['sppath_' sample]);

    if nargin < 2
        %C200 = eval(['length(sppath_' sample ')']);
        %return;
        id = 1:length(sppath);
    end

    t = load(wavenumberpath);
    WN_corr = t.WN_corr;

    spim = cell(length(id), 1);
    spmask = cell(length(id), 1);
    for i = 1:length(id)
        t = load([basepath sppath{id(i)}]);
        %TODO: use raw
        if strcmp(sample, 'Wi73501')
            C200 = t.C200;
        else
            C = t.C;
            [C200, WN200]=reduce_points(C, WN_corr, 950, 1790, 200);
        end
        spim{i} = C200;
        spmask{i} = ~isnan(C200(:,:,1));
    end

    if length(spim) == 1
        spim = spim{1};
        spmask = spmask{1};
    end

    disp '  finish loading spectral images';

end

