%This command computes the activation for a CMAC network with particular inputs.
function a = activate(q,x)
    %a = activate(q,x);
    %
    %x is the (2,1) input vector
    %q is the CMAC resolution vector
    %a is the (t,2) activation vector
    [n,pp,t] = size(q);
    %DIM = 2;
    %DIM = 3;
    DIM = 4;
    %DIM = 6;
    for i = 1:t
    %find x dimension by searching backward
        for k = 1:DIM
            j = n;
            while (j > 1) & ( x(k) < q(j,k,i) )
                j = j - 1;
            end;
            a(i,k) = j;
        end;
    end;
end