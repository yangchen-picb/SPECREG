function stsift = loadsift(sample, isResize)


    switch sample
    case 'Wi73501',
        impath = [basepath '/Wi73501/StainedImage/stained_big.tif'];
        if isResized
            impath = [basepath '/Wi73501/StainedImage/stained_normal.tif'];
        end
    case '3803',
        impath = [basepath '/HEregister/3803/3803_Ubersicht_Krankenhaus.tif'];
        if isResized
            impath = './Resources/stained_image_of_3803_rescaled.tif';
        end
    case 'W99205',
        impath = [basepath '/HEregister/W99205/HE_images/W99205_Ubersicht_Krankenhaus.tif'];
        if isResized
            error(['We donnot know the scale factor of sample ' sample]);
        end
    case 'Wi220100',
        impath = [basepath '/HEregister/Wi220100/Wi2201_00_10fach/Wi2201_00_10fach_Overview.tif'];
        if isResized
            impath = './Resources/stained_image_of_Wi220100_rescaled.tif';
        end

    end

    stsift = refrsift;

end
