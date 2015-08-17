function msilh = choose_k_by_silhouette(values, ks, distance)
%
%    msilh = choose_k_by_silhouette(values, ks, distance)

    if nargin < 3
        distance = 'Euclidean';
    end

    msilh = zeros(numel(ks), 1);
    for i = 1:numel(ks)
        cl = kmeans(values, ks(i), 'Distance', distance);
        [silh] = silhouette(values, cl, distance);
        msilh(i) = mean(silh);
    end

end
