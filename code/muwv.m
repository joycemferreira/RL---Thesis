%This command trains the neuro-controller (actor net and critic net) 
% with the stability constraints activated.
function [Q,W,V,Wmax,Wmin,Wt,Vmax,Vmin,Vt] = muwv(Q,q,W,V,N,a1,a2,muit,trace)
    %[Q,W,V,Wmax,Wmin,Wt,Vmax,Vmin,Vt] = muwv(Q,q,W,V,N,a1,a2,muit,trace)
    % Massa Mola
    
    A = [1.0 0.05; -0.05 0.9];
    B = [0; 1.0];
    Kp = 0.01; Ki = 0.001; %0.05;
    sum_err = 0;
    t = 0;
    r = (rand-0.5)*2; urand = 0;
    x = [0; 0];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Before we learn, make sure [W,V] are in mu bounds
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    maxmu = statmu(W,V);
    if ( maxmu > 1.0 )
        disp 'Warning: mu exceeds 1 for input matrices W,V'
        disp 'Learning Halted!'
    return;
    end;
    if ( trace )
        [h,n] = size(W);
        Wt = zeros(h,n,N);
        Vt = zeros(1,h,N);
    else
        Wt = 0;
        Vt = 0;
    end;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Outer Loop iterates over dW and dV -- used mu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for kk = 1:muit
        [dW,dV] = dynamu(W,V);
        dW = W.*0 + 1; dV = V.*0 + 1;
        Wmax = W + dW,W, Wmin = W - dW,
        Vmax = V + dV, V, Vmin = V - dV,
        j = 0;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Inner loop trains either till completion of iterations or until
        % we hit the mu-specified boundary
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        while ( j < N & gtm(W,Wmin) & gtm(Wmax,W) & gtm(V,Vmin) & gtm(Vmax,V))
            j = j + 1;
            if ( trace )
                Wt(:,:,j) = W;
                Vt(:,:,j) = V;
            end;
            %change reference signal
            rold = r;
            if ( rand < 0.01 ) r = (rand-0.5) * 2.0; end;
            err = (r-x(1));
            %compute upi
            sum_err = sum_err + err;
            upi = Kp * err + Ki * sum_err;
            %compute un
            c(1,1) = err;
            [un, v] = feedf(c,W,V);
            %random part
            if (rand < 0.1 ) urand = randn * 0.05;
            else urand = 0; end;
            un = un + urand;
            u = upi + un;
            %remember old values for use in TD backprop
            if ( t > 0 ) yold = y; aold = a; end
            %compute Q
            b(1,1) = err; b(2,1) = un;
            [y,a] = compute(Q,q,b);
            %TD backprop
            if ( t > 0 & rold == r )
                tar = 0.9 * y + abs(err);
                Q = learnQ(tar,yold,aold,Q,a1);
            end
            %compute minimum action
            yp = delta(Q,q,b,2);
            Wgood = W;
            Vgood = V;
            [W,V] = backprop(c,v,un,yp,a2,W,V);
            %update state
            t = t + 0.01; x = A*x + B*u;
            fprintf([int2str(j) '.']);
            if ( mod(j,20) == 0 ) fprintf('\n'); end;
        end; %outer for
        W = Wgood;
        V = Vgood;
end;
end