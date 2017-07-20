%This command computes the double gradient of the CMAC network.
function d = delta(Q,q,x,k)
    RES = 20;
    [n,dim,t] = size(q);
    minn = q(1,k,1);
    maxx = q(n,k,1) + q(n,k,1) - q(n-1,k,1);
    incr = ( maxx - minn ) / 20;
    mina = x(k) - incr;
    maxa = x(k) + incr;
    if ( mina < minn )
        mina = minn;
    end;
    if ( maxa > maxx )
        maxa = maxx;
    end;
    us = linspace(mina,maxa,RES);
    for i = 1:RES
        x(k) = us(i);
        v(i) = compute(Q,q,x);
    end;
    [mv, mp] = min(v);
    d = us(mp);
end