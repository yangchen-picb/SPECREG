function [cl, k, eval] = xmeans(X, mink, maxk)

    mink = num2str(mink);
    maxk = num2str(maxk);
    randseed = num2str(randi(100, 1, 1));
    
    clusterer = weka.clusterers.XMeans;
    clusterer.setOptions(wekaoption(['-L ' mink ' -H ' maxk ' -S ' randseed]));
    
    inst = matlab2weka(X);
    clusterer.buildClusterer(inst);
    
    eval = weka.clusterers.ClusterEvaluation;
    eval.setClusterer(clusterer);
    eval.evaluateClusterer(inst);
    
    cl = eval.getClusterAssignments() + 1;
    k = eval.getNumClusters();
    
end
