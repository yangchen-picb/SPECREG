classdef Optimizer < handle
    % Abstract Class for Optimizer
    
    properties
    end
    
    methods        
        function [x, fval] = run(SS, fun, space, startPoints)
            if nargin < 4
                startPoints = [];
            end
			
        end
    end
end

