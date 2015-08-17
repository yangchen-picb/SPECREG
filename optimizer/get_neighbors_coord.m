function nbcoord = get_neighbors_coord(rad, dim)
% nbcoord = get_neighbors_coord(rad, dim = 3)
%
% 2013-05-02
%

    if nargin < 2
        dim = 3;
    end
    if nargin < 1
        rad = 1;
    end
    
    range = cell(1, dim);
    range(:) = {[-rad:rad]};
    
    coord = cell(1, dim);
    
    [coord{:}] = ndgrid(range{:});
    
    coord = cellfun(@(x) x(:), coord, 'UniformOutput', false);
    coord = cell2mat(coord);
    
    pvt = (size(coord,1)+1) / 2;
    nbcoord = [coord(1:pvt-1,:); coord(pvt+1:end,:)];

end
