%This command initializes a CMAC neural network.
function [Q,q] = setCMAC(n,t,mins,sizes)
    %[Q,q] = setCMAC(n,t,mins,sizes)
    %
    %Initializes a 4D CMAC network with t tilings of nxn grids
    % mins (4,1) sized vector of minimums per dimension
    % sizes (4,1) sized vector of sizes per dimension
    %DIM = 2;
    %DIM = 3;
    DIM = 4;
    %DIM = 6;
    %Q = zeros(n,n,n,n,n,n,t);
    Q = zeros(n,n,n,n,t);
    %Q = zeros(n,n,n,t);
    %Q = zeros(n,n,t);
    q = zeros(n,DIM,t);
    for k = 1:DIM
        incr(k) = sizes(k) / (n);
        off(k) = incr(k) / t;
    end;
    
    for i = 1:t
        for j = 1:n
            for k = 1:DIM
                q(j,k,i) = (j-1) * incr(k) + (i-1) * off(k) + mins(k);
            end;
        end;
    end;
end