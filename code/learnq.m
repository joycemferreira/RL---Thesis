%This command trains the CMAC network using the TD-error.
function Q = learnq(tar,cur,activ,Q,alpha)
    %Q = learnq(tar,cur,activ,Q,alpha)
    %[t1,n,t] = size(Q);
    %[t1,t2,n,t] = size(Q);
    [t1,t2,t3,n,t] = size(Q);
    %[t1,t2,t3,t4,t5,n,t] = size(Q);
    diff = (tar - cur) * alpha / t;
    for i = 1:t
        x1 = activ(i,1);
        x2 = activ(i,2);
        x3 = activ(i,3);
        x4 = activ(i,4);
        % x5 = activ(i,5);
        % x6 = activ(i,6);
        % Q(x1,x2,x3,x4,x5,x6,i) = Q(x1,x2,x3,x4,x5,x6,i) + diff;
        Q(x1,x2,x3,x4,i) = Q(x1,x2,x3,x4,i) + diff;
        % Q(x1,x2,x3,i) = Q(x1,x2,x3,i) + diff;
        % Q(x1,x2,i) = Q(x1,x2,i) + diff;
    end;
end