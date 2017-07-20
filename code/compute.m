%This command computes the output of a CMAC neural network.
function [y,a] = compute(Q,q,x)
    %[y,a] = compute(Q,q,x)
    [n,pp,t] = size(q);
    a = activate(q,x);
    y = 0;
    for i = 1:t
        % y = y + Q( a(i,1), a(i,2), a(i,3), a(i,4), a(i,5), a(i,6), i);
        y = y + Q( a(i,1), a(i,2), a(i,3), a(i,4), i);
        % y = y + Q( a(i,1), a(i,2), a(i,3), i);
        % y = y + Q( a(i,1), a(i,2), i);
    end;
end