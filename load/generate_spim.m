
    clear;

    opt.sample = '3803';
    [spimArray, spmaskArray] = loadspim_raw(opt.sample);
    save spim_3803.mat;

    clear;

    opt.sample = 'W99205';
    [spimArray, spmaskArray] = loadspim_raw(opt.sample);
    save spim_W99205.mat;

    clear;

    opt.sample = 'Wi220100';
    [spimArray, spmaskArray] = loadspim_raw(opt.sample);
    save spim_Wi220100.mat;

    clear;

    opt.sample = 'Wi73501';
    [spimArray, spmaskArray] = loadspim_raw(opt.sample);
    save spim_Wi73501.mat;

    clear;
