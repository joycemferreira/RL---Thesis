%This command computes the double gradient of the CMAC network.
function d = delta2(Q,q,x,k,j)
    RES = 20;
    [n,dim,t] = size(q);
    % First output
    minnk = q(1,k,1);
    maxxk = q(n,k,1) + q(n,k,1) - q(n-1,k,1);
    incrk = ( maxxk - minnk ) / 20;
    minak = x(k) - incrk;
    maxak = x(k) + incrk;
    if ( minak < minnk )
        minak = minnk;
    end;
    if ( maxak > maxxk )
        maxak = maxxk;
    end;
    
    % Second output
    minnj = q(1,j,1);
    maxxj = q(n,j,1) + q(n,j,1) - q(n-1,j,1);
    incrj = ( maxxj - minnj ) / 20;
    minaj = x(j) - incrj;
    maxaj = x(j) + incrj;
    if ( minaj < minnj )
        minaj = minnj;
    end;
    if ( maxaj > maxxj )
        maxaj = maxxj;
    end;
    
    usk = linspace(minak,maxak,RES);
    usj = linspace(minaj,maxaj,RES);
    v = zeros(RES,RES);
    for i = 1:RES
        for m = 1:RES
            x(k) = usk(i);
            x(j) = usj(m);
            v(i,m) = compute(Q,q,x);
        end;
    end
    
    [mv, mp] = min(v);
    [minn,col] = min(mv);
    row = mp(col);
    d = [usk(row); usj(col)];
    end