%This command computes diagonalization matrices required for the
% Simulink diagrams.
function [A,B,T] = diagFit(m,n)
    %[A,B,T] = diagFit(m,n)
    % or
    %[A,B,T] = diagFit(X)
    %
    % m,n is the dimension of a matrix X
    % let r = m*n
    % T is the r by r diagonal matrix that has each
    % entry of X in it (across first, then down)
    % example: X = | 3 7 | T = | 3 0 0 0 |
    % m=2 | 4 -1 | | 0 7 0 0 |
    % n=2 | 0 0 4 0 |
    % | 0 0 0 -1 |
    %
    % diagFit computesmatrices A and B such that A*T*B = X.
    % Produces test matrix T = diag(1..r) for testing.
    if (nargin < 2)
        [x,n] = size(m);
        clear m;
        m = x;
        clear x;
    end;
        r = m * n;
        A = zeros(m,r);
        B = zeros(r,n);
    for i = 1:r
        ka = floor( (i-1)/n ) + 1;
        kb = mod(i-1,n) + 1;
        A(ka,i) = 1;
        B(i,kb) = 1;
    end;
    T = diag(1:r);
end