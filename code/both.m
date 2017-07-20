%This command trains the neuro-controller (actor net and critic net)
% without the stability constraints.
function [Q,W,V] = both(Q,q,W,V,N,a1,a2,AK,BK,CK,DK)
    %[Q,W,V] = both(Q,q,W,V,N,a1,a2,AK,BK,CK,DK)
%     A = [0.99867, 0; 0, 0.99867];
%     B = [-1.01315, 0.99700; -1.24855, 1.26471];
%     C = [-0.11547, 0; 0, -0.11547];
%     D = [0, 0; 0, 0];
    H = [tf([0 87.8],[75 1]) tf([0 -86.4],[75 1]) ; tf([0 108.2],[75 1]) tf([0 -109.6],[75 1])];
    Hd = c2d(H,.1);

    sys = ss(Hd);

    % Novo Sistema
    A = sys.A;
    B = sys.B;
    C = sys.C;
    D = sys.D;

    sum_err = 0;
    t = 0;
    r = [0; 0];
    x = [0; 0];
    y = [0; 0];
    sk = length(AK);
    k = zeros(sk,1);
    for i = 1:N
        %change reference signal
        rold = r;
        if ( mod(i,2000) == 1 )
            if ( rand < 0.5 )
                r(1,1) = 1 - r(1,1);
            else
                r(2,1) = 1 - r(2,1);
            end;
        end;
        err = r-y;
        %sum_err = sum_err + sum(abs(err));
        %compute u
        k = AK*k + BK*err;
        u = CK*k + DK*err;
        %compute un
        c(1,1) = 1;
        c(2,1) = err(1);
        c(3,1) = err(2);
        [un, v] = feedf(c,W,V);
        %random part
        if (rand < 0.1 ) urand = randn(2,1) .* 0.1;
        else urand = [0; 0]; end;
        %urand = 0;
        un = un + urand;
        u = un;
        u(1,1) = u(1,1) * 1.2;
        u(2,1) = u(2,1) * 0.8;
        %remember old values for use in TD backprop
        if ( t > 0 )
            qvalold = qval;
            activold = activ;
        end
        %compute Q
        b(1,1) = err(1);
        b(2,1) = err(2);
        b(3,1) = un(1);
        b(4,1) = un(2);
        [qval,activ] = compute(Q,q,b);
        
        %TD backprop
        if ( t > 0 & sum(abs(rold - r)) == 0 )
            tar = 0.95 * qval + sum(abs(err));
            Q = learnq(tar,qvalold,activold,Q,a1);
        end
        
        %compute minimum action
        yp = delta2(Q,q,b,3,4);
        [W,V] = backprop(c,v,un,yp,a2,W,V);
        
        %update state
        t = t + 0.1;
        x = A*x + B*u;
        y = C*x + D*u;
        %fprintf([int2str(i) '.']);
        if ( mod(i,2000) == 0 ) fprintf([int2str(i) '\n']); end;
    end; %outer for
end