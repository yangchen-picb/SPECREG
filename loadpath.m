
	[p, n, e] = fileparts(mfilename('fullpath')) ;

    addpath(p);
    
	addpath([p '/examples/']);
	addpath([p '/load/']);
	addpath(genpath([p '/data/']));
	
    addpath([p '/metric/']);
    addpath([p '/transform/']);
    addpath([p '/optimizer/']);
    addpath([p '/evaluator/']);
	
    addpath(genpath([p '/utils/']));
    addpath(genpath([p '/preprocessing/']));
    
	addpath([p '/plot/']);