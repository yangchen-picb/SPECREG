function nbcoord = get_neighbors_coord2(rad, ndim)
% nbcoord = get_neighbors_coord(rad, dim = 3)
%
% 2013-05-02
%

    if nargin < 2
        ndim = 3;
    end
    if nargin < 1
        rad = 1;
    end
    
    range = cell(1, ndim);
    range(:) = {[-rad:2*rad:rad]};
    
    coord = cell(1, ndim);
    
    [coord{:}] = ndgrid(range{:});
    
    coord = cellfun(@(x) x(:), coord, 'UniformOutput', false);
    nbcoord = cell2mat(coord);
    
    %pvt = (size(coord,1)+1) / 2;
    %nbcoord = [coord(1:pvt-1,:); coord(pvt+1:end,:)];
    
    nbcoord = [-1*eye(ndim); 1*eye(ndim); nbcoord];

end
