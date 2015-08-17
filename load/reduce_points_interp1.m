function [D, WVN]=reduce_points(C,WVN,lvonw,lbisw,lanzahl)
% [D, WVN]=reduce_points(C,WVN,lvonw,lbisw,lanzahl)
% give slightly different results than reduce_points

[m,n,p] = size(C);
C = reshape(C, [m*n p]);

x = linspace(lvonw, lbisw, lanzahl);

D = interp1(WVN, C', x, 'linear');

D = reshape(D', m, n, lanzahl);
WVN = x;

